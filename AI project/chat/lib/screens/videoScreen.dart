import 'dart:io';
import 'package:chat/components/alertBoxes.dart';
import 'package:chat/components/videoPlayer.dart';
import 'package:chat/controller/messageController.dart';
import 'package:chat/models/userDetail.dart';
import 'package:chat/screens/chatDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoScreen extends StatefulWidget {
  File video;
  String msgDocId, recName, userImage;
  VideoScreen({this.video, this.msgDocId, this.recName, this.userImage});
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  AlertBoxes _alert;
  MessageController _msg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: VideoPlayer(
          url: widget.video.path,
          networkUrl: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Send Video',
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
        onPressed: () async {
          _alert = AlertBoxes();
          _msg = MessageController();
          _alert.loadingAlertBox(context);
          bool check = await _msg.sendVideo(
              widget.recName,
              Provider.of<UserDetails>(context, listen: false).getUserName,
              widget.video,
              widget.msgDocId);
          if (check) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                        receiverName: widget.recName,
                        msgDocId: widget.msgDocId,
                        image: widget.userImage)));
          } else {
            Navigator.pop(context);
            _alert.simpleAlertBox(context, 'Failed',
                'Unable to send video. Please try again later.');
          }
        },
      ),
    );
  }
}
