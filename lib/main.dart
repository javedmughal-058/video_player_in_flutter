import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'https://www.fluttercampus.com/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
  }
  getVideoPosition() {
    var duration = Duration(milliseconds: _controller.value.position.inMilliseconds.round());
    return [duration.inHours, duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }
  String videoDuration(Duration duration) {
    var date = duration.toString().split(":");
    var hrs = date[0];
    var mns = date[1];
    var sds = date[2].split(".")[0];
    return "$hrs:$mns:$sds";
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text("Duration: " + getVideoPosition()+" / " +  videoDuration(_controller.value.duration)),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors:VideoProgressColors(
                    backgroundColor: Colors.black54,
                    playedColor: Colors.red,
                    bufferedColor: Colors.grey.shade300,
                  )
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: (){
                    if(_controller.value.isPlaying){
                      _controller.pause();
                    }else{
                      _controller.play();
                    }

                    setState(() {

                    });
                  },
                  icon:Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow)
              ),
              IconButton(
                  onPressed: (){
                    _controller.seekTo(const Duration(seconds: 0));

                    setState(() {

                    });
                  },
                  icon:const Icon(Icons.stop)
              )
            ],
          )
        ],
      ) ,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
