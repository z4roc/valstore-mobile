import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:valstore/circle_painter.dart';
import 'package:valstore/color_extension.dart';
import 'package:valstore/services/notifcation_service.dart';
import 'package:valstore/shared/flyout_nav.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/shared/loading.dart';
import 'package:valstore/views/skin_detail_page.dart';

import 'package:timezone/timezone.dart' as tz;
import '../adhelper.dart';

Timer? timer;

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late List<FirebaseSkin> skins;
  late Future<PlayerShop> _shop;
  late Future<int> _storeTimer;
  BannerAd? _ad;
  int sortOption = 0;

  @override
  void initState() {
    super.initState();
    _storeTimer = RiotService.getStoreTimer();
    _shop = RiotService.getStore(sortOption);
    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.storeBannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
      ),
      request: const AdRequest(),
    ).load();
    /*timer = Timer.periodic(
      const Duration(seconds: 20),
      (timer) => RiotService.recheckStore(),
    );
    initTimeZones();*/
  }

  Future<void> initTimeZones() async {
    await notifications.zonedSchedule(
      0,
      "New Items",
      "Your shop has new Items",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

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
              future: _storeTimer,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final time = DateTime.now().millisecondsSinceEpoch +
                      (snapshot.data! * 1000);
                  final val = DateTime.fromMillisecondsSinceEpoch(time);
                  Timer(
                      Duration(
                          seconds: val.difference(DateTime.now()).inSeconds),
                      () => setState(() {
                            RiotService.playerShop = null;
                            sortOption = 0;
                            _shop = RiotService.getStore(sortOption);
                          }));

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
              RiotService.playerShop = null;
              sortOption = 0;
              _shop = RiotService.getStore(sortOption);
              _storeTimer = RiotService.getStoreTimer();
            });
          },
          color: Colors.redAccent,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder(
              future: _shop,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  skins = snapshot.data!.skins;
                  if (sortOption == 1) {
                    skins.sort((a, b) {
                      return b.cost! - a.cost!;
                    });
                  } else if (sortOption == 2) {
                    skins.sort(
                      (a, b) => a.name!.toLowerCase().compareTo(
                            b.name!.toLowerCase(),
                          ),
                    );
                  }
                  return ListView.builder(
                    itemCount: skins.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 4 && index >= skins.length) {
                        return _ad != null
                            ? Container(
                                width: _ad!.size.width.toDouble(),
                                height: 70,
                                alignment: Alignment.center,
                                child: AdWidget(ad: _ad!),
                              )
                            : const SizedBox();
                      }

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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 1,
                                  )
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    color
                                        .withBlue((color.blue / 3).round())
                                        .withRed((color.red / 3).round())
                                        .withGreen((color.green / 3).round()),
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
                                      Image.network(
                                        skins[index].contentTier!.icon!,
                                        height: 25,
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
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const StoreItemLoading();
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
