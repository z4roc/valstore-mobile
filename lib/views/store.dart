import 'package:flutter/material.dart';
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
                      return SizedBox(
                        height: 200,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data![index].name!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(snapshot.data![index].cost.toString()),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Image(
                                      height: 15,
                                      image: NetworkImage(
                                        "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                                      ),
                                    ),
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
