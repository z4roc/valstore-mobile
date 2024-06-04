import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  ChewieController? chewieController;

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _controller.initialize();
    createChewieController();
    setState(() {});
  }

  void createChewieController() {
    chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        hideControlsTimer: const Duration(seconds: 1),
        materialProgressColors: ChewieProgressColors());
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: chewieController != null &&
                    chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: chewieController!,
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Loading'),
                    ],
                  ),
          )),
        ],
      ),
    );
  }
}
