import 'package:flutter/material.dart';
import 'package:valstore/main.dart';
import 'package:valstore/shared/skin_detail_page.dart';

import '../models/firebase_skin.dart';

class StoreItemTile extends StatelessWidget {
  const StoreItemTile({
    super.key,
    required this.skin,
    required this.color,
  });

  final FirebaseSkin skin;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) {
          return SkinDetailPage(skin: skin);
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
                          fontSize: 18,
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
                  height: 10,
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
    );
  }
}
