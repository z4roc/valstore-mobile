import 'package:flutter/material.dart';
import 'package:valstore/models/storefront.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/riot_service.dart';
import '../models/firebase_skin.dart';

class AccessoryPage extends StatefulWidget {
  const AccessoryPage({super.key});

  @override
  State<AccessoryPage> createState() => _AccessoryPageState();
}

class _AccessoryPageState extends State<AccessoryPage> {
  late Future<List<FirebaseSkin>> _skinsFuture;
  late AccessoryStore? store;
  @override
  void initState() {
    super.initState();

    store = RiotService.userOffers?.accessoryStore;

    _skinsFuture = FireStoreService().getSkinsById(
      store?.accessoryStoreOffers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: _skinsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return AccessoryItem(
                    skin: snapshot.data?[index] ??
                        FirebaseSkin(name: "Error", cost: 0, icon: null),
                    color: const Color.fromARGB(255, 78, 72, 94),
                    cost: store?.accessoryStoreOffers[index].offer.cost ?? {},
                  );
                },
                itemCount: snapshot.data?.length ?? 0,
              ),
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

class AccessoryItem extends StatelessWidget {
  const AccessoryItem(
      {super.key,
      required this.skin,
      required this.color,
      required this.cost,
      s});

  final FirebaseSkin skin;
  final Color color;
  final Map<String, int> cost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) {
          return SkinDetailPage(skin: skin);
        })));*/
      },
      child: SizedBox(
        height: 200,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  blurRadius: 1,
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: .2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color
                      .withBlue((color.blue / 2).round())
                      .withRed((color.red / 2).round())
                      .withGreen((color.green / 2).round()),
                  color
                      .withBlue((color.blue / 1.2).round())
                      .withRed((color.red / 1.2).round())
                      .withGreen((color.green / 1.2).round()),
                  color
                      .withBlue((color.blue / .7).round())
                      .withRed((color.red / .7).round())
                      .withGreen((color.green / .7).round()),
                ],
                tileMode: TileMode.mirror,
              ),
              image: DecorationImage(
                alignment: Alignment.bottomLeft,
                fit: BoxFit.contain,
                opacity: skin.contentTier?.icon != null ? .2 : 0,
                image: NetworkImage(
                  skin.contentTier?.icon ??
                      "https://www2.tuhh.de/zll/wp-content/uploads/placeholder.png",
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        skin.name!,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    skin.contentTier?.icon != null
                        ? Image.network(
                            skin.contentTier?.icon ??
                                "https://www2.tuhh.de/zll/wp-content/uploads/placeholder.png",
                            height: 25,
                          )
                        : const SizedBox(),
                    //
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Hero(
                  tag: skin.name ?? "Unknown",
                  child: skin.icon != null
                      ? Image.network(
                          skin.icon ??
                              "https://www2.tuhh.de/zll/wp-content/uploads/placeholder.png",
                          height: 100,
                        )
                      : Image.asset(
                          "assets/playertitle.png",
                          height: 100,
                        ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const Spacer(),
                    Text(
                      cost[Currencies.kingdomCredits].toString() ?? "0",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Image(
                      height: 22,
                      image: NetworkImage(
                        "https://media.valorant-api.com/currencies/85ca954a-41f2-ce94-9b45-8ca3dd39a00d/displayicon.png",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
