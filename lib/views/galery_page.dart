import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/views/skin_detail_page.dart';

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
      body: FirestoreListView<FirebaseSkin>(
        pageSize: 10,
        query: FirebaseFirestore.instance
            .collection("skins")
            .where("cost", isGreaterThanOrEqualTo: 1275)
            .orderBy("cost")
            .orderBy("name")
            .withConverter(
              fromFirestore: (snapshot, options) => FirebaseSkin.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (value, options) => value.toJson(),
            ),
        itemBuilder: (context, doc) {
          final skin = doc.data();

          return GestureDetector(
            onTap: () {
              navigatorKey.currentState!.push(
                MaterialPageRoute(
                  builder: (context) {
                    return SkinDetailPage(skin: skin);
                  },
                ),
              );
            },
            child: ListTile(
              leading: Hero(
                tag: skin.name!,
                child: Image(
                  image: NetworkImage(skin.icon!),
                  height: 75,
                  width: 150,
                ),
              ),
              title: Row(
                children: [
                  Image(
                    height: 20,
                    width: 20,
                    image: NetworkImage(skin.contentTier!.icon!),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      skin.name!,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(skin.cost!.toString()),
                  const Image(
                    height: 15,
                    width: 15,
                    image: NetworkImage(
                        "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png"),
                  )
                ],
              ),
            ),
          );
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
    return FirestoreListView(
      query: FirebaseFirestore.instance
          .collection("skins")
          .where("name", isGreaterThanOrEqualTo: query)
          .where("name", isLessThanOrEqualTo: "$query\uf7ff")
          .orderBy("name")
          .withConverter(
            fromFirestore: (snapshot, options) =>
                FirebaseSkin.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          ),
      itemBuilder: (context, doc) {
        final skin = doc.data();

        if (skin.contentTier?.icon == null) {
          return const SizedBox();
        }
        return GestureDetector(
          onTap: () => navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) {
                return SkinDetailPage(skin: skin);
              },
            ),
          ),
          child: ListTile(
            leading: Hero(
              tag: skin.name!,
              child: Image(
                image: NetworkImage(skin.icon!),
                height: 75,
                width: 150,
              ),
            ),
            title: Row(
              children: [
                Image(
                  height: 20,
                  width: 20,
                  image: NetworkImage(skin.contentTier!.icon!),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    skin.name!,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(skin.cost!.toString()),
                const Image(
                  height: 15,
                  width: 15,
                  image: NetworkImage(
                      "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
