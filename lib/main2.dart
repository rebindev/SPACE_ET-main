import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _controller.initialize().then((value) {
      setState(() {
        loaded = true;
      });
    });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 2 / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text("وانەی یەکەم-تەکنۆلۆجی"),
        leading: BackButton(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildAppBar(context, appBarHeight),
          _build_video_player(),
          _buildImageAsset(context)
        ],
      ),
    );
  }

  Widget _build_video_player() {
    final size = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children: [
          Text("باینەری چییە؟"),
          AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: IconButton(
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            setState(() {});
                          } else {
                            _controller.play();
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          color: Colors.white,
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          size: 50,
                        )),
                  )
                ],
              )),
          Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: () {}, child: Text("بەردەوامبە")))
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, double appBarHeight) {
    return ClipPath(
      clipper: CurvedAppBarClipper(),
      child: Container(
        height: appBarHeight,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildImageAsset(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Image.asset(
        'assets/pictures/bust-23.png',
        fit: BoxFit.cover,
        height: 200,
      ),
    );
  }
}

class CurvedAppBarClipper extends CustomClipper<Path> {
  final double topCurveHeight =
      60.0; // Adjust this value to change top curve height
  final double bottomCurveHeight =
      60.0; // Adjust this value to change bottom curve height

  @override
  Path getClip(Size size) {
    Path path = Path();
    double appBarHeight = size.height;

    path.lineTo(0, topCurveHeight);
    path.quadraticBezierTo(
        size.width / 2, topCurveHeight * 2, size.width, topCurveHeight);
    path.lineTo(size.width, size.height - bottomCurveHeight);
    path.quadraticBezierTo(
        size.width / 2,
        size.height - (bottomCurveHeight * 2),
        0,
        size.height - bottomCurveHeight);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
