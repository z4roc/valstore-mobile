import 'package:valstore/main.dart';
import 'package:valstore/v2/shops/shops_page.dart';
import 'package:valstore/views/about_page.dart';
import 'package:valstore/views/bundle_page.dart';
import 'package:valstore/views/galery_page.dart';
import 'package:valstore/views/inventory_page.dart';
import 'package:valstore/views/night_market_page.dart';
import 'package:valstore/views/region_page.dart';
import 'package:valstore/views/web_view.dart';

final routes = {
  '/': (context) => const HomeScreen(),
  '/region': (context) => const RegionPage(),
  '/login': (context) => const WebViewPage(),
  '/store': (context) => const ShopsPage(),
  '/nightmarket': (context) => const NightMarketPage(),
  '/bundle': (context) => const BundlePage(),
  '/about': (context) => const AboutPage(),
  '/galery': (context) => const GaleryPage(),
  '/inventory': (context) => const InventoryPage(),
};
