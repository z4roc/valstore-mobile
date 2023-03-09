import 'package:valstore/main.dart';
import 'package:valstore/views/about_page.dart';
import 'package:valstore/views/account_page.dart';
import 'package:valstore/views/bundle_page.dart';
import 'package:valstore/views/night_market_page.dart';
import 'package:valstore/views/store.dart';
import 'package:valstore/views/web_view.dart';

final routes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const WebViewPage(),
  '/store': (context) => const StorePage(),
  '/nightmarket': (context) => const NightMarketPage(),
  '/bundle': (context) => const BundlePage(),
  '/account': (context) => const AccountPage(),
  '/about': (context) => const AboutPage(),
};
