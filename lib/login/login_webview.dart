import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:valstore/services/firestore_service.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../services/riot_service.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  static String userAgent =
      "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36";

  InAppWebViewController? controller;
  /*..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setUserAgent(userAgent)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) async {
        if (!request.url.contains("https://playvalorant.com/")) {
          return NavigationDecision.navigate;
        }

        RiotService.accessToken = request.url.split('=')[1].split('&')[0];
        await RiotService.getEntitlements();
        RiotService.getUserId();
        //await RiotService.getUserData();
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
      Uri.parse(RiotService.newLoginUrl),
    )
    ..clearLocalStorage()
    ..clearCache();
*/
  InAppWebViewSettings settings = InAppWebViewSettings(
    userAgent: userAgent,
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    cacheMode: CacheMode.LOAD_NO_CACHE,
  );

  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                controller?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                controller?.loadUrl(
                    urlRequest: URLRequest(url: await controller?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riot Games Sign In'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Remember to accept cookies and click on \"Stay signed in\""),
          ),
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: WebUri(RiotService.newLoginUrl),
              ),
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
              shouldOverrideUrlLoading: (controller, navigationResponse) async {
                final newUrl = navigationResponse.request.toString();

                if (!newUrl.contains("https://playvalorant.com/")) {
                  return NavigationActionPolicy.ALLOW;
                }

                RiotService.accessToken = newUrl.split('=')[1].split('&')[0];
                await RiotService.getEntitlements();
                RiotService.getUserId();
                //await RiotService.getUserData();
                //await RiotService().getUserOwnedItems();
                //await WebViewCookieManager().clearCookies();

                await FireStoreService().registerUser(RiotService.userId);
                /*
                if (FirebaseAuth.instance.currentUser == null) {
                  await FirebaseAuthService().signInAnonymous();
                }*/

                navigatorKey.currentState!.pushNamed("/store");
                return NavigationActionPolicy.CANCEL;
              },
            ),
          ),
        ],
      ),
    );
  }
}
