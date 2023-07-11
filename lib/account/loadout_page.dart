import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:valstore/shared/color_extension.dart';
import 'package:valstore/services/riot_service.dart';

class LoadOutPage extends StatefulWidget {
  const LoadOutPage({super.key});

  @override
  State<LoadOutPage> createState() => _LoadOutPageState();
}

class _LoadOutPageState extends State<LoadOutPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RiotService.getPlayerEquipedSkins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final guns = snapshot.data?.reversed.toList();

          return ListView.builder(
            itemBuilder: (context, index) {
              final gun = guns?[index];
              final color = gun?.skin?.contentTier?.color != null
                  ? HexColor(gun!.skin!.contentTier!.color!)
                  : Colors.grey;
              return Container(
                padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
                height: 150,
                width: double.infinity,
                child: Card(
                  color: Colors.transparent,
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 5),
                    decoration: BoxDecoration(
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
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              gun?.skin?.name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            gun?.skin?.contentTier?.icon != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        gun?.skin?.contentTier?.icon ?? "",
                                    height: 20,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CachedNetworkImage(
                            height: 70,
                            width: 250,
                            imageUrl:
                                "https://media.valorant-api.com/weaponskinchromas/${gun?.gun?.chromaID}/fullrender.png"),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: guns?.length ?? 0,
          );
        }
      },
    );
  }
}
