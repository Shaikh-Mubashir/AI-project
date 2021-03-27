import 'package:chat/login.dart';
import 'package:chat/models/userDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>UserDetails()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
         // theme: ThemeData.dark(),
          home: Login(),
      ),
    );
  }
}
