import 'dart:async';

import 'package:chat/components/chat.dart';
import 'package:chat/controller/createUser.dart';
import 'package:chat/controller/messageController.dart';
import 'package:chat/models/chatsModel.dart';
import 'package:chat/models/userDetail.dart';
import 'package:chat/screens/addFriend.dart';
import 'package:chat/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> userDocIds = [];
  List<String> msgDocIds = [];
  bool showLoader = true;
  MessageController _msg = MessageController();

  // Future<void> getFriends() async {
  //   print('timer called');
  //   Timer(
  //     Duration(seconds: 2),
  //     () async {
  //       final frndsData = await _firestore
  //           .collection('user')
  //           .doc(Provider.of<UserDetails>(context, listen: false).getUserDocID)
  //           .collection('friends')
  //           .get();
  //       for (var data in frndsData.docs) {
  //         userDocIds.add(data.data()['userDocId']);
  //         msgDocIds.add(data.data()['messageDocId']);
  //       }
  //       await getUserList(userDocIds, msgDocIds);
  //       setState(() {
  //         print('set state called');
  //         showLoader = false;
  //       });
  //     },
  //   );
  //   print('timer end');
  // }

  // Future<void> getUserList(List<String> usersList, List<String> msgs) async {
  //   print(usersList);
  //   print(msgs);
  //   for (int i = 0; i < usersList.length; i++) {
  //     await Provider.of<ChatModel>(context, listen: false)
  //         .getFriendsData(usersList[i], msgs[i]);
  //   }
  //   Provider.of<ChatModel>(context, listen: false).setloader(false);
  //   print('chl rha hai');
  // }

  // runMethods() async {
  //   await getFriends();
  // }

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ChatModel>(context, listen: false).clearList();
    super.initState();
    //runMethods();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      print('ending app called');
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
    Future<bool> onWillPopGoToLogIn() {
      CreateUser _user = CreateUser();
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Confirm Exit?',
                  style: new TextStyle(color: Colors.black, fontSize: 20.0)),
              content: new Text('Do you wish to Logout ?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () async {
                    _user.logOut(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: new Text('Yes', style: new TextStyle(fontSize: 18.0)),
                ),
                new FlatButton(
                  onPressed: () =>
                      Navigator.pop(context), // this line dismisses the dialog
                  child: new Text('No', style: new TextStyle(fontSize: 18.0)),
                )
              ],
            ),
          ) ??
          false;
    }

    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: onWillPopGoToLogIn,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Search....',
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.grey.shade100))),
                  ),
                ),
                Container(
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('user')
                        .doc(Provider.of<UserDetails>(context, listen: false)
                            .getUserDocID)
                        .collection('friends')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        );
                      }
                      List<ChatUsersList> friends = [];
                      final frndsData = snapshot.data.docs;
                      for (var data in frndsData) {
                        friends.add(ChatUsersList(
                          name: data.data()['name'],
                          msgDocId: data.data()['messageDocId'],
                          userDocId: data.data()['userDocId'],
                        ));
                      }
                      return friends.isNotEmpty
                          ? Column(
                              children: friends,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'No Chats available',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.teal[200]),
                                ),
                              ),
                            );
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 7.0, bottom: 7.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  tooltip: 'Add a new Friend',
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddFriends()));
                  }),
            ),
          )
        ],
      ),
    );
  }
}
