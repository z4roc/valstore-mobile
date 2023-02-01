import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/store.dart';
import 'package:valstore/theme.dart';
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
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
          navigatorKey: navigatorKey,
          theme: light,
          darkTheme: dark,
          themeMode: themeProvider.themeMode,
        );
      },
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
        await RiotService().getEntitlements();
        RiotService().getUserId();
        await RiotService().getStore();
        //await WebViewCookieManager().clearCookies();
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
