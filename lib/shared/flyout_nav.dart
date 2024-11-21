import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/main.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:workmanager/workmanager.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    //var themeProvider = Provider.of<ThemeProvider>(context);
    final user = RiotService.user;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  user.playerInfo!.card!.wide!,
                  scale: .5,
                ),
                opacity: .4,
                alignment: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                  child: Text(
                    "${user.playerInfo!.name!}#${user.playerInfo!.tag!}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: Row(
                    children: [
                      Image.network(
                        "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.wallet!.valorantPoints!.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                  child: Row(
                    children: [
                      Image.network(
                        "https://media.valorant-api.com/currencies/e59aa87c-4cbf-517a-5983-6e81511be9b7/displayicon.png",
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.wallet!.radianitePoints!.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
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
              leading: const Icon(Icons.list_rounded),
              title: const Text('Galery'),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/galery');
              },
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory'),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/inventory');
              },
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/about');
              },
            ),
          ),
          const Spacer(),
          const Divider(
            thickness: 1,
          ),
          /*Container(
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
          ),*/
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                Workmanager().cancelAll();
                prefs.clear();
                RiotService.accessToken = "";
                RiotService.entitlements = "";
              },
            ),
          ),
        ],
      ),
    );
  }
}
