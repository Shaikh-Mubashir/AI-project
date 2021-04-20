import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayer extends StatefulWidget {
  String url;
  bool networkUrl;
  VideoPlayer({this.url, this.networkUrl});
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return widget.networkUrl
        ? BetterPlayer.network(
            widget.url,
            betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: 1.5,
                looping: true,
                //autoPlay: true,
                fit: BoxFit.contain),
          )
        : BetterPlayer.file(
            widget.url,
            betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: 1.5,
                looping: true,
                //autoPlay: true,
                fit: BoxFit.contain),
          );
  }
}
