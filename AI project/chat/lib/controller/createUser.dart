import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chat/controller/messageController.dart';
import 'package:chat/models/userDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class CreateUser {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uploadedImgUrl;
  Future<bool> registerUser(
      String username, String email, String pass, File image) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        await uploadProfileImage(image);
        await _firestore.collection('user').doc().set({
          'name': username,
          'email': email,
          'password': pass,
          'status': 'offline',
          'image': uploadedImgUrl ??
              'https://firebasestorage.googleapis.com/v0/b/chat-c1f2d.appspot.com/o/profileImages%2Fprofile.jpg?alt=media&token=2314d8b2-0e41-4b80-93f8-e5fd43a47159'
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> uploadProfileImage(File _image) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref('profileImages/${DateTime.now().toString()}');
    await storageReference.putFile(_image);
    uploadedImgUrl = await storageReference.getDownloadURL();
  }

  logOut(context) async {
    _auth.signOut();
    MessageController _msg = MessageController();
    _msg.updateOnlineStatus(context, 'offline');
  }

  Future<bool> logInUser(context, String email, String password) async {
    try {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        bool check = await getChatuser(context, email);
        MessageController _msg = MessageController();
        await _msg.updateOnlineStatus(context, 'online');
        print('printing => $check');
        if (check) {
          return true;
        } else {
          return false;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getChatuser(context, String checkemail) async {
    print(checkemail);
    try {
      String username, email, pass, image, uid;
      final user = await _firestore
          .collection('user')
          .where('email', isEqualTo: checkemail)
          .get();
      for (var data in user.docs) {
        username = data.data()['name'];
        email = data.data()['email'];
        pass = data.data()['password'];
        image = data.data()['image'];
        uid = data.id;
      }
      Provider.of<UserDetails>(context, listen: false).setUserDetails(
          name: username, email: email, password: pass, uid: uid, image: image);
      return true;
    } catch (e) {
      return false;
    }
  }
}
