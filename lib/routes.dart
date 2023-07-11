import 'package:valstore/login/login_page.dart';
import 'package:valstore/galery/favorites_page.dart';
import 'package:valstore/shops/shops_page.dart';
import 'package:valstore/account/inventory_page.dart';
import 'package:valstore/login/region_page.dart';
import 'package:valstore/login/login_webview.dart';

final routes = {
  '/': (context) => const HomeScreen(),
  '/region': (context) => const RegionPage(),
  '/login': (context) => const WebViewPage(),
  '/store': (context) => const ShopsPage(),
  '/inventory': (context) => const InventoryPage(),
  '/favorites': (context) => const FavoritesPage(),
};
