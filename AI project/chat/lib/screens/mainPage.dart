import 'package:chat/controller/messageController.dart';
import 'package:chat/screens/FreindRequest.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  Widget pageSelector = HomeScreen();
  MessageController _msg = MessageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _msg.updateOnlineStatus(context, 'online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      _msg.updateOnlineStatus(context, 'offline');
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chattar Pattar',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            if (value == 0) {
              print('home');
              index = value;
              pageSelector = HomeScreen();
            } else if (value == 1) {
              print('Request');
              index = value;
              pageSelector = FriendRequest();
            } else {
              print('profile');
              index = value;
              pageSelector = Profile();
            }
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.threesixty),
            title: Text('Friend requests'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text('Profile'),
          )
        ],
      ),
      body: pageSelector,
    );
  }
}
