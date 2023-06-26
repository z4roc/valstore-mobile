import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:animated_overflow/animated_overflow.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:valstore/adhelper.dart';
import 'package:valstore/shared/flyout_nav.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/views/skin_detail_page.dart';

import '../models/bundle.dart';
import '../services/firestore_service.dart';

class BundlePage extends StatefulWidget {
  const BundlePage({super.key});

  @override
  State<BundlePage> createState() => _BundlePageState();
}

class _BundlePageState extends State<BundlePage> {
  int activePage = 0;

  BannerAd? _ad;

  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
      ),
      request: const AdRequest(),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Bundle'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: Colors.redAccent,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder<List<BundleDisplayData?>>(
            future: RiotService().getCurrentBundle(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 110,
                      child: PageView.builder(
                        onPageChanged: (value) => setState(() {
                          activePage = value;
                        }),
                        itemBuilder: (context, pageIndex) {
                          return Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 37, 34, 41)
                                      .withOpacity(.8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      snapshot.data![pageIndex]!.bundleData!
                                          .displayIcon!,
                                    ),
                                    opacity: .6,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Expanded(
                                      child: Text(
                                        snapshot.data![pageIndex]!.bundleData!
                                            .displayName!,
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
                                          snapshot.data![pageIndex]!.data!
                                              .bundlePrice
                                              .toString(),
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 20,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                              (snapshot.data![pageIndex]!.data!
                                                      .secondsRemaining! *
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
                              _ad != null
                                  ? Container(
                                      width: _ad!.size.width.toDouble(),
                                      height: 70,
                                      alignment: Alignment.center,
                                      child: AdWidget(ad: _ad!),
                                    )
                                  : const SizedBox(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot
                                      .data![pageIndex]!.data!.items!.length,
                                  itemBuilder: (context, index) {
                                    Items item = snapshot
                                        .data![pageIndex]!.data!.items![index];
                                    return GestureDetector(
                                      onTap: () async {
                                        if (item.basePrice! < 875) return;
                                        FirebaseSkin? skin =
                                            await FireStoreService()
                                                .getSkinById(item.uuid!);
                                        if (skin != null) {
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                SkinDetailPage(skin: skin),
                                          ));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 0),
                                        child: Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            color: const Color(0xFF16141a)
                                                .withOpacity(.7),
                                            height: 200,
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: AnimatedOverflow(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        animatedOverflowDirection:
                                                            AnimatedOverflowDirection
                                                                .HORIZONTAL,
                                                        speed: 50,
                                                        padding: 0,
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.start,
                                                          item.name!,
                                                          softWrap: false,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Hero(
                                                  tag: item.name!,
                                                  child: Image(
                                                    height: 100,
                                                    image: NetworkImage(
                                                      item.image!,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    const Spacer(),
                                                    Text(
                                                      "${item.basePrice} ",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const Image(
                                                      height: 20,
                                                      image: NetworkImage(
                                                        "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data!.length,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: indicators(snapshot.data!.length, activePage),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: double.infinity,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(snapshot.error.toString()),
                  ),
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
                        Text('Loading Bundle'),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.white : Colors.white30,
          shape: BoxShape.circle,
        ),
      );
    });
  }
}
