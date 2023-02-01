import 'dart:convert';

import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:valstore/models/ValApiBundle.dart';
import 'package:valstore/models/bundle.dart';
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/store_offers.dart';

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

  static late PlayerInfo user;

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

  Future<List<Offers>> getStore() async {
    final shopRequest = await get(
      Uri.parse(storeUri),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken'
      },
    );

    final allShopJson = json.decode(shopRequest.body);
    final playerStoreJson = allShopJson['SkinsPanelLayout']['SingleItemOffers'];

    final offerRequest = await get(
      Uri.parse("https://api.henrikdev.xyz/valorant/v2/store-offers"),
    );

    StoreOffers storeOffers =
        StoreOffers.fromJson(jsonDecode(offerRequest.body));

    List<Offers> shop = [];

    for (var item in playerStoreJson) {
      shop.add(storeOffers.data!.offers!
          .where((offer) => offer.offerId == item)
          .first);
    }

    /*for (var offer in playerStoreJson) {
      var offerData = await get(
        Uri.parse("https://valorant-api.com/v1/weapons/skinlevels/$offer"),
      );
      shop.add(json.decode(offerData.body)['data']);
    }*/

    return shop;
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

    final resultJson = json.decode(bannerRequest.body)['data'];

    user = PlayerInfo.fromJson(resultJson);
    region = user.region!;
  }

  Future<BundleDisplayData?> getCurrentBundle() async {
    final bundleRequest = await get(
      Uri.parse('https://api.henrikdev.xyz/valorant/v2/store-featured'),
    );

    final bundleJson = json.decode(bundleRequest.body);

    Bundle bundle = Bundle.fromJson(bundleJson);

    final imgRequest = await get(
      Uri.parse(
        'https://valorant-api.com/v1/bundles/${bundle.data![0].bundleUuid!}',
      ),
    );

    final valApiJson = json.decode(imgRequest.body);

    ValApiBundle apiBundle = ValApiBundle.fromJson(valApiJson);

    BundleDisplayData bdd =
        BundleDisplayData(bundleData: apiBundle.data, data: bundle.data![0]);

    return bdd;
  }
}
