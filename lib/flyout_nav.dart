import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final user = RiotService.user;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(user.card!.wide!),
                opacity: .5,
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "${user.name!}#${user.tag!}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text(
                'Daily Store',
              ),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/store');
              },
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.discount_rounded),
              title: const Text('Night Market'),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/nightmarket');
              },
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.dataset_rounded),
              title: const Text('Bundle'),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/bundle');
              },
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Account'),
              onTap: () {},
            ),
          ),
          const Spacer(),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: Icon(
                themeProvider.isDarkMode
                    ? Icons.nights_stay_rounded
                    : Icons.wb_sunny,
              ),
              title: const Text('Toggle Theme'),
              onTap: () {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(!themeProvider.isDarkMode);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () async {
                await WebViewCookieManager().clearCookies();
                await WebViewController().reload();
                navigatorKey.currentState!.popUntil(
                  ModalRoute.withName('/'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
