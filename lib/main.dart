import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Popup Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const YouTubeVideoDialog(
                // videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                videoUrl: 'https://www.youtube.com/shorts/uycvlIhCJgY',
              ),
            );
          },
          child: const Text('Show YouTube Video'),
        ),
      ),
    );
  }
}

class YouTubeVideoDialog extends StatefulWidget {
  final String? videoUrl;
  const YouTubeVideoDialog({super.key, this.videoUrl});

  @override
  State<YouTubeVideoDialog> createState() => _YouTubeVideoDialogState();
}

class _YouTubeVideoDialogState extends State<YouTubeVideoDialog> {
  late YoutubePlayerController _videoController;
  double aspectRatio = 16 / 9;
  void updateAspectRatio() {
    bool isShort = isShortVideo();
    setState(() {
      aspectRatio = isShort ?  9 / 16 :16 / 9 ;
    });
    print("isShortVideo: $isShort, aspectRatio: $aspectRatio");
  }
  bool isShortVideo() {
    String videoId = widget.videoUrl!;
    return videoId.contains('shorts');
  }
  @override
  void initState() {
    super.initState();
    _videoController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    updateAspectRatio();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          YoutubePlayer(
            aspectRatio: aspectRatio,
            controller: _videoController,
            showVideoProgressIndicator: true,
          ),
          Positioned(
            top: -5,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
