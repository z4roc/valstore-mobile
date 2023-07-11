import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/shared/video_player_page.dart';

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
      //backgroundColor: const Color(0xFF16141a).withOpacity(.8),
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
            Expanded(
              child: Text(
                skin.name!,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  skin.chromas?.isEmpty ?? false
                      ? const SizedBox()
                      : displayRP(15),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Card(
                  color: const Color.fromARGB(255, 31, 28, 37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PageView.builder(
                    pageSnapping: true,
                    onPageChanged: (value) {
                      setState(() {
                        activePage = value;
                      });
                    },
                    itemBuilder: ((context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 0, 10),
                                  child: skin.name !=
                                          skin.chromas![index].displayName!
                                      ? Text(
                                          skin.chromas![index].displayName!
                                              .split("(")
                                              .last
                                              .split(")")
                                              .first,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : const Text(
                                          "Default",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            index == 0
                                ? Hero(
                                    tag: skin.name!,
                                    child: Image.network(
                                      image,
                                      height: 120,
                                      width: double.infinity,
                                    ),
                                  )
                                : Image.network(
                                    skin.chromas![index].fullRender!,
                                    height: 120,
                                  ),
                            const Spacer(),
                            Row(
                              children: [
                                skin.chromas?[index].streamedVideo != null
                                    ? TextButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => VideoPlayerPage(
                                            url: skin
                                                .chromas![index].streamedVideo!,
                                            title: skin.chromas?[index]
                                                    .displayName ??
                                                "Chroma ${index + 1}",
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.redAccent,
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.play_arrow_rounded,
                                            ),
                                            Text("Video"),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
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
                children: indicators(skin.chromas?.length, activePage),
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
                height: 250,
                child: ListView.builder(
                  itemCount: skin.levels != null ? skin.levels!.length : 0,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () async {
                        /*navigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(
                              url: skin.levels![index].streamedVideo!,
                            ),
                          ),
                        );*/

                        //initializePlayer(skin.levels![index].streamedVideo!);

                        showCupertinoDialog(
                          context: context,
                          builder: (context) => VideoPlayerPage(
                            url: skin.levels![index].streamedVideo!,
                            title:
                                skin.levels?[index].levelItem ?? "Level $index",
                          ),
                        );
                      },
                      child: SizedBox(
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
                                    : "Level ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              skin.levels?[index].streamedVideo != null
                                  ? TextButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => VideoPlayerPage(
                                          url: skin
                                              .levels![index].streamedVideo!,
                                          title:
                                              skin.levels?[index].displayName ??
                                                  "Chroma $index",
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.redAccent,
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.play_arrow_rounded,
                                          ),
                                          Text("Video"),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
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
