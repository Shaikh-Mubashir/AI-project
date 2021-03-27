import 'package:chat/components/chat.dart';
import 'package:flutter/material.dart';

import 'models/chat_users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUsers>chatUsers=[
 ChatUsers(text: 'Apnaa', secondarytext: 'Kul mil Kai baat karty', image: "images/userImage8.jpg", time:"Feb 24"),
    ChatUsers(text: 'Raheel', secondarytext: 'Pani wala aya tha?', image: 'images/userImage4.jpg', time:' Jan 2'),
    ChatUsers(text: 'Qaseem', secondarytext: 'Kahan ho?', image: 'images/userImage5.jpg', time:' Feb 28'),
    ChatUsers(text: 'khattak', secondarytext: 'Ye khusra hai penchod', image: 'images/userImage2.jpg', time:' Feb 24'),
    ChatUsers(text: 'Faraz', secondarytext: 'Chamber', image: 'images/userImage3.jpg', time:' Feb 24'),
    ChatUsers(text: 'Ilhan', secondarytext: 'Phr kya socha?', image: 'images/userImage1.jpg', time:' Feb 24'),
    ChatUsers(text: 'wahab', secondarytext: 'Ok beeroo', image: 'images/userImage6.jpg', time:' Feb 24'),
    ChatUsers(text: 'Ammar', secondarytext: 'Quiz hogaya?', image: 'images/userImage7.jpg', time:' Feb 24'),


  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
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
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
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
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ChatUsersList(text: chatUsers[index].text,
                    secondarytext: chatUsers[index].secondarytext,
                    image: chatUsers[index].image,
                    time: chatUsers[index].time);
              },
            )
          ],
        )),
      ),
    );
  }
}
