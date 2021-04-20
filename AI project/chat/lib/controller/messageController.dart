import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:chat/controller/chatBotController.dart';
import 'package:chat/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MessageController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChatBot bot;
  sendTextMessage(String recName, String senderName, String message,
      String type, String msgDocId) async {
    await _firestore
        .collection('messages')
        .doc(msgDocId)
        .collection('conversation')
        .doc()
        .set({
      'text': message,
      'senderName': senderName,
      'receiverName': recName,
      'dateTime': DateTime.now().toString(),
      'type': type
    });
  }

  sendAnswerByBot(
      {String myName,
      String senderName,
      String message,
      String type,
      String msgDocId}) async {
    final userStatus = await _firestore
        .collection('user')
        .where('name', isEqualTo: senderName)
        .get();
    for (var data in userStatus.docs) {
      if (data.data()['status'] == 'offline') {
        bot = ChatBot();
        await bot.initChatBot();
        String answer = await bot.getAnswerByChatBot(message);
        sendTextMessage(myName, senderName, answer, type, msgDocId);
      }
    }
  }

  updateOnlineStatus(context, String status) async {
    await _firestore
        .collection('user')
        .doc(Provider.of<UserDetails>(context, listen: false).getUserDocID)
        .update({'status': status});
  }

  Future<bool> sendImage(
      String recName, String senderName, File image, String msgDocId) async {
    try {
      String uploadedImgUrl;
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref('messengerImages/${DateTime.now().toString()}');
      await storageReference.putFile(image);
      uploadedImgUrl = await storageReference.getDownloadURL();
      sendTextMessage(recName, senderName, uploadedImgUrl, 'Image', msgDocId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendVideo(
      String recName, String senderName, File video, String msgDocId) async {
    try {
      String uploadedImgUrl;
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref('messengerVideos/${DateTime.now().toString()}');
      await storageReference.putFile(video);
      uploadedImgUrl = await storageReference.getDownloadURL();
      sendTextMessage(recName, senderName, uploadedImgUrl, 'Video', msgDocId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
