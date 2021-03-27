import 'package:chat/components/chatBubble.dart';
import 'package:chat/components/chat_detail_page_appBar.dart';
import 'package:chat/models/chat_Messages.dart';
import 'package:flutter/material.dart';
enum MessageType{
  Sender,
  Receiver,
}
class ChatDetailPage extends StatefulWidget {

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> chatMessage=[
    ChatMessage(Messages: " Kahan ho?", type: MessageType.Sender),
    ChatMessage(Messages: " Ghar p", type: MessageType.Receiver),
    ChatMessage(Messages: " Bahar ao...", type: MessageType.Sender),
    ChatMessage(Messages: " 5 mint m aya", type: MessageType.Receiver),
    ChatMessage(Messages: " Ok...!", type: MessageType.Sender),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(),
      body: Stack(
        children: [
          ListView.builder(
            itemCount:chatMessage.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              return ChatBubble(
                chatMessage: chatMessage[index],

              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16,bottom: 8),
              height: 80.0,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.add,color: Colors.white,size: 21,),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(

                      decoration: InputDecoration(

                        hintText: "Type message...",
                        hintStyle: TextStyle(
                          color: Colors.teal,

                        ),
                        border: InputBorder.none
                      ),

                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30,bottom: 50),
              child: FloatingActionButton(
                onPressed: (){},
                child: Icon(Icons.send,color: Colors.white,),
                backgroundColor: Colors.teal,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
