import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:valstore/services/firebase_auth.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../services/riot_service.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) async {
        if (!request.url.contains("https://playvalorant.com/")) {
          return NavigationDecision.navigate;
        }

        RiotService.accessToken = request.url.split('=')[1].split('&')[0];
        await RiotService.getEntitlements();
        RiotService.getUserId();
        await RiotService.getUserData();
        //await RiotService().getUserOwnedItems();
        //await WebViewCookieManager().clearCookies();

        await FireStoreService().registerUser(RiotService.userId);

        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuthService().signInAnonymous();
        }

        navigatorKey.currentState!.pushNamed("/store");
        return NavigationDecision.prevent;
      },
    ))
    ..loadRequest(
      Uri.parse(RiotService.loginUrl),
    )
    ..clearLocalStorage()
    ..clearCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riot Games Sing in'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
