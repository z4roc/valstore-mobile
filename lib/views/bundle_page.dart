import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/services/riot_service.dart';

import '../models/bundle.dart';

class BundlePage extends StatefulWidget {
  const BundlePage({super.key});

  @override
  State<BundlePage> createState() => _BundlePageState();
}

class _BundlePageState extends State<BundlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Bundle'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder<BundleDisplayData?>(
          future: RiotService().getCurrentBundle(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            snapshot.data!.bundleData!.displayIcon!),
                        opacity: .6,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data!.bundleData!.displayName!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.data!.bundlePrice.toString(),
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.data!.items!.length,
                      itemBuilder: (context, index) {
                        Items item = snapshot.data!.data!.items![index];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(item.name!),
                                    const Spacer(),
                                    Text(item.basePrice.toString()),
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
                                  height: 125,
                                  image: NetworkImage(item.image!),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
    );
  }
}
