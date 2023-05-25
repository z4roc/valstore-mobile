import 'package:flutter/material.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/views/night_market_page.dart';
import 'package:valstore/views/skin_detail_page.dart';

import '../models/val_api_skins.dart';

class GaleryPage extends StatefulWidget {
  const GaleryPage({super.key});

  @override
  State<GaleryPage> createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("Galery"),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(
                context: context,
                delegate: SkinSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: RiotService().getAllSkins(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var skins = snapshot.data!.data!;

            skins.sort(
              (a, b) => a.displayName!.compareTo(b.displayName!),
            );

            return ListView.builder(
              itemCount: skins.length,
              itemBuilder: (context, index) {
                return itemTile(skins[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class SkinSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            close(context, null);
          },
          icon: const Icon(Icons.clear_rounded),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      );

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: color,
      child: FutureBuilder(
        future: RiotService().getAllSkins(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var skins = snapshot.data!.data!;

            skins = skins
                .where(
                  (element) =>
                      element.displayName!.toLowerCase().trim().contains(
                            query.toLowerCase().trim(),
                          ),
                )
                .toList();

            return ListView.builder(
              itemCount: skins.length,
              itemBuilder: (context, index) {
                return itemTile(
                  skins[index],
                );
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading Inventory..."),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

Widget itemTile(Data skin) {
  Color color = const Color.fromARGB(255, 31, 28, 37);

  return GestureDetector(
    onTap: () async {
      FirebaseSkin? firebaseSkin =
          await FireStoreService().getSkin(skin.levels![0].uuid!);
      if (firebaseSkin == null) return;
      navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) {
        return SkinDetailPage(skin: firebaseSkin);
      })));
    },
    child: Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 75, 72, 82),
          ),
        ),
      ),
      height: 150,
      child: Card(
        elevation: 2,
        color: color
            .withBlue((color.blue / 1.7).round())
            .withRed((color.red / 1.7).round())
            .withGreen((color.green / 1.7).round()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      skin.displayName!,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  //
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Hero(
                tag: skin.displayName!,
                child: Image.network(
                  skin.levels![0].displayIcon!,
                  height: 60,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
