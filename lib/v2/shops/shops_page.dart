import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:valstore/models/valstore.dart';
import 'package:valstore/v2/galery/favorites_page.dart';
import 'package:valstore/v2/galery/galeryv2_page.dart';
import 'package:valstore/v2/settings/settings_page.dart';
import 'package:valstore/v2/shops/accessory_store.dart';
import 'package:valstore/v2/shops/night_market_page.dart';
import 'package:valstore/v2/shops/player_shop_page.dart';
import 'package:valstore/v2/valstore_provider.dart';

import '../../circle_painter.dart';
import '../account/account_page.dart';
import 'bundle_pagev2.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  int _currentIndex = 0;

  late Future<Valstore> _initValstore;

  final storePages = [
    const PlayerShopPage(),
    const AccessoryPage(),
    const NightMarketPage(),
    const BundlePage(),
    const GaleryPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initValstore = ValstoreProvider().initValstore();
  }

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
          setState(() {
            _currentIndex = value;
          });
        },
        tabs: const [
          GButton(
            icon: Icons.shopping_cart,
            text: "Store",
          ),
          GButton(
            iconSize: 20,
            icon: FontAwesomeIcons.wandMagicSparkles,
            text: "Accessories",
          ),
          GButton(
            iconSize: 20,
            icon: FontAwesomeIcons.cloudMoon,
            text: "Night Market",
          ),
          GButton(
            iconSize: 20,
            icon: FontAwesomeIcons.layerGroup,
            text: "Bundles",
          ),
          GButton(
            icon: FontAwesomeIcons.grip,
            text: "Galery",
          )
        ],
      ),
      body: FutureBuilder(
        future: _initValstore,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = Provider.of<ValstoreProvider>(context);
            final valstore = state.getInstance;

            final time = DateTime.now().millisecondsSinceEpoch +
                ((valstore.playerShop.storeRemaining ?? 0) * 1000);
            final dif = DateTime.fromMillisecondsSinceEpoch(time)
                    .difference(DateTime.now())
                    .inHours /
                24;

            return WillPopScope(
              onWillPop: () async => false,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      //color: Colors.red,
                      //padding: const EdgeInsets.all(10),
                      height: 100,
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 12,
                              ),
                              AccountIcon(
                                  valstore: valstore,
                                  currentPage: _currentIndex),
                              const Spacer(),
                              AnimatedOpacity(
                                opacity: _currentIndex == 0 ? 1 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: _currentIndex == 0
                                    ? TimerWidget(dif: dif, time: time)
                                    : const SizedBox(),
                              ),
                              AnimatedOpacity(
                                opacity: _currentIndex == 4 ? 1 : 0,
                                duration: const Duration(milliseconds: 500),
                                child: _currentIndex == 4
                                    ? Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await showSearch(
                                                context: context,
                                                delegate: SkinSearchDelegate(),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) {
                                                  return const FavoritesPage();
                                                },
                                              ));
                                            },
                                            icon: const Icon(
                                              Icons.star,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const SettingsPage();
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: storePages[_currentIndex],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.dif,
    required this.time,
  });

  final double dif;
  final int time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Next update in",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: CustomPaint(
                  painter: CirclePaint(dif),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CountdownTimer(
              endTime: time,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class AccountIcon extends StatelessWidget {
  const AccountIcon({
    super.key,
    required this.valstore,
    required this.currentPage,
  });

  final int currentPage;
  final Valstore valstore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: 10,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 37, 34, 44),
            Color.fromARGB(255, 28, 28, 39),
          ],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
          ),
        ],
      ),
      height: 60,
      width: 180,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AccountPage();
              },
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: valstore.player.playerInfo?.card?.small ??
                      "https://media.valorant-api.com/playercards/efaf392a-412d-0d4f-4413-ddbdb70d841d/displayicon.png",
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 5,
                  bottom: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        "${valstore.player.playerInfo?.name ?? ""}#${valstore.player.playerInfo?.tag ?? ""}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    currentPage != 1
                        ? Expanded(
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  height: 12,
                                  width: 12,
                                  imageUrl:
                                      "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${valstore.player.wallet?.valorantPoints ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CachedNetworkImage(
                                  height: 12,
                                  width: 12,
                                  imageUrl:
                                      "https://media.valorant-api.com/currencies/e59aa87c-4cbf-517a-5983-6e81511be9b7/displayicon.png",
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${valstore.player.wallet?.radianitePoints ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  height: 12,
                                  width: 12,
                                  imageUrl:
                                      "https://media.valorant-api.com/currencies/85ca954a-41f2-ce94-9b45-8ca3dd39a00d/displayicon.png",
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${valstore.player.wallet?.kingdomCredits ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
