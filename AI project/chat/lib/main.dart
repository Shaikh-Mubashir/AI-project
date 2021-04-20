import 'package:chat/models/chatsModel.dart';
import 'package:chat/models/userDetail.dart';
import 'package:chat/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print(
          '//////////////////////APPLICATION ENDED/////////////////////////////////');
      return;
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      // _msg.updateOnlineStatus(context, 'offline');
      print(
          '//////////////////////APPLICATION ENDED 2/////////////////////////////////');
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

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
