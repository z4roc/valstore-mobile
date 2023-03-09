import 'dart:convert';

import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/store_models.dart';
import 'package:valstore/models/val_api_bundle.dart';
import 'package:valstore/models/bundle.dart' as b;
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/services/firestore_service.dart';

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
  static String userId = "";

  static late Player user;
  static late PlayerShop? playerShop = null;
  static late NightMarket? nightMarket = null;

  void getUserId() {
    userId = Jwt.parseJwt(accessToken)['sub'];
  }

  Future<String> getEntitlements() async {
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

  Future<PlayerShop> getStore(int sort) async {
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

  Future<NightMarket?> getNightMarket() async {
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

  Future<int> getStoreTimer() async {
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
    final userRequest = await put(
      Uri.parse("https://pd.$region.a.pvp.net/name-service/v2/players"),
      headers: {
        'Content-Type': 'application/json',
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

      user = Player(
          playerInfo: PlayerInfo.fromJson(resultJson),
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
}

Map<String, String> currencies = {
  "valorantPoints": "85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741",
  "radianitePoints": "e59aa87c-4cbf-517a-5983-6e81511be9b7",
  "freeAgents": "f08d4ae3-939c-4576-ab26-09ce1f23bb37",
};
