import 'package:valstore/main.dart';
import 'package:valstore/views/bundle.dart';
import 'package:valstore/views/night_market_page.dart';
import 'package:valstore/views/store.dart';
import 'package:valstore/views/web_view.dart';

final routes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const WebViewPage(),
  '/store': (context) => const StorePage(),
  '/nightmarket': (context) => const NightMarketPage(),
  '/bundle': (context) => const BundlePage(),
};
