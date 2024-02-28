import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/shared/color_extension.dart';
import 'package:valstore/valstore_provider.dart';
import 'package:valstore/shared/skin_detail_page.dart';

class NightMarketPage extends StatefulWidget {
  const NightMarketPage({super.key});

  @override
  State<NightMarketPage> createState() => _NightMarketPageState();
}

class _NightMarketPageState extends State<NightMarketPage> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValstoreProvider>(context);

    return FutureBuilder<bool>(
        future: state.getNightMarket(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MediaQuery.removePadding(
              removeTop: true,
              child: nightMarket(state.getInstance.nightMarket!),
              context: context,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return noNightMarket();
          }
        });
  }
}

Widget loading() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: const Color(0x00ff4655),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

Widget noNightMarket() => Container(
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
    );

Widget errorLoading() => Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      child: const Center(
        child: Text("Error retrieving Data"),
      ),
    );

Widget nightMarket(NightMarket store) => Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: store.skins!.length,
        itemBuilder: (context, index) {
          final colorString =
              store.skins?[index]?.skinData?.contentTier?.color != null
                  ? store.skins![index]!.skinData!.contentTier!.color
                  : "252525";
          final Color color = HexColor(colorString!);
          final skin = store.skins![index]!;
          return NightMarketItemTile(skin: skin, color: color);
        },
      ),
    );

class NightMarketItemTile extends StatelessWidget {
  const NightMarketItemTile({
    super.key,
    required this.skin,
    required this.color,
  });

  final NightMarketSkin skin;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (skin.skinData != null) {
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: ((context) {
            return SkinDetailPage(skin: skin.skinData!);
          })));
        }
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
                opacity: skin.skinData?.contentTier?.icon != null ? .2 : 0,
                image: NetworkImage(
                  skin.skinData?.contentTier?.icon ??
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
                        skin.skinData!.name!,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Image.network(
                      skin.skinData!.contentTier!.icon!,
                      height: 25,
                    ),
                    //
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: skin.skinData!.name!,
                  child: Image.network(
                    skin.skinData!.icon!,
                    height: 90,
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
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      (skin.skinData!.cost! - skin.reducedCost!).toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
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
  }
}
