import 'package:flutter/material.dart';
import 'package:flutter_client/pages/home/upload_page.dart';
import 'package:flutter_client/pages/home/video_player_page.dart';
import 'package:flutter_client/services/video_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final videosFuture = VideoService().getVideos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Stream'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, UploadPage.route());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final videos = snapshot.data!;

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final thumbnail =
                  "https://d1unjxa15f7twa.cloudfront.net/${video['video_s3_key'].replaceAll('.mp4', "").replaceAll("videos/", "thumbnails/")}";

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, VideoPlayerPage.route(video));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            thumbnail,
                            fit: BoxFit.cover,
                            headers: {'Content-Type': 'image/jpg'},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          video['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
