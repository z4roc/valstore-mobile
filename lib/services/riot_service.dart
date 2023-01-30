import 'dart:convert';

import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';

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

  Future<List<dynamic>> getStore() async {
    final shopRequest = await get(
      Uri.parse(storeUri),
      headers: {
        'X-Riot-Entitlements-JWT': entitlements,
        'Authorization': 'Bearer $accessToken'
      },
    );

    final allShopJson = json.decode(shopRequest.body);
    final playerStoreJson = allShopJson['SkinsPanelLayout']['SingleItemOffers'];

    var shop = [];

    for (var offer in playerStoreJson) {
      var offerData = await get(
        Uri.parse("https://valorant-api.com/v1/weapons/skinlevels/$offer"),
      );
      shop.add(json.decode(offerData.body)['data']);
    }

    return shop;
  }
}
