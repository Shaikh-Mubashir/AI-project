import 'package:chat/models/chat_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ChatModel extends ChangeNotifier {
  List<ChatUsers> userMessages = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _listLoaded = true;

  setloader(bool value) {
    _listLoaded = value;
  }

  get loader {
    return _listLoaded;
  }

  clearList() {
    userMessages.clear();
  }

  Future<void> getFriendsData(String userDocId, String msgDocId) async {
    final userData = await _firestore.collection('user').doc(userDocId).get();
    final msgData = await _firestore
        .collection('messages')
        .doc(msgDocId)
        .collection('conversation')
        .get();
    String last = '';
    bool msgsExist = true;
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
          .doc(msgDocId)
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

    userMessages.add(ChatUsers(
        docId: msgDocId,
        text: userData.data()['name'],
        secondarytext: last,
        image: "images/userImage8.jpg",
        time: maxDate.toLocal().toString().split(' ')[0]));
    notifyListeners();
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
}
