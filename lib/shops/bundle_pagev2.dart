import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:valstore/shared/color_extension.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/shared/loading.dart';
import 'package:valstore/valstore_provider.dart';

import '../main.dart';
import '../shared/skin_detail_page.dart';

class BundlePage extends StatefulWidget {
  const BundlePage({super.key});

  @override
  State<BundlePage> createState() => _BundlePageState();
}

class _BundlePageState extends State<BundlePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final valstore = Provider.of<ValstoreProvider>(context);

    final instance = valstore.getInstance;
    return FutureBuilder(
      future: valstore.getBundles(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final bundle = instance.bundles?[index];
                      final bundleDisplaydata = bundle?.data?.totalBaseCost;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Card(
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const BasicItemLoader(),
                                imageUrl: bundle?.bundleData?.displayIcon ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 150,
                                  padding: const EdgeInsets.only(top: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 37, 34, 41)
                                        .withOpacity(.8),
                                    borderRadius: BorderRadius.circular(10),
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
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageProvider,
                                      opacity: .6,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          bundle?.bundleData?.displayName ?? "",
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            bundle
                                                    ?.data
                                                    ?.totalBaseCost?[
                                                        "85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741"]
                                                    ?.toString() ??
                                                "",
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Image(
                                            height: 20,
                                            image: NetworkImage(
                                              "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Icon(
                                            Icons.timelapse,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CountdownTimer(
                                            endTime: DateTime.now()
                                                    .millisecondsSinceEpoch +
                                                ((bundle?.data
                                                            ?.durationRemainingInSeconds ??
                                                        0) *
                                                    1000),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              bundle?.data?.items = bundle.data?.items
                                      ?.where(
                                          (element) => element.basePrice >= 875)
                                      .toList() ??
                                  [];

                              final skinData = bundle?.data?.items?[index];
                              String? color;
                              String? icon;
                              final offerData =
                                  bundle?.data?.itemOffers?[index];
                              ;
                              switch (skinData?.basePrice) {
                                case 875:
                                  color = "5b9cdd";
                                  icon =
                                      "https://media.valorant-api.com/contenttiers/12683d76-48d7-84a3-4e09-6985794f0445/displayicon.png";
                                  break;
                                case 1275:
                                  color = "28bda7";
                                  icon =
                                      "https://media.valorant-api.com/contenttiers/0cebb8be-46d7-c12a-d306-e9907bfc5a25/displayicon.png";
                                  break;
                                case 1775:
                                  color = "cb558d";
                                  icon =
                                      "https://media.valorant-api.com/contenttiers/60bca009-4182-7998-dee7-b8a2558dc369/displayicon.png";
                                  break;
                                case 2175:
                                  color = "fd9257";
                                  icon =
                                      "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
                                  break;
                                case 2475:
                                  color = "eed878";
                                  icon =
                                      "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
                                  break;

                                default:
                                  if (skinData!.basePrice! > 2475 &&
                                      skinData.basePrice! < 4950) {
                                    color = "fd9257";
                                    icon =
                                        "https://media.valorant-api.com/contenttiers/e046854e-406c-37f4-6607-19a9ba8426fc/displayicon.png";
                                  } else if (skinData.basePrice! >= 4950) {
                                    color = "eed878";
                                    icon =
                                        "https://media.valorant-api.com/contenttiers/411e4a55-4e59-7757-41f0-86a53f101bb5/displayicon.png";
                                  }
                                  break;
                              }

                              return BundleItemTile(
                                skin: bundle!.skins![index],
                                color: color == null
                                    ? const Color.fromARGB(255, 133, 123, 158)
                                    : HexColor(color),
                              );
                            },
                            itemCount: bundle?.skins?.length ?? 0,
                          )
                        ],
                      );
                    },
                    itemCount: instance.bundles?.length,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class BundleItemTile extends StatelessWidget {
  const BundleItemTile({
    super.key,
    required this.skin,
    required this.color,
  });

  final FirebaseSkin skin;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: GestureDetector(
        onTap: () async {
          try {
            var fbSkin =
                await FireStoreService().getSkinBySkinId(skin.skinId ?? "");

            fbSkin ??= await FireStoreService().registerSkin(skin);

            navigatorKey.currentState!
                .push(MaterialPageRoute(builder: ((context) {
              return SkinDetailPage(skin: fbSkin!);
            })));
          } catch (e) {}
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
                  begin: Alignment.centerLeft,
                  end: Alignment.topRight,
                  colors: [
                    color
                        .withBlue((color.blue / 4).round())
                        .withRed((color.red / 4).round())
                        .withGreen((color.green / 4).round()),
                    color
                        .withBlue((color.blue / 2).round())
                        .withRed((color.red / 2).round())
                        .withGreen((color.green / 2).round()),
                    color
                        .withBlue((color.blue / 1).round())
                        .withRed((color.red / 1).round())
                        .withGreen((color.green / 1).round()),
                  ],
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white.withOpacity(.95),
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
                    tag: skin.name ?? "",
                    child: Image.network(
                      skin.icon!,
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
                        skin.cost?.toString() ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(.95),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Image(
                        height: 22,
                        image: NetworkImage(
                          "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
