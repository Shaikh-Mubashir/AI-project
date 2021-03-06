import 'package:chat/components/videoPlayer.dart';
import 'package:chat/models/chat_Messages.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;

  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.chatMessage.isMe);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment:
            (!widget.chatMessage.isMe ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.isMe
                ? Colors.blueGrey[100]
                : Colors.grey.shade300),
          ),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.chatMessage.type == 'Text'
                  ? Text(widget.chatMessage.Messages)
                  : widget.chatMessage.type == 'Image'
                      ? Container(
                          height: 350.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(widget.chatMessage.Messages),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          height: 200.0,
                          width: 280.0,
                          child: VideoPlayer(
                            url: widget.chatMessage.Messages,
                            networkUrl: true,
                          ),
                        )),
        ),
      ),
    );
  }
}
