import 'package:chat/chatDetailPage.dart';
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: (widget.chatMessage.type==MessageType.Receiver?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.type==MessageType.Receiver?Colors.blueGrey[100]:Colors.grey.shade300),
          ),
         // padding: EdgeInsets.all(16),



          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.chatMessage.Messages),
          ),
        ),
      ),
    );
  }
}
