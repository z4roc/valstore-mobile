import 'package:flutter/material.dart';
import 'package:valstore/views/store.dart';
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
      onPageStarted: (url) {},
      onNavigationRequest: (request) async {
        RiotService.accessToken = request.url.split('=')[1].split('&')[0];
        await RiotService().getEntitlements();
        RiotService().getUserId();
        await RiotService().getUserData();
        //await WebViewCookieManager().clearCookies();
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) {
            return const StorePage();
          },
        ));
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
