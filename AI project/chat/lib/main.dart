import 'file:///D:/ilhan%20flutter/AI-project/AI%20project/chat/lib/screens/login.dart';
import 'package:chat/models/chatsModel.dart';
import 'package:chat/models/userDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDetails()),
        ChangeNotifierProvider(create: (context) => ChatModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark(),
        home: Login(),
      ),
    );
  }
}
