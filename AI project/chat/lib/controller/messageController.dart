import 'package:cloud_firestore/cloud_firestore.dart';

class MessageController{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

 sendTextMessage(String recName,String senderName,String message,String type,String msgDocId)async{

    await _firestore.collection('messages').doc(msgDocId).collection('conversation').doc().set({
      'text':message,
      'senderName':senderName,
      'receiverName':recName,
      'dateTime':DateTime.now().toString(),
      'type':'Text'
    });

  }


}