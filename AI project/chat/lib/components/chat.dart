import 'package:chat/screens/chatDetailPage.dart';
import 'package:flutter/material.dart';

class ChatUsersList extends StatefulWidget {
  String msgDocId;
  String text;
  String secondarytext;
  String image;
  String time;

  ChatUsersList(
      {@required this.text,
      @required this.secondarytext,
      @required this.image,
      @required this.time,
      this.msgDocId});

  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.black26,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatDetailPage(
                receiverName: widget.text,
                msgDocId: widget.msgDocId,
              );
            },
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage(widget.image),
        maxRadius: 30,
      ),
      title: Text(
        widget.text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        widget.secondarytext,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
      ),
      trailing: Text(
        widget.time,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
      ),
    );
  }
}
