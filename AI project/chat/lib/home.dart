import 'package:chat/addFriend.dart';
import 'package:chat/components/chat.dart';
import 'package:chat/models/chatsModel.dart';
import 'package:chat/models/userDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/chat_users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  List<ChatUsers>chatUsers=[
  // ChatUsers(text: 'Apnaa', secondarytext: 'Kul mil Kai baat karty', image: "images/userImage8.jpg", time:"Feb 24"),
  //    ChatUsers(text: 'Raheel', secondarytext: 'Pani wala aya tha?', image: 'images/userImage4.jpg', time:' Jan 2'),
  //    ChatUsers(text: 'Qaseem', secondarytext: 'Kahan ho?', image: 'images/userImage5.jpg', time:' Feb 28'),
  //    ChatUsers(text: 'khattak', secondarytext: 'Ye khusra hai penchod', image: 'images/userImage2.jpg', time:' Feb 24'),
  //    ChatUsers(text: 'Faraz', secondarytext: 'Chamber', image: 'images/userImage3.jpg', time:' Feb 24'),
  //    ChatUsers(text: 'Ilhan', secondarytext: 'Phr kya socha?', image: 'images/userImage1.jpg', time:' Feb 24'),
  //    ChatUsers(text: 'wahab', secondarytext: 'Ok beeroo', image: 'images/userImage6.jpg', time:' Feb 24'),
  //    ChatUsers(text: 'Ammar', secondarytext: 'Quiz hogaya?', image: 'images/userImage7.jpg', time:' Feb 24'),
  //  ];

  getUserList(List<String> usersList, List<String> msgs) async {
    print(usersList);
    print(msgs);
    for (int i = 0; i < usersList.length; i++) {
      await Provider.of<ChatModel>(context, listen: false).getFriendsData(
          usersList[i], msgs[i]);
    }
    Provider.of<ChatModel>(context, listen: false).setloader(false);
    print('chl rha hai');
    print(Provider.of<ChatModel>(context, listen: false).loader);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChatModel>(context, listen: false).clearList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<ChatModel>(context, listen: false).clearList();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddFriends()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 30,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            'New',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
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
            Container(
              height: height * 0.755,
              child: StreamBuilder(
                stream: _firestore.collection('user').doc(Provider
                    .of<UserDetails>(context, listen: false)
                    .getUserDocID).collection('friends').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
                    );
                  }

                  List<String> docIds = [];
                  List<String> msgIds=[];
                  final data = snapshot.data.docs;
                  for (var frnds in data) {
                    docIds.add(frnds.data()['userDocId']);
                    msgIds.add(frnds.data()['messageDocId']);
                  }
                  getUserList(docIds, msgIds);
                  print(Provider.of<ChatModel>(context,listen: false).userMessages);

                  return Consumer<ChatModel>(
                      builder: (context, data, child) {
                        return !data.loader ?
                        ListView.builder(
                            itemCount: data.userMessages.length,
                            itemBuilder: (context, i) {
                              return data.userMessages.isEmpty?Text('You have no chats available.'):ChatUsersList(
                                msgDocId: data.userMessages[i].docId,
                                  text: data.userMessages[i].text,
                                  secondarytext: data.userMessages[i]
                                      .secondarytext,
                                  image: data.userMessages[i].image,
                                  time: data.userMessages[i].time);
                            }
                        ):Center(
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
                            ),
                          ),
                        );
                      }
                      );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
