import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/inofficial_api_models.dart';
import 'package:valstore/models/player.dart' as p;
import 'package:valstore/services/firebase_auth.dart';
import 'package:valstore/account/loadout_page.dart';
import 'package:valstore/galery/favorites_page.dart';
import 'package:valstore/valstore_provider.dart';
import 'package:valstore/account/inventory_page.dart';
import 'package:workmanager/workmanager.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 0;

  final pages = [
    const DashboardPage(),
    const LoadOutPage(),
    const InventoryPage(),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        backgroundColor: Colors.transparent,
        activeColor: Colors.white,
        tabBackgroundColor: const Color.fromARGB(0, 37, 37, 52).withOpacity(.5),
        gap: 8,
        selectedIndex: _currentIndex,
        padding: const EdgeInsets.all(5),
        tabMargin: const EdgeInsets.all(10),
        tabBorderRadius: 5,
        color: Colors.grey,
        onTabChange: (value) {
          if (value > 2) {
            navigatorKey.currentState!.pushNamed("/favorites");
          } else {
            setState(() {
              _currentIndex = value;
            });
          }
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Dashboard",
          ),
          GButton(
            icon: FontAwesomeIcons.personRifle,
            text: "Loadout",
          ),
          GButton(
            icon: Icons.inventory_2,
            text: "Inventory",
          ),
          GButton(
            icon: Icons.star,
            text: "Wishlist",
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Account"),
      ),
      body: pages[_currentIndex],
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ValstoreProvider>(context);

    return FutureBuilder(
        future: provider.getPlayerInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            p.PlayerInfo info = provider.getInstance.player!.playerInfo!;
            p.Player user = provider.getInstance.player!;
            LevelBorder border =
                provider.getInstance.player?.levelBorder ?? LevelBorder();
            return Column(
              children: [
                //BannerCard(info: info, border: border),
                Container(
                  height: 500,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: const Color.fromARGB(255, 31, 28, 37),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AccountBadge(info: info, border: border),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Hero(
                                  tag: "${info.name ?? ""}#${info.tag}",
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    "${info.name ?? ""}#${info.tag}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displayLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Valorant Points",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 40,
                                      width: 40,
                                      imageUrl:
                                          "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${user.wallet?.valorantPoints ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Radianite Points",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 40,
                                      width: 40,
                                      imageUrl:
                                          "https://media.valorant-api.com/currencies/e59aa87c-4cbf-517a-5983-6e81511be9b7/displayicon.png",
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${user.wallet?.radianitePoints ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Kingdom Credits",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 40,
                                      width: 40,
                                      imageUrl:
                                          "https://media.valorant-api.com/currencies/85ca954a-41f2-ce94-9b45-8ca3dd39a00d/displayicon.png",
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${user.wallet?.kingdomCredits ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(
                              "https://support-valorant.riotgames.com/hc/en-us/articles/360045132434-Checking-Your-Purchase-History-"),
                        );
                      },
                      child: const Text(
                          "How much money did i spend on VALORANT?")),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Sign out"),
                            content: const Text(
                                "Are you sure that you want to sign out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                ),
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await Workmanager().cancelAll();
                                  await CookieManager().deleteAllCookies();
                                  await prefs.clear();
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    await FirebaseAuthService().signOut();
                                  }

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/", (route) => false);
                                  //await Restart.restartApp();
                                },
                                child: const Text("Yes"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Sign out"),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.info,
    required this.border,
  });

  final p.PlayerInfo info;
  final LevelBorder border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(
            info.card?.wide ?? "",
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(1),
            Colors.black.withOpacity(.2),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //CachedNetworkImage(imageUrl: border.smallPlayerCardAppearance!),
          Text(
            "${info.name ?? ""}#${info.tag}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(border.levelNumberAppearance!),
              ),
            ),
            child: Center(
              child: Text(
                info.accountLevel!.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountBadge extends StatelessWidget {
  const AccountBadge({
    super.key,
    required this.info,
    required this.border,
  });

  final p.PlayerInfo info;
  final LevelBorder border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(1),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    border.smallPlayerCardAppearance ?? "",
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                width: 60,
                child: Hero(
                  tag: info.card?.small ??
                      "https://media.valorant-api.com/playercards/efaf392a-412d-0d4f-4413-ddbdb70d841d/displayicon.png",
                  child: Image.network(info.card?.small ?? ""),
                ),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 75,
            margin: const EdgeInsetsDirectional.only(top: 50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  border.levelNumberAppearance ?? "",
                ),
              ),
            ),
            child: Center(
              child: Text(
                info.accountLevel!.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
