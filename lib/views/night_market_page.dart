import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/color_extension.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/views/skin_detail_page.dart';

import '../main.dart';

final color = const Color(0xFF16141a).withOpacity(.8);

class NightMarketPage extends StatefulWidget {
  const NightMarketPage({super.key});

  @override
  State<NightMarketPage> createState() => _NightMarketPageState();
}

class _NightMarketPageState extends State<NightMarketPage> {
  late Future<NightMarket?> _nightMarket;

  @override
  void initState() {
    super.initState();
    _nightMarket = RiotService.getNightMarket();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _nightMarket,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        } else if (!snapshot.hasData) {
          return noNightMarket();
        } else if (snapshot.hasData) {
          return nightMarket(snapshot.data!);
        }
        return errorLoading();
      },
    );
  }
}

Widget loading() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      drawer: const NavDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

Widget noNightMarket() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      drawer: const NavDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.cloudMoon),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "There is currently no Night Market",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () async => await launchUrl(
                  Uri.parse("https://twitter.com/ValorLeaks"),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Check ValorLeaks on Twitter for updates",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget errorLoading() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      drawer: const NavDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: Text("Error retrieving Data"),
        ),
      ),
    );

Widget nightMarket(NightMarket store) => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.timer,
                size: 20,
              ),
              CountdownTimer(
                endTime: DateTime.now().millisecondsSinceEpoch +
                    store.durationRemain! * 1000,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
      drawer: const NavDrawer(),
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: store.skins!.length,
          itemBuilder: (context, index) {
            final colorString =
                store.skins?[index]?.skinData?.contentTier?.color != null
                    ? store.skins![index]!.skinData!.contentTier!.color
                    : "252525";
            final Color color = HexColor(colorString!).withOpacity(.7);
            final skin = store.skins![index]!;
            return GestureDetector(
              onTap: (() {
                navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: ((context) {
                  return SkinDetailPage(skin: skin.skinData!);
                })));
              }),
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
                          store.skins![index]!.skinData!.contentTier!.icon!,
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
                                skin.skinData!.name!,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Hero(
                          tag: skin.skinData!.name!,
                          child: Image.network(
                            skin.skinData!.icon!,
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
                              skin.skinData!.cost!.toString(),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              (skin.skinData!.cost! - skin.reducedCost!)
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
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
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(-${skin.percentageReduced!}%)",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
        ),
      ),
    );
