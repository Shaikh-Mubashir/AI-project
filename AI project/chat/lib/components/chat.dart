import 'package:chat/screens/chatDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUsersList extends StatefulWidget {
  String msgDocId;
  String name;

  ChatUsersList({@required this.name, this.msgDocId});

  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  String last, time, image;
  DateTime timeParsed;
  bool msgsExist = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getLastMessage() async {
    final msgData = await _firestore
        .collection('messages')
        .doc(widget.msgDocId)
        .collection('conversation')
        .get();

    List<DateTime> dates = [];
    DateTime maxDate = DateTime.now();
    print(msgData.docs.isEmpty);
    if (msgData.docs.isNotEmpty) {
      print('exist');
      for (var data in msgData.docs) {
        dates.add(DateTime.parse(data.data()['dateTime']));
      }
      maxDate = calcMaxDate(dates);
      final lastMsg = await _firestore
          .collection('messages')
          .doc(widget.msgDocId)
          .collection('conversation')
          .where('dateTime', isEqualTo: maxDate.toString())
          .get();

      for (var msg in lastMsg.docs) {
        if (msg.data()['type'] == 'Text') {
          last = msg.data()['text'];
        } else if (msg.data()['type'] == 'Image') {
          last = 'Image exist';
        } else {
          last = 'Video exist';
        }
      }
    } else {
      last = 'Tap here to start conversation.';
    }
    time = maxDate.toString();
    setState(() {
      msgsExist = true;
      timeParsed = DateTime.parse(time);
    });
  }

  DateTime calcMaxDate(List<DateTime> dates) {
    DateTime maxDate = dates[0];
    dates.forEach((date) {
      if (date.isAfter(maxDate)) {
        maxDate = date;
      }
    });
    return maxDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLastMessage();
  }

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
                receiverName: widget.name,
                msgDocId: widget.msgDocId,
              );
            },
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage('images/userImage8.jpg'),
        maxRadius: 30,
      ),
      title: Text(
        widget.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: msgsExist
          ? Text(
              last,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            )
          : LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
      trailing: msgsExist
          ? Text("${timeParsed.hour}:${timeParsed.minute}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500))
          : Text(' '),
    );
  }
}
