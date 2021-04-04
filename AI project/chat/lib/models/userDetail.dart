import 'package:flutter/cupertino.dart';

class UserDetails extends ChangeNotifier{
  String _name,_email,_password,_uid;

   setUserDetails({String uid,String name, String email, String password}){
     _name=name;
     _email=email;
     _password=password;
     _uid=uid;
     notifyListeners();
   }

   get getUserDocID{return _uid;}
   get getUserName{return _name;}
   get getEmail{return _email;}
   get getPassword{return _password;}
}