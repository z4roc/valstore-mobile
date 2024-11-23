import 'dart:convert';
import "dart:developer";

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/models/auth.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/loadout.dart';
import 'package:valstore/models/local_offers.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/player_inventory.dart';
import 'package:valstore/models/store_models.dart';
import 'package:valstore/models/storefront.dart' as sf;
import 'package:valstore/models/val_api_bundle.dart';
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/val_api_skins.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/inofficial_valorant_api.dart';
import 'package:valstore/services/notifcation_service.dart';

class RiotService {
  static String? region = null;
  static String newLoginUrl =
      "https://auth.riotgames.com/authorize?redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&client_id=play-valorant-web-prod&response_type=token%20id_token&nonce=1&scope=account%20openid";
  static String loginUrl =
      'https://auth.riotgames.com/login#client_id=play-valorant-web-prod&nonce=1&redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&response_type=token%20id_token';
  static String entitlementsUri =
      'https://entitlements.auth.riotgames.com/api/token/v1/';

  static String accessToken = "";
  static String entitlements = "";
  static String cookies = "";
  static String userId = "";
  static List<PlayerLoadoutItem>? playerLoadout;

  static late List<Cookie>? authCookies = null;
  static late Player user;
  static late PlayerShop? playerShop = null;
  static late NightMarket? nightMarket = null;

  static late sf.Storefront? userOffers;

  static void getUserId() {
    userId = Jwt.parseJwt(accessToken)['sub'];
  }

  static String getStoreLink(String uuid, String region) =>
      "https://pd.$region.a.pvp.net/store/v3/storefront/$uuid";

  static Future<String> getEntitlements() async {
    await saveCookies();

    var entitlementsRequest = await post(
      Uri.parse(entitlementsUri),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    final result = json.decode(entitlementsRequest.body);

    entitlements = result['entitlements_token'];
    return entitlementsRequest.body;
  }

  static Future<void> saveCookies() async {
    CookieManager cookieManager = CookieManager.instance();
    final prefs = await SharedPreferences.getInstance();
    authCookies = await cookieManager.getCookies(
      url: WebUri("https://auth.riotgames.com/login"),
    );
    /*authCookies = await WebviewCookieManager()
        .getCookies("https://auth.riotgames.com/login");
    
    */
    prefs.setString(
        "cookie",
        authCookies
                ?.map((cookie) => "${cookie.name}=${cookie.value}")
                .join("; ") ??
            "");
  }

  static Future<void> recheckStore() async {
    await reuathenticateUser();
    final prefs = await SharedPreferences.getInstance();
    region ??= prefs.getString("region") ?? "eu";
    final store = await getStore();

    final wishlist = await FireStoreService().getUserWishlist(userId);

    for (var element in store.skins) {
      if (wishlist.contains(element.offerId)) {
        final imageReq = await get(Uri.parse(element.icon!));
        final image = imageReq.bodyBytes;
        await NotificationService.showInstantNotification(
          "Skin arrived!",
          "${element.name} is available in your shop",
          image,
        );
      }
    }
  }

  static Future<void> recheckBundle() async {
    final prefs = await SharedPreferences.getInstance();

    final bundleUid = prefs.getString("currentBundle");

    final bundle = await getUserOffers();

    final newBundleId = bundle.featuredBundle?.bundle?.dataAssetID;

    if (bundleUid != newBundleId) {
      if (newBundleId != null) {
        await prefs.setString("currentBundle", newBundleId);

        final bundleData = await get(
            Uri.parse("https://valorant-api.com/v1/bundles/$newBundleId"));

        final bundleImage = await get(Uri.parse(
            "https://media.valorant-api.com/bundles/$newBundleId/displayicon.png"));

        final bundleName = jsonDecode(bundleData.body)['data']['displayName'];
        await NotificationService.showInstantNotification(
          "New Bundle Available!",
          "The $bundleName Bundle is now available for purchase",
          bundleImage.bodyBytes,
        );
      }
    }
  }

  static Future<void> reuathenticateUser() async {
    final prefs = await SharedPreferences.getInstance();
    String version = "";
    try {
      version = (await InofficialValorantAPI().getCurrentVersion())['version'];
    } catch (e) {
      version = "08.09.00.2521387";
    }

    final cookies = authCookies
            ?.map((cookie) => "${cookie.name}=${cookie.value}")
            .join("; ") ??
        (prefs.getString("cookie") ?? "");

    final res = await post(
      Uri.parse("https://auth.riotgames.com/api/v1/authorization"),
      headers: {
        "User-Agent":
            "RiotClient/$version rso-auth (Windows; 10;;Professional, x64)",
        "Content-Type": "application/json",
        "cookie": cookies,
      },
      body: jsonEncode({
        "client_id": "play-valorant-web-prod",
        "nonce": "1",
        "redirect_uri": "https://playvalorant.com/opt_in",
        "response_type": "token id_token",
        "response_mode": "query",
        "scope": "account openid",
      }),
    );
    final auth = Reauth.fromJson(jsonDecode(res.body));

    RiotService.accessToken =
        auth.response?.parameters?.uri?.split('=')[1].split('&')[0] ??
            RiotService.accessToken;
    await getEntitlements();
    getUserId();
  }

  static Future<Loadout> getPlayerLadout() async {
    final request = await get(
      Uri.parse(
          "https://pd.$region.a.pvp.net/personalization/v2/players/$userId/playerloadout"),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
    );

    final loadoutJson = jsonDecode(request.body);

    final loadout = Loadout.fromJson(loadoutJson);

    return loadout;
  }

  static Future<List<PlayerLoadoutItem>> getPlayerEquipedSkins() async {
    if (playerLoadout != null) {
      return playerLoadout!;
    }

    final loadout = await getPlayerLadout();

    final allSkins = await getAllSkins();

    List<PlayerLoadoutItem> skins = [];

    for (var item in loadout.guns ?? <Guns>[]) {
      final fbSkin =
          await FireStoreService().getSkinBySkinId(item.skinID ?? "");

      FirebaseSkin skin;

      if (fbSkin == null) {
        final match =
            allSkins?.data?.where((s) => s.uuid == item.skinID).firstOrNull;

        skin = FirebaseSkin(
          name: match?.displayName,
          icon: match?.displayIcon,
        );

        skin.levels = match?.levels;
        skin.chromas = match?.chromas;
      } else {
        skin = fbSkin;
      }

      skins.add(PlayerLoadoutItem(gun: item, skin: skin));
    }
    playerLoadout = skins;
    return skins;
  }

  static Map<dynamic, String> clientPlatform = {
    "platformType": "PC",
    "platformOS": "Windows",
    "platformOSVersion": "10.0.19042.1.256.64bit",
    "platformChipset": "Unknown",
  };

  static Map<dynamic, String> platformHeaders = {
    "X-Riot-ClientVersion": "release-09.09-shipping-11-2953160",
    "X-Riot-ClientPlatform":
        const Base64Encoder().convert(utf8.encode(jsonEncode(clientPlatform))),
  };

  static Future<PlayerShop> getStore() async {
    if (playerShop != null) {
      if (playerShop!.lastUpdated.difference(DateTime.now()).inHours < 1) {
        return playerShop!;
      }
      if (playerShop!.lastUpdated.difference(DateTime.now()).inHours < 1) {
        return playerShop!;
      }
    }

    final shopRequest = await post(
      Uri.parse(getStoreLink(userId, region!)),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
      body: jsonEncode({}),
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);
    final playerStoreJson = allShopJson['SkinsPanelLayout']['SingleItemOffers'];
    final shopRemains = allShopJson['SkinsPanelLayout']
        ['SingleItemOffersRemainingDurationInSeconds'];

    List<FirebaseSkin> shop = [];

    for (var item in playerStoreJson) {
      var firebaseSkin = await FireStoreService().getSkin(item);
      if (firebaseSkin != null) {
        shop.add(firebaseSkin);
      } else {
        shop.add(FirebaseSkin());
      }
    }
    playerShop = PlayerShop(
        storeRemaining: shopRemains, skins: shop, lastUpdated: DateTime.now());
    return playerShop!;
  }

  static Future<NightMarket?> getNightMarket() async {
    if (nightMarket != null) {
      return nightMarket;
    }

    final shopRequest = await get(
      Uri.parse(getStoreLink(userId, region!)),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);

    var shop = Shop.fromJson(allShopJson);
    if (shop.bonusStore == null) return null;

    List<NightMarketSkin> nightMarketSkins = [];

    for (var offer in shop.bonusStore!.bonusStoreOffers!) {
      var firebaseSkin =
          await FireStoreService().getSkin(offer.offer!.offerID!);

      nightMarketSkins.add(NightMarketSkin(
        skinData: firebaseSkin,
        percentageReduced: offer.discountPercent,
      ));
    }
    nightMarket = NightMarket(
      durationRemain: shop.bonusStore!.bonusStoreRemainingDurationInSeconds,
      skins: nightMarketSkins,
    );

    return nightMarket;
  }

  static Future<sf.Storefront> getUserOffers() async {
    final shopRequest = await post(
      Uri.parse(getStoreLink(userId, region!)),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        "Content-Type": "application/json",
        ...platformHeaders,
      },
      body: jsonEncode({}),
    );
    final offers = jsonDecode(shopRequest.body);
    if (kDebugMode) {
      log(shopRequest.body);
    }
    final shopRemains = sf.Storefront.fromJson(offers);
    return shopRemains;
  }

  static Future<LocalOffers> getLocalOffers() async {
    final shopRequest = await get(
      Uri.parse("https://pd.$region.a.pvp.net/store/v2/offers/"),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);
    final shopRemains = LocalOffers.fromJson(allShopJson);
    return shopRemains;
  }

  static Future<int> getStoreTimer() async {
    final shopRequest = await get(
      Uri.parse(getStoreLink(userId, region!)),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);
    final shopRemains = allShopJson['SkinsPanelLayout']
        ['SingleItemOffersRemainingDurationInSeconds'];
    return shopRemains;
  }

  static Future<int?> getPlayerLevel() async {
    final xpRequest = await get(
      Uri.parse("https://pd.$region.a.pvp.net/account-xp/v1/players/$userId"),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken',
        ...platformHeaders,
      },
    );
    final progress = PlayerXP.fromJson(jsonDecode(xpRequest.body));

    return progress.progress?.level ?? 0;
  }

  static Future<Player> getUserData() async {
    final userRequest = await put(
      Uri.parse("https://pd.$region.a.pvp.net/name-service/v2/players"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-Riot-Entitlements-JWT': entitlements,
        ...platformHeaders,
      },
      body: jsonEncode(
        <String>[userId],
      ),
    );

    final userResult = json.decode(userRequest.body);

    final balanceRequest = await get(
      Uri.parse("https://pd.$region.a.pvp.net/store/v1/wallet/$userId/"),
      headers: {
        "X-Riot-Entitlements-JWT": entitlements,
        "Authorization": "Bearer $accessToken",
        ...platformHeaders,
      },
    );

    try {
      final loadOut = await getPlayerLadout();
      final balanceResult = json.decode(balanceRequest.body);
      final accountLevel = await getPlayerLevel();
      PlayerInfo info = PlayerInfo(
        accountLevel: accountLevel ?? 0,
        card: Card(
          id: loadOut.identity?.playerCardID ?? "",
          small:
              "https://media.valorant-api.com/playercards/${loadOut.identity?.playerCardID}/smallart.png",
          wide:
              "https://media.valorant-api.com/playercards/${loadOut.identity?.playerCardID}/wideart.png",
          large:
              "https://media.valorant-api.com/playercards/${loadOut.identity?.playerCardID}/largeart.png",
        ),
        name: userResult[0]['GameName'],
        tag: userResult[0]['TagLine'],
        puuid: userResult[0]['Subject'],
        region: RiotService.region,
      );

      if (info.card?.id == "00000000-0000-0000-0000-000000000000") {
        info.card = Card(
            small:
                "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/smallart.png",
            large:
                "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/largeart.png",
            wide:
                "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/wideart.png",
            id: "9fb348bc-41a0-91ad-8a3e-818035c4e561");
      }

      final levelBorder = (await InofficialValorantAPI().getLevelBorders())
          .borders
          ?.where((element) => info.accountLevel! < element.startingLevel!)
          .first;

      info.card ??
          Card(
              small:
                  "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/smallart.png",
              large:
                  "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/largeart.png",
              wide:
                  "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/wideart.png",
              id: "9fb348bc-41a0-91ad-8a3e-818035c4e561");

      user = Player(
        playerInfo: info,
        wallet: Wallet(
          valorantPoints: balanceResult["Balances"][Currencies.valorantPoints],
          radianitePoints: balanceResult["Balances"]
              [Currencies.radianitePoints],
          freeAgents: balanceResult["Balances"][Currencies.freeAgents],
          kingdomCredits: balanceResult["Balances"][Currencies.kingdomCredits],
        ),
        levelBorder: levelBorder,
      );
      region = user.playerInfo!.region!;
    } catch (e) {
      user = Player(
        playerInfo: PlayerInfo(
          name: "Unknown",
          tag: "Player",
          accountLevel: 0,
          card: Card(
            wide:
                "https://media.valorant-api.com/playercards/9fb348bc-41a0-91ad-8a3e-818035c4e561/wideart.png",
          ),
        ),
        wallet: Wallet(
          valorantPoints: 0,
          freeAgents: 0,
          radianitePoints: 0,
        ),
      );
    }

    return user;
  }

  static Future<List<BundleDisplayData?>> getCurrentBundle() async {
    final bundleLocal = await getUserOffers();
    final allsSkins = await getAllSkins();
    final sf.FeaturedBundle? bundleData = bundleLocal.featuredBundle;

    List<BundleDisplayData> bundles = [];

    for (var item in bundleData?.bundles ?? <sf.Bundle>[]) {
      final imgRequest = await get(
        Uri.parse(
          'https://valorant-api.com/v1/bundles/${item.dataAssetID!}',
        ),
      );

      final valApiJson = json.decode(imgRequest.body);

      ValApiBundle apiBundle = ValApiBundle.fromJson(valApiJson);

      final skins = <FirebaseSkin>[];
      for (var offer in item.itemOffers ?? <sf.ItemOffer>[]) {
        final skin = allsSkins?.data
            ?.where((element) => element.levels?[0].uuid == offer.offer.offerID)
            .firstOrNull;

        if (skin != null) {
          int cost = item.items!
                  .where(
                      (element) => element.item.itemID == offer.offer.offerID)
                  .firstOrNull
                  ?.basePrice ??
              0;

          skins.add(FirebaseSkin(
            name: skin.displayName,
            cost: cost,
            contentTier: getContentTierByCost(cost),
            icon: skin.displayIcon,
            levels: skin.levels,
            chromas: skin.chromas,
            offerId: offer.offer?.offerID,
            skinId: skin.uuid,
          ));
        }
        if (kDebugMode) {
          print(skin);
        }
      }
      final newBundleItem = BundleDisplayData(
          bundleData: apiBundle.data, data: item, skins: skins);

      bundles.add(newBundleItem);
    }

    return bundles;
  }

  static ContentTier getContentTierByCost(int cost) {
    String color = "";
    String icon = "";
    switch (cost) {
      case 875:
        color = "5b9cdd";
        icon =
            "https://media.valorant-api.com/contenttiers/12683d76-48d7-84a3-4e09-6985794f0445/displayicon.png";
        break;
      case 1275:
        color = "28bda7";
        icon =
            "https://media.valorant-api.com/contenttiers/0cebb8be-46d7-c12a-d306-e9907bfc5a25/displayicon.png";
        break;
      case 1775:
        color = "cb558d";
        icon =
            "https://media.valorant-api.com/contenttiers/60bca009-4182-7998-dee7-b8a2558dc369/displayicon.png";
        break;
      case 2175:
        color = "fd9257";
        icon =
            "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
        break;
      case 2475:
        color = "eed878";
        icon =
            "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
        break;

      default:
        if (cost > 2475 && cost < 4950) {
          color = "fd9257";
          icon =
              "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
        } else if (cost >= 4950) {
          color = "eed878";
          icon =
              "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
        }
        break;
    }
    return ContentTier(color: color, icon: icon);
  }

  static Future<List<Data?>?> getUserOwnedItems() async {
    final inventoryRequest = await get(
      Uri.parse(
          "https://pd.$region.a.pvp.net/store/v1/entitlements/$userId/${itemTypes['skins']}"),
      headers: {
        'Content-Type': 'application/json',
        "X-Riot-Entitlements-JWT": entitlements,
        "Authorization": "Bearer $accessToken",
        ...platformHeaders,
      },
    );

    final inventoryJson = jsonDecode(inventoryRequest.body);

    final data = await getAllSkins();
    final playerInventory = Inventory.fromJson(inventoryJson);

    final skinDatas = playerInventory.entitlements
        ?.map((e) => data?.data
            ?.where((element) => element.levels?[0].uuid == e.itemID)
            .firstOrNull)
        .toList();

    skinDatas?.removeWhere((element) => element == null);

    return skinDatas;
  }

  static Future<ValApiSkins?> getAllSkins() async {
    final allSkins = jsonDecode((await get(
      Uri.parse("https://valorant-api.com/v1/weapons/skins"),
    ))
        .body);

    return ValApiSkins.fromJson(allSkins);
  }

  static Future<void> recheckNightmarket() async {
    final nightMarket = await getNightMarket();
    final prefs = await SharedPreferences.getInstance();
    if (nightMarket == null) {
      await prefs.setBool("didNotifyNM", false);
      return;
    } else {
      if (prefs.getBool("didNotifyNM") ?? false) {
        return;
      } else {
        await NotificationService.showInstantNotificationWithoutPicture(
          "Night market is back!",
          "The Night Market is available again.",
        );
      }
    }
  }

  static Future<ValApiSkins?> getAllPurchasableSkins() async {
    ValApiSkins? allSkins = await getAllSkins();

    final allOffers = await getLocalOffers();

    allSkins?.data = allSkins.data
        ?.where((skin) =>
            allOffers.offers
                ?.any((offer) => skin.levels?[0].uuid == offer.offerID) ??
            false)
        .toList();

    return allSkins;
  }
}

class Currencies {
  static const String valorantPoints = "85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741";
  static const String radianitePoints = "e59aa87c-4cbf-517a-5983-6e81511be9b7";
  static const String freeAgents = "f08d4ae3-939c-4576-ab26-09ce1f23bb37";
  static const String kingdomCredits = "85ca954a-41f2-ce94-9b45-8ca3dd39a00d";
}

Map<String, String> itemTypes = {
  "agents": "01bb38e1-da47-4e6a-9b3d-945fe4655707",
  "contracts": "f85cb6f7-33e5-4dc8-b609-ec7212301948",
  "sprays": "d5f120f8-ff8c-4aac-92ea-f2b5acbe9475",
  "gun_buddies": "dd3bf334-87f3-40bd-b043-682a57a8dc3a",
  "cards": "3f296c07-64c3-494c-923b-fe692a4fa1bd",
  "skins": "e7c63390-eda7-46e0-bb7a-a6abdacd2433",
  "skin_variants": "3ad1b2b2-acdb-4524-852f-954a76ddae0a",
  "titles": "de7caa6b-adf7-4588-bbd1-143831e786c6",
};
