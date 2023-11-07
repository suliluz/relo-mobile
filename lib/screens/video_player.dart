import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

enum VideoSource {
  network,
  file,
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.source,
    required this.url,
  });
  
  final VideoSource source;
  final String url;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  late bool _isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    switch (widget.source) {
      case VideoSource.network:
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case VideoSource.file:
        _controller = VideoPlayerController.file(File(widget.url));
        break;
    }
    
    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });

    _controller.addListener(_handleListener);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Stack(
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              _controller.value.isInitialized ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ) : const CircularProgressIndicator(),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: getWidth(),
                  color: Colors.black.withOpacity(0.3),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        '${_controller.value.position.inMinutes.toString().padLeft(2, "0")}:${_controller.value.position.inSeconds.remainder(60).toString().padLeft(2, "0")}',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Theme.of(context).primaryColor,
                              bufferedColor: Colors.white,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${_controller.value.duration.inMinutes.toString().padLeft(2, "0")}:${_controller.value.duration.inSeconds.remainder(60).toString().padLeft(2, "0")}',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  _handleListener() {
    if(_controller.value.isPlaying) {
      _isPlaying = true;
    } else {
      _isPlaying = false;
    }

    setState(() {});
  }

  double getWidth() {
    // If on landscape mode
    if(MediaQuery.of(context).orientation == Orientation.landscape) {
      return MediaQuery.of(context).size.height * _controller.value.aspectRatio;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
}
