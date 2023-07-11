import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/galery/galeryv2_page.dart';
import 'package:valstore/valstore_provider.dart';

import '../models/val_api_skins.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<ValApiSkins?> _allSkinsFuture;

  @override
  void initState() {
    super.initState();

    _allSkinsFuture = RiotService.getAllSkins();
  }

  @override
  Widget build(BuildContext context) {
    final valstore = Provider.of<ValstoreProvider>(context);

    final wished = valstore.skins;

    return FutureBuilder(
      future: _allSkinsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final skinsOnWishlist = (snapshot.data?.data ?? [])
              .where(
                (element) => wished.contains(element.levels?[0].uuid),
              )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Wishlist"),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SkinSearchDelegate(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                final skin = skinsOnWishlist[index];

                return ListTile(
                  leading: Hero(
                    tag: skin.displayName!,
                    child: Image.network(
                      skin.levels![0].displayIcon!,
                      height: 30,
                      width: 50,
                    ),
                  ),
                  title: Text(skin.displayName ?? "Skin_display_name"),
                  trailing: IconButton(
                    onPressed: () {
                      valstore.toggleWishlist(skin.levels![0].uuid ?? "");
                    },
                    color: valstore.isInWishlist(skin.levels![0].uuid ?? "")
                        ? Colors.yellow
                        : Colors.white,
                    icon: Icon(
                      !valstore.isInWishlist(skin.levels![0].uuid ?? "")
                          ? Icons.star_border
                          : Icons.star,
                    ),
                  ),
                );
              },
              itemCount: skinsOnWishlist.length,
            ),
          );
        }
      },
    );
  }
}
