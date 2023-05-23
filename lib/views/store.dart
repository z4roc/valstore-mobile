import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:valstore/circle_painter.dart';
import 'package:valstore/color_extension.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/views/skin_detail_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late List<FirebaseSkin> skins;

  int sortOption = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: const Color(0xFF16141a).withOpacity(.8),
          drawer: const NavDrawer(),
          appBar: AppBar(
            title: const Text('Your shop'),
            actions: [
              FutureBuilder<int>(
                future: RiotService().getStoreTimer(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final time = DateTime.now().millisecondsSinceEpoch +
                        (snapshot.data! * 1000);
                    final val = DateTime.fromMillisecondsSinceEpoch(time);

                    final dif = val.difference(DateTime.now()).inHours / 24;
                    return Row(
                      children: [
                        //const Icon(Icons.timelapse_rounded),
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              )),
                          child: CustomPaint(
                            painter: CirclePaint(dif),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CountdownTimer(
                          endTime: time,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Sort by cost'),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text('Sort by name'),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 1) {
                    setState(() {
                      sortOption = 1;
                    });
                  } else if (value == 2) {
                    setState(() {
                      sortOption = 2;
                    });
                  }
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                sortOption = 0;
              });
            },
            color: Colors.redAccent,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: double.infinity,
              width: double.infinity,
              child: FutureBuilder(
                future: RiotService().getStore(sortOption),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    skins = snapshot.data!.skins;
                    return ListView.builder(
                      itemCount: skins.length,
                      itemBuilder: (context, index) {
                        final colorString =
                            skins[index].contentTier?.color != null
                                ? skins[index].contentTier!.color
                                : "252525";
                        final Color color =
                            HexColor(colorString!).withOpacity(.7);
                        return GestureDetector(
                          onTap: () {
                            navigatorKey.currentState!
                                .push(MaterialPageRoute(builder: ((context) {
                              return SkinDetailPage(skin: skins[index]);
                            })));
                          },
                          child: SizedBox(
                            height: 200,
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    opacity: .2,
                                    image: NetworkImage(
                                      skins[index].contentTier!.icon!,
                                    ),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            skins[index].name!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        //
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Hero(
                                      tag: skins[index].name!,
                                      child: Image.network(
                                        skins[index].icon!,
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
                                          skins[index].cost!.toString(),
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
                        );
                      },
                    );
                  } else {
                    return Container(
                      height: double.infinity,
                      padding: EdgeInsets.zero,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Loading Store'),
                            SizedBox(
                              height: 10,
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )),
    );
  }
}
