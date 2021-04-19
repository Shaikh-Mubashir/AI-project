import 'package:chat/components/chatBubble.dart';
import 'package:chat/components/chat_detail_page_appBar.dart';
import 'package:chat/controller/messageController.dart';
import 'package:chat/models/chat_Messages.dart';
import 'package:chat/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/controller/chatBotController.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  String receiverName, msgDocId, image;
  ChatDetailPage({this.receiverName, this.msgDocId, this.image});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  MessageController _msgController;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatMessage> chatMessage = [];
  TextEditingController _message = TextEditingController();

  File _cimage;
  final imagepicker = ImagePicker();

  Future getCamera() async {
    final pickedFile = await imagepicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _cimage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await imagepicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _cimage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  File _video;
  final videopicker = ImagePicker();

  Future getvideo() async {
    final pickedFile = await videopicker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.receiverName = '';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print(
          '//////////////////////APPLICATION ENDED/////////////////////////////////');
      return;
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      // _msg.updateOnlineStatus(context, 'offline');

    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatDetailPageAppBar(
        receiverName: widget.receiverName,
        image: widget.image,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('messages')
                      .doc(widget.msgDocId)
                      .collection('conversation')
                      .orderBy('dateTime', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal)),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal)),
                      );
                    }

                    final messages = snapshot.data.docs;
                    String text, sender, receiver, dateTime, type;
                    List<ChatBubble> msgBubble = [];
                    for (var msgs in messages) {
                      chatMessage.add(ChatMessage(Messages: null, isMe: null));
                      msgBubble.add(ChatBubble(
                          chatMessage: ChatMessage(
                              Messages: msgs.data()['text'],
                              dateTime: msgs.data()['dateTime'],
                              isMe: msgs.data()['senderName'] ==
                                      Provider.of<UserDetails>(context,
                                              listen: false)
                                          .getUserName
                                  ? true
                                  : false,
                              type: msgs.data()['type'])));
                    }
                    return msgBubble.isNotEmpty
                        ? Column(
                            children: msgBubble,
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: Center(
                              child: Text(
                                'No messages',
                                style: TextStyle(
                                    color: Colors.teal[100],
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return bottomSheet();
                        });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _message,
                    maxLines: 10,
                    decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: TextStyle(
                          color: Colors.teal,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _msgController = MessageController();
                    try {
                      if (_message.text.isNotEmpty) {
                        _msgController.sendTextMessage(
                            widget.receiverName,
                            Provider.of<UserDetails>(context, listen: false)
                                .getUserName,
                            _message.text,
                            'Text',
                            widget.msgDocId);
                        _msgController.sendAnswerByBot(
                            myName:
                                Provider.of<UserDetails>(context, listen: false)
                                    .getUserName,
                            senderName: widget.receiverName,
                            message: _message.text,
                            type: 'Text',
                            msgDocId: widget.msgDocId);

                        _message.clear();
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 25.0,
                    child: Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 200.0,
      width: double.infinity,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                getCamera();
              },
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                radius: 30.0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                radius: 30.0,
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                getvideo();
              },
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 30.0,
                child: Icon(
                  Icons.video_call,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
