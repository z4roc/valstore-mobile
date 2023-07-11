import 'package:flutter/material.dart';
import 'package:valstore/shared/color_extension.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/shared/loading.dart';
import 'package:valstore/shared/store_item.dart';

class PlayerShopPage extends StatefulWidget {
  const PlayerShopPage({super.key});

  @override
  State<PlayerShopPage> createState() => _PlayerShopPageState();
}

class _PlayerShopPageState extends State<PlayerShopPage> {
  late Future<PlayerShop> _storeFuture;

  @override
  void initState() {
    super.initState();
    _storeFuture = RiotService.getStore();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: _storeFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return StoreItemTile(
                    skin: snapshot.data?.skins[index] ?? FirebaseSkin(),
                    color: HexColor(
                      snapshot.data?.skins[index].contentTier?.color ??
                          "252525",
                    ),
                  );
                },
                itemCount: snapshot.data?.skins.length ?? 0,
              ),
            );
          } else {
            return const StoreItemLoading();
          }
        },
      ),
    );
  }
}
