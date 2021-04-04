import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:chat/models/userDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CreateUser {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> registerUser(String username, String email, String pass) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        await _firestore.collection('user').doc().set({
          'name': username,
          'email': email,
          'password': pass,
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  // Future<String> uploadProfileImage(File _image) async {
  //   firebase_storage.Reference storageReference =firebase_storage.FirebaseStorage.instance
  //       .ref('profileImages/${Path.basename(_image.path)}');
  //   await  storageReference.putFile(_image);
  //   uploadedImgUrl= await storageReference.getDownloadURL();
  //   return uploadedImgUrl;
  // }

  logOut()async{
    _auth.signOut();
  }

  Future<bool> logInUser(context,String email, String password) async {
    try {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await getChatuser(context, email);
      });
      return true;
    }
    catch(e){
      return false;
    }
  }


  Future<void> getChatuser(context, String checkemail) async {
    String username, email, pass, cpass,uid;
    final user = await _firestore
        .collection('user')
        .where('email', isEqualTo: checkemail)
        .get();
    for (var data in user.docs) {
      username = data.data()['name'];
      email = data.data()['email'];
      pass = data.data()['password'];
      uid=data.id;
    }
    Provider.of<UserDetails>(context,listen: false).setUserDetails(name: username,email: email,password: pass,uid: uid);
  }
}
