import 'package:flutter/material.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/store.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      navigatorKey: navigatorKey,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {},
      onNavigationRequest: (request) async {
        RiotService.accessToken = request.url.split('=')[1].split('&')[0];
        var entitlements = await RiotService().getEntitlements();
        RiotService().getUserId();
        print(RiotService.userId);
        await RiotService().getStore();
        await WebViewCookieManager().clearCookies();
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) {
            return StorePage(accessToken: request.url);
          },
        ));
        return NavigationDecision.navigate;
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
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
