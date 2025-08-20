import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  static route(Map<String, dynamic> video) =>
      MaterialPageRoute(builder: (context) => VideoPlayerPage(video: video));
  final Map<String, dynamic> video;
  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enablePlayPause: true,
          enableProgressBar: true,
          enablePlaybackSpeed: true,
          enableQualities: true,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource.network(
        "https://d3iiasefxo4uf9.cloudfront.net/${widget.video['video_s3_key']}/manifest.mpd",
        videoFormat: BetterPlayerVideoFormat.dash,
      ),
    );
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BetterPlayer(controller: betterPlayerController),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.video['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(widget.video['description']),
          ),
        ],
      ),
    );
  }
}
