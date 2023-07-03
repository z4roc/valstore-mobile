import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/models/inofficial_api_models.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/v2/valstore_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../../services/riot_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ValstoreProvider>(context);
    PlayerInfo info = provider.getInstance.player.playerInfo!;
    Player user = provider.getInstance.player;
    LevelBorder border = provider.getInstance.player.levelBorder!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Account"),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sign out"),
                    content:
                        const Text("Are you sure that you want to sign out?"),
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
                          await WebViewCookieManager().clearCookies();
                          await WebViewController().clearLocalStorage();
                          await WebViewController().reload();
                          final prefs = await SharedPreferences.getInstance();
                          Workmanager().cancelAll();
                          prefs.clear();
                          RiotService.accessToken = "";
                          RiotService.entitlements = "";
                          RiotService.region = "eu";
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/login", (route) => false);
                          Restart.restartApp();
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
            icon: const Icon(
              FontAwesomeIcons.doorOpen,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
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
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Wallet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: ListTile(
              leading: CachedNetworkImage(
                height: 25,
                width: 25,
                imageUrl:
                    "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
              ),
              title: Text("${user.wallet?.valorantPoints ?? 0}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: ListTile(
              leading: CachedNetworkImage(
                height: 25,
                width: 25,
                imageUrl:
                    "https://media.valorant-api.com/currencies/e59aa87c-4cbf-517a-5983-6e81511be9b7/displayicon.png",
              ),
              title: Text("${user.wallet?.radianitePoints ?? 0}"),
            ),
          ),
        ],
      ),
    );
  }
}
