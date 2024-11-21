import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/valstore_provider.dart';
import 'package:valstore/shared/skin_detail_page.dart';

import '../models/val_api_skins.dart';
import '../shared/loading.dart';

class GaleryPage extends StatefulWidget {
  const GaleryPage({super.key});

  @override
  State<GaleryPage> createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage> {
  final staredItems = [];

  late Future<ValApiSkins?> _allSkinsFuture;

  @override
  void initState() {
    _allSkinsFuture = RiotService.getAllSkins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      body: FutureBuilder(
        future: _allSkinsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var skins = snapshot.data!.data!;

            skins.sort(
              (a, b) => a.displayName!.compareTo(b.displayName!),
            );

            final provider = Provider.of<ValstoreProvider>(context);

            return MediaQuery.removeViewPadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                radius: const Radius.circular(2),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: skins.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Hero(
                        tag: skins[index].displayName!,
                        child: CachedNetworkImage(
                          imageUrl: skins[index].levels![0].displayIcon!,
                          height: 30,
                          width: 50,
                        ),
                      ),
                      onTap: () async {
                        try {
                          final skin = await FireStoreService()
                              .getSkin(skins[index].levels?[0].uuid);
                          if (skin != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SkinDetailPage(skin: skin);
                                },
                              ),
                            );
                          } else {
                            final valstore = provider.getInstance;

                            final offer = valstore.localOffers?.offers
                                ?.where((element) =>
                                    element.offerID ==
                                    skins[index].levels?[0].uuid)
                                .firstOrNull;

                            if (offer == null) return;

                            final fbSkin = FirebaseSkin(
                              chromas: skins[index].chromas,
                              levels: skins[index].levels,
                              name: skins[index].displayName,
                              icon: skins[index].displayIcon,
                              offerId: skins[index].levels?[0].uuid,
                              skinId: skins[index].uuid,
                              cost: offer.cost
                                      ?.i85ad13f73d1b51289eb27cd8ee0b5741 ??
                                  0,
                              contentTier: getContentTierByCost(
                                offer.cost?.i85ad13f73d1b51289eb27cd8ee0b5741 ??
                                    0,
                              ),
                            );

                            await FireStoreService().registerFullSkin(fbSkin);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SkinDetailPage(skin: fbSkin);
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          final snackbar = SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.redAccent,
                          );

                          Scaffold.of(context)
                              .showBottomSheet((context) => snackbar);
                        }
                      },
                      title:
                          Text(skins[index].displayName ?? "Skin_display_name"),
                      trailing: IconButton(
                        onPressed: () {
                          provider.toggleWishlist(
                              skins[index].levels![0].uuid ?? "");
                        },
                        color: provider.isInWishlist(
                                skins[index].levels![0].uuid ?? "")
                            ? Colors.yellow
                            : Colors.white,
                        icon: Icon(
                          !provider.isInWishlist(
                                  skins[index].levels![0].uuid ?? "")
                              ? Icons.star_border
                              : Icons.star,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return const BasicItemLoader();
              },
              itemCount: 10,
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
      color: const Color(0x00ff4655),
      child: FutureBuilder(
        future: RiotService.getAllSkins(),
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
            final provider = Provider.of<ValstoreProvider>(context);
            return ListView.builder(
              itemCount: skins.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    final skin = await FireStoreService()
                        .getSkinById(skins[index].levels?[0].uuid ?? "");

                    if (skin == null) {
                      final offer = provider.getInstance.localOffers?.offers
                          ?.where((element) =>
                              element.offerID == skins[index].levels?[0].uuid)
                          .firstOrNull;

                      if (offer == null) return;

                      final fbSkin = FirebaseSkin(
                        chromas: skins[index].chromas,
                        levels: skins[index].levels,
                        name: skins[index].displayName,
                        icon: skins[index].displayIcon,
                        offerId: skins[index].levels?[0].uuid,
                        skinId: skins[index].uuid,
                        cost:
                            offer.cost?.i85ad13f73d1b51289eb27cd8ee0b5741 ?? 0,
                        contentTier: getContentTierByCost(
                          offer.cost?.i85ad13f73d1b51289eb27cd8ee0b5741 ?? 0,
                        ),
                      );

                      await FireStoreService().registerFullSkin(fbSkin);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SkinDetailPage(skin: fbSkin);
                          },
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SkinDetailPage(skin: skin);
                          },
                        ),
                      );
                    }
                  },
                  leading: Hero(
                    tag: skins[index].displayName!,
                    child: Image.network(
                      skins[index].levels![0].displayIcon!,
                      height: 30,
                      width: 50,
                    ),
                  ),
                  title: Text(skins[index].displayName ?? "Skin_display_name"),
                  trailing: IconButton(
                    onPressed: () {
                      provider
                          .toggleWishlist(skins[index].levels![0].uuid ?? "");
                    },
                    color: provider
                            .isInWishlist(skins[index].levels![0].uuid ?? "")
                        ? Colors.yellow
                        : Colors.white,
                    icon: Icon(
                      !provider.isInWishlist(skins[index].levels![0].uuid ?? "")
                          ? Icons.star_border
                          : Icons.star,
                    ),
                  ),
                );
              },
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return const BasicItemLoader();
              },
              itemCount: 10,
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: const Color(0x00ff4655),
    );
  }
}

Widget itemTile(Data skin) {
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
        //color: color,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 75, 72, 82),
          ),
        ),
      ),
      height: 150,
      child: Card(
        elevation: 2,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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

ContentTier getContentTierByCost(int cost) {
  String name = "Select";
  String color = "5b9cdd";
  String icon =
      "https://media.valorant-api.com/contenttiers/12683d76-48d7-84a3-4e09-6985794f0445/displayicon.png";

  switch (cost) {
    case 875:
      name = "Select";
      color = "5b9cdd";
      icon =
          "https://media.valorant-api.com/contenttiers/12683d76-48d7-84a3-4e09-6985794f0445/displayicon.png";
      break;
    case 1275:
      name = "Deluxe";
      color = "28bda7";
      icon =
          "https://media.valorant-api.com/contenttiers/0cebb8be-46d7-c12a-d306-e9907bfc5a25/displayicon.png";
      break;
    case 1775:
      name = "Premium";
      color = "cb558d";
      icon =
          "https://media.valorant-api.com/contenttiers/60bca009-4182-7998-dee7-b8a2558dc369/displayicon.png";
      break;
    case 2175:
      name = "Exclusive";
      color = "fd9257";
      icon =
          "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
      break;
    case 2475:
      name = "Ultra";
      color = "eed878";
      icon =
          "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
      break;

    default:
      if (cost > 2475 && cost < 4950) {
        color = "fd9257";
        icon =
            "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
      } else if (cost >= 4950) {
        color = "eed878";
        icon =
            "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
      }
      break;
  }

  return ContentTier(name: name, color: color, icon: icon);
}
