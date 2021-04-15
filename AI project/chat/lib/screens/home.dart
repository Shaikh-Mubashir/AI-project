import 'dart:async';

import 'package:chat/components/chat.dart';
import 'package:chat/models/chatsModel.dart';
import 'package:chat/models/userDetail.dart';
import 'package:chat/screens/addFriend.dart';
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

  Future<void> getFriends() async {
    print('timer called');
    Timer(
      Duration(seconds: 2),
      () async {
        final frndsData = await _firestore
            .collection('user')
            .doc(Provider.of<UserDetails>(context, listen: false).getUserDocID)
            .collection('friends')
            .get();
        for (var data in frndsData.docs) {
          userDocIds.add(data.data()['userDocId']);
          msgDocIds.add(data.data()['messageDocId']);
        }
        await getUserList(userDocIds, msgDocIds);
        setState(() {
          print('set state called');
          showLoader = false;
        });
      },
    );
    print('timer end');
  }

  Future<void> getUserList(List<String> usersList, List<String> msgs) async {
    print(usersList);
    print(msgs);
    for (int i = 0; i < usersList.length; i++) {
      await Provider.of<ChatModel>(context, listen: false)
          .getFriendsData(usersList[i], msgs[i]);
    }
    Provider.of<ChatModel>(context, listen: false).setloader(false);
    print('chl rha hai');
  }

  runMethods() async {
    await getFriends();
  }

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ChatModel>(context, listen: false).clearList();
    super.initState();
    runMethods();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Chats',
              //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => AddFriends()));
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.only(
              //               left: 8, right: 8, top: 2, bottom: 2),
              //           height: 30,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(30),
              //               color: Colors.pink[50]),
              //           child: Row(
              //             children: [
              //               Icon(
              //                 Icons.add,
              //                 color: Colors.pink,
              //                 size: 30,
              //               ),
              //               SizedBox(
              //                 width: 2,
              //               ),
              //               Text(
              //                 'New',
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 19),
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
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
                          borderSide: BorderSide(color: Colors.grey.shade100))),
                ),
              ),
              showLoader
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    )
                  : Container(
                      height: height * 0.7,
                      child: Consumer<ChatModel>(
                        builder: (context, data, child) {
                          return data.userMessages.isNotEmpty
                              ? ListView.builder(
                                  itemCount: data.userMessages.length,
                                  itemBuilder: (context, i) {
                                    return ChatUsersList(
                                      text: data.userMessages[i].text,
                                      secondarytext:
                                          data.userMessages[i].secondarytext,
                                      image: data.userMessages[i].image,
                                      time: data.userMessages[i].time,
                                      msgDocId: data.userMessages[i].docId,
                                    );
                                  })
                              : Center(child: Text('No chats available'));
                        },
                      ),
                    )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
                tooltip: 'Add a new Friend',
                backgroundColor: Colors.teal,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriends()));
                }),
          )
        ],
      ),
    );
  }
}
// StreamBuilder(
// stream: _firestore
//     .collection('user')
// .doc(Provider.of<UserDetails>(context, listen: false)
// .getUserDocID)
// .collection('friends')
// .snapshots(),
// builder: (context, snapshot) {
// if (snapshot.hasError) {
// return Center(
// child: CircularProgressIndicator(
// valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
// );
// }
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(
// valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
// );
// }
//
// List<String> docIds = [];
// List<String> msgIds = [];
// final data = snapshot.data.docs;
// for (var frnds in data) {
// docIds.add(frnds.data()['userDocId']);
// msgIds.add(frnds.data()['messageDocId']);
// }
// print(docIds);
// getUserList(docIds, msgIds);
// print(Provider.of<ChatModel>(context, listen: false)
//     .userMessages);
// return Consumer<ChatModel>(
// builder: (context, data, child) {
// return data.userMessages.length != 0
// ? ListView.builder(
// itemCount: data.userMessages.length,
// itemBuilder: (context, i) {
// return data.userMessages.isEmpty
// ? Text('You have no chats available.')
//     : ChatUsersList(
// msgDocId: data.userMessages[i].docId,
// text: data.userMessages[i].text,
// secondarytext:
// data.userMessages[i].secondarytext,
// image: data.userMessages[i].image,
// time: data.userMessages[i].time);
// },
// )
//     : Center(
// child: CircularProgressIndicator(
// valueColor:
// AlwaysStoppedAnimation<Color>(Colors.teal)),
// );
// },
// );
// },
// ),
