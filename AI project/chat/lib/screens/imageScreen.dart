import 'dart:io';
import 'package:chat/components/alertBoxes.dart';
import 'package:chat/models/userDetail.dart';
import 'package:chat/screens/chatDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/controller/messageController.dart';

class ImageScreen extends StatefulWidget {
  String recName, msgDocId, userImage;
  File image;
  ImageScreen({this.recName, this.msgDocId, this.image, this.userImage});
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  AlertBoxes _alert;
  MessageController _msg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          child: Image(
            image: FileImage(widget.image),
            fit: BoxFit.cover,
          ),
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
          bool check = await _msg.sendImage(
              widget.recName,
              Provider.of<UserDetails>(context, listen: false).getUserName,
              widget.image,
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
                'Unable to send picture. Please try again later.');
          }
        },
      ),
    );
  }
}
