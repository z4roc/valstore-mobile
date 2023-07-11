import 'package:flutter/material.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/val_api_skins.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/shared/loading.dart';
import 'package:valstore/shared/skin_detail_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final skin = snapshot.data![index];

                if (skin == null) return const SizedBox();

                return itemTile(skin);
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
        future: RiotService.getUserOwnedItems(),
      ),
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
      decoration: const BoxDecoration(),
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
