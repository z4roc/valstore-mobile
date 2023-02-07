import 'package:flutter/material.dart';
import 'package:valstore/color_extension.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/services/riot_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: const Color(0xFF16141a).withOpacity(.8),
          drawer: const NavDrawer(),
          appBar: AppBar(
            title: const Text('Your shop'),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder(
              future: RiotService().getStore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final colorString =
                          snapshot.data?[index].contentTier?.color != null
                              ? snapshot.data![index].contentTier!.color
                              : "252525";
                      final Color color =
                          HexColor(colorString!).withOpacity(.7);
                      return SizedBox(
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
                              fit: BoxFit.cover,
                              opacity: .6,
                              image: NetworkImage(
                                snapshot.data![index].contentTier!.icon!,
                              ),
                            )),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.data![index].name!,
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
                                Image(
                                  image: NetworkImage(
                                    snapshot.data![index].icon!,
                                  ),
                                  height: 100,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Spacer(),
                                    Text(
                                      snapshot.data![index].cost!.toString(),
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
                      );
                    },
                  );
                } else {
                  return Container(
                    height: double.infinity,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('Loading Store'),
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
          )),
    );
  }
}
