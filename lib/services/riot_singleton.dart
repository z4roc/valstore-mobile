import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/models/player.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class RiotSingleton {
  static RiotSingleton? _instance;

  late SharedPreferences prefs;

  String? accessToken;
  String region = "eu";
  String? entitlements;
  late Player user;

  static Future<void> initialize(String accessToken) async {
    _instance ??= RiotSingleton();
    _instance?.prefs = await SharedPreferences.getInstance();
    _instance?.accessToken = accessToken;
  }

  Future<bool> cookiesExist() async {
    if (prefs.getString("cookie") == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> authenticateUser() async {}

  Future<void> saveCookies() async {
    final authCookies = await WebviewCookieManager()
        .getCookies("https://auth.riotgames.com/login");
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
        "cookies",
        authCookies
            .map((cookie) => "${cookie.name}=${cookie.value}")
            .join("; "));
  }

  RiotSingleton get instance => _instance!;

  RiotSingleton();

  Map<String, String> urls = {
    "signin":
        "https://auth.riotgames.com/login#client_id=play-valorant-web-prod&nonce=1&redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&response_type=token%20id_token"
  };
}
