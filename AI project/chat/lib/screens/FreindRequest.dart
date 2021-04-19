import 'package:chat/components/alertBoxes.dart';
import 'package:chat/controller/requestsController.dart';
import 'package:chat/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/userDetail.dart';

class FriendRequest extends StatefulWidget {
  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loaded = false;
  String name, imgUrl;
  String userDocId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: StreamBuilder(
        stream: _firestore
            .collection('user')
            .doc(Provider.of<UserDetails>(context, listen: false).getUserDocID)
            .collection('requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
            );
          }
          List<RequestTile> requestAccept = [];
          final data = snapshot.data.docs;
          String uid, name;
          for (var usid in data) {
            uid = usid.data()['userDocId'];
            requestAccept.add(RequestTile(
              uid: uid,
              reqUid: usid.id,
              superContext: context,
            ));
          }
          return requestAccept.isNotEmpty
              ? Column(
                  children: requestAccept,
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      'No Pending Requests.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.teal[200]),
                    ),
                  ),
                );
        },
      )),
    );
  }
}

class RequestTile extends StatefulWidget {
  String uid, reqUid;
  BuildContext superContext;
  RequestTile({this.uid, this.reqUid, this.superContext});
  @override
  _RequestTileState createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loaded = false;
  String name, imgUrl;
  String userDocId;
  getUserData() async {
    print("Receiveng at :n ${widget.uid}");
    final userData = await _firestore.collection('user').doc(widget.uid).get();
    if (userData != null) {
      setState(() {
        print(userData.exists);
        name = userData.data()['name'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.reqUid);
    getUserData();
    userDocId = Provider.of<UserDetails>(context, listen: false).getUserDocID;
    print(userDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('images/profile.jpg'),
            radius: 30,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            name ?? ' ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 45,
          ),
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              radius: 20,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          RaisedButton(
            textColor: Colors.white,
            color: Colors.teal,
            child: Text(
              'Accept',
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () async {
              AlertBoxes _alert = AlertBoxes();
              _alert.loadingAlertBox(context);
              Requests _req = Requests();
              bool check = await _req.acceptRequest(
                  context,
                  userDocId,
                  widget.uid,
                  widget.reqUid,
                  Provider.of<UserDetails>(context, listen: false).getUserName);
              if (check) {
                print(check);
                Navigator.pop(widget.superContext);
              }
            },
          )
        ],
      ),
    );
  }
}
