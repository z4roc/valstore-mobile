import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/models/auth.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/player_inventory.dart';
import 'package:valstore/models/store_models.dart';
import 'package:valstore/models/val_api_bundle.dart';
import 'package:valstore/models/bundle.dart' as b;
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/val_api_skins.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/notifcation_service.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class RiotService {
  static String region = "eu";
  static String loginUrl =
      'https://auth.riotgames.com/login#client_id=play-valorant-web-prod&nonce=1&redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&response_type=token%20id_token';
  static String entitlementsUri =
      'https://entitlements.auth.riotgames.com/api/token/v1/';
  static String storeUri =
      "https://pd.$region.a.pvp.net/store/v2/storefront/$userId/";
  static String accessToken = "";
  static String entitlements = "";
  static String cookies = "";
  static String userId = "";

  static late List<Cookie>? authCookies = null;
  static late Player user;
  static late PlayerShop? playerShop = null;
  static late NightMarket? nightMarket = null;

  static void getUserId() {
    userId = Jwt.parseJwt(accessToken)['sub'];
  }

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
    authCookies = await WebviewCookieManager()
        .getCookies("https://auth.riotgames.com/login");
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
        "cookie",
        authCookies
                ?.map((cookie) => "${cookie.name}=${cookie.value}")
                .join("; ") ??
            "");
  }

  static Future<void> recheckStore() async {
    await reuathenticateUser();

    final store = await getStore(0);

    final wishlist = await FireStoreService().getUserWishlist(userId);

    for (var element in store.skins) {
      if (wishlist.contains(element.offerId)) {
        showNotification(
          title: "Skin arrived!",
          body: "${element.name} is available in your shop",
        );
      }
    }
  }

  static Future<void> reuathenticateUser() async {
    final prefs = await SharedPreferences.getInstance();

    final cookies = authCookies
            ?.map((cookie) => "${cookie.name}=${cookie.value}")
            .join("; ") ??
        (prefs.getString("cookie") ?? "");

    final res = await post(
      Uri.parse("https://auth.riotgames.com/api/v1/authorization"),
      headers: {
        "User-Agent":
            "RiotClient/06.11.00.900116 rso-auth (Windows; 10;;Professional, x64)",
        "Content-Type": "application/json",
        "cookie": cookies,
      },
      body: jsonEncode({
        "client_id": "play-valorant-web-prod",
        "nonce": 1,
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
    //var client = http.Client();
    await getEntitlements();
    getUserId();
    await RiotService().getUserData();
    /*var request = http.Request("HEAD", Uri.parse(loginUrl));
    
    request.headers['cookie'] = authCookies!
        .map((cookie) => "${cookie.name}=${cookie.value}")
        .join("; ");

    request.headers['Content-Type'] = "appliaction/json";

    request.followRedirects = false;

    request.body = json.encode({
      'client_id': "play-valorant-web-prod",
      'nonce': 1,
      'redirect_uri': "https://playvalorant.com/opt_in",
      'response_type': "token id_token",
      'scope': "account ban link lol offline_access openid"
    });

    

    final cookieJar = CookieJar();

    cookieJar.saveFromResponse(
        Uri.parse("https://auth.riotgames.com"),
        authCookies!
            .where(
                (element) => element.name == "ssid" || element.name == "tdid")
            .toList());

    dio.interceptors.add(CookieManager(cookieJar));

    //final temp = await cookieJar.loadForRequest(Uri.parse(loginUrl));
    dio.options.followRedirects = false;

    dio.options.headers['cookie'] = authCookies!
        .map((cookie) => "${cookie.name}=${cookie.value}")
        .join("; ");

    final dioRequest = await dio.get(loginUrl);

    //var response = await client.send(request);

    /*if (response.statusCode == 200) {
      print(response.stream.toString());
    }*/

    print(dioRequest.headers['set-cookie']);

    if (dioRequest.isRedirect) {
      print(dioRequest.headers['location']);
    }*/
  }

  Future<String> getPlayerLadout() async {
    return "";
  }

  static Future<PlayerShop> getStore(int sort) async {
    if (playerShop != null) {
      if (sort == 1) {
        playerShop!.skins.sort((a, b) {
          return b.cost! - a.cost!;
        });
      } else if (sort == 2) {
        playerShop!.skins.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }
      return playerShop!;
    }

    final test = accessToken;

    final shopRequest = await get(
      Uri.parse(storeUri),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken'
      },
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);
    final playerStoreJson = allShopJson['SkinsPanelLayout']['SingleItemOffers'];
    final shopRemains = allShopJson['SkinsPanelLayout']
        ['SingleItemOffersRemainingDurationInSeconds'];

    /*final offerRequest = await get(
      Uri.parse("https://api.henrikdev.xyz/valorant/v2/store-offers"),
    );

    StoreOffers storeOffers =
        StoreOffers.fromJson(jsonDecode(offerRequest.body));*/

    List<FirebaseSkin> shop = [];

    for (var item in playerStoreJson) {
      var firebaseSkin = await FireStoreService().getSkin(item);
      if (firebaseSkin != null) {
        shop.add(firebaseSkin);
      } else {
        shop.add(FirebaseSkin());
      }
    }

    /*for (var offer in playerStoreJson) {
      var offerData = await get(
        Uri.parse("https://valorant-api.com/v1/weapons/skinlevels/$offer"),
      );
      shop.add(json.decode(offerData.body)['data']);
    }*/
    if (sort == 1) {
      shop.sort((a, b) {
        return b.cost! - a.cost!;
      });
    } else if (sort == 2) {
      shop.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    }

    playerShop = PlayerShop(storeRemaining: shopRemains, skins: shop);
    return playerShop!;
  }

  static Future<NightMarket?> getNightMarket() async {
    if (nightMarket != null) {
      return nightMarket;
    }

    final shopRequest = await get(
      Uri.parse(storeUri),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken'
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

  static Future<int> getStoreTimer() async {
    final shopRequest = await get(
      Uri.parse(storeUri),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken'
      },
    );

    final body = shopRequest.body;
    final allShopJson = json.decode(body);
    final shopRemains = allShopJson['SkinsPanelLayout']
        ['SingleItemOffersRemainingDurationInSeconds'];
    return shopRemains;
  }

  Future<void> getUserData() async {
    final pInfoRequest =
        await get(Uri.parse("https://auth.riotgames.com/userinfo"), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    final bdytmp = pInfoRequest.body;

    final userRequest = await put(
      Uri.parse("https://pd.$region.a.pvp.net/name-service/v2/players"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-Riot-Entitlements-JWT': entitlements,
      },
      body: jsonEncode(
        <String>[userId],
      ),
    );

    final userResult = json.decode(userRequest.body);

    final bannerRequest = await get(
      Uri.parse(
          'https://api.henrikdev.xyz/valorant/v1/account/${userResult[0]['GameName']}/${userResult[0]['TagLine']}'),
    );

    final balanceRequest = await get(
      Uri.parse("https://pd.$region.a.pvp.net/store/v1/wallet/$userId/"),
      headers: {
        "X-Riot-Entitlements-JWT": entitlements,
        "Authorization": "Bearer $accessToken",
      },
    );

    try {
      final resultJson = json.decode(bannerRequest.body)['data'];
      final balanceResult = json.decode(balanceRequest.body);

      PlayerInfo info = PlayerInfo.fromJson(resultJson);

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
            valorantPoints: balanceResult["Balances"]
                [currencies["valorantPoints"]],
            radianitePoints: balanceResult["Balances"]
                [currencies["radianitePoints"]],
            freeAgents: balanceResult["Balances"][currencies["freeAgents"]],
          ));
      region = user.playerInfo!.region!;
    } catch (e) {
      user = Player(
        playerInfo: PlayerInfo(
          name: "Unknown",
          tag: "EUW",
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
  }

  Future<List<BundleDisplayData?>> getCurrentBundle() async {
    final bundleRequest = await get(
      Uri.parse('https://api.henrikdev.xyz/valorant/v2/store-featured'),
    );

    final bundleJson = json.decode(bundleRequest.body);

    b.Bundle bundle = b.Bundle.fromJson(bundleJson);

    List<BundleDisplayData> bundles = [];

    for (var item in bundle.data!) {
      final imgRequest = await get(
        Uri.parse(
          'https://valorant-api.com/v1/bundles/${item.bundleUuid!}',
        ),
      );

      final valApiJson = json.decode(imgRequest.body);

      ValApiBundle apiBundle = ValApiBundle.fromJson(valApiJson);
      item.items!.sort(((a, b) => b.basePrice! - a.basePrice!));

      bundles.add(BundleDisplayData(bundleData: apiBundle.data, data: item));
    }

    return bundles;
  }

  Future<List<Data?>?> getUserOwnedItems() async {
    final inventoryRequest = await get(
      Uri.parse(
          "https://pd.$region.a.pvp.net/store/v1/entitlements/$userId/${itemTypes['skins']}"),
      headers: {
        'Content-Type': 'application/json',
        "X-Riot-Entitlements-JWT": entitlements,
        "Authorization": "Bearer $accessToken",
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

  Future<ValApiSkins?> getAllSkins() async {
    final allSkins = jsonDecode((await get(
      Uri.parse("https://valorant-api.com/v1/weapons/skins"),
    ))
        .body);

    return ValApiSkins.fromJson(allSkins);
  }
}

Map<String, String> currencies = {
  "valorantPoints": "85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741",
  "radianitePoints": "e59aa87c-4cbf-517a-5983-6e81511be9b7",
  "freeAgents": "f08d4ae3-939c-4576-ab26-09ce1f23bb37",
};

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
