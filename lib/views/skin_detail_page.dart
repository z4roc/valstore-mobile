import 'package:flutter/material.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/views/video_player_page.dart';

class SkinDetailPage extends StatefulWidget {
  const SkinDetailPage({super.key, required this.skin});

  final FirebaseSkin skin;

  @override
  State<SkinDetailPage> createState() => _SkinDetailPageState();
}

class _SkinDetailPageState extends State<SkinDetailPage> {
  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseSkin skin = widget.skin;
    String image = skin.icon!;
    return Scaffold(
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            skin.contentTier?.icon != null
                ? Image.network(
                    skin.contentTier!.icon!,
                    height: 22,
                  )
                : const SizedBox(),
            const SizedBox(
              width: 5,
            ),
            Text(
              skin.name!,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Chromas',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  skin.chromas!.isEmpty ? const SizedBox() : displayRP(15),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 210,
                child: Card(
                  color: const Color.fromARGB(255, 31, 28, 37),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: PageView.builder(
                    pageSnapping: true,
                    onPageChanged: (value) {
                      setState(() {
                        activePage = value;
                      });
                    },
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            index == 0
                                ? Hero(
                                    tag: skin.name!,
                                    child: Image.network(
                                      image,
                                      height: 120,
                                    ),
                                  )
                                : Image.network(
                                    skin.chromas![index].fullRender!,
                                    height: 125,
                                  ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  skin.name! !=
                                          skin.chromas![index].displayName!
                                      ? skin.chromas![index].displayName!
                                      : 'Default',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                skin.chromas![index].swatch != null
                                    ? Image.network(
                                        skin.chromas![index].swatch!,
                                        width: 50,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    itemCount: skin.chromas != null ? skin.chromas!.length : 0,
                    scrollDirection: Axis.horizontal,
                    physics: const PageScrollPhysics(),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicators(skin.chromas!.length, activePage),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Levels',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  displayRP(10),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: skin.levels != null ? skin.levels!.length : 0,
                  itemBuilder: ((context, index) {
                    return Container(
                      height: 75,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: const Color.fromARGB(255, 31, 28, 37),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              skin.levels![index].levelItem != null
                                  ? skin.levels![index].levelItem!
                                      .split('::')
                                      .last
                                  : 'Base Skin',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            skin.levels?[index].streamedVideo != null
                                ? TextButton(
                                    onPressed: () => navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => VideoPlayerPage(
                                        url: skin.levels![index].streamedVideo!,
                                      ),
                                    )),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                    ),
                                    child: const Text('Video'),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    skin.cost!.toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.network(
                    "https://media.valorant-api.com/currencies/85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741/displayicon.png",
                    height: 20,
                  ),
                ],
              )
            ],
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

  Widget displayRP(int amount) => Row(
        children: [
          Text("$amount "),
          Image.network(
            "https://media.valorant-api.com/currencies/e59aa87c-4cbf-517a-5983-6e81511be9b7/displayicon.png",
            height: 20,
          ),
          const Text(' per Upgrade'),
        ],
      );
}
