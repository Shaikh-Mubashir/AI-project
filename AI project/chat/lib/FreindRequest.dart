import 'package:chat/components/alertBoxes.dart';
import 'package:chat/home.dart';
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
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Friend Requests',style: TextStyle(
          color: Colors.black,

        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(

         child: StreamBuilder(
           stream: _firestore.collection('user').doc(Provider.of<UserDetails>(context,listen: false).getUserDocID).collection('requests').snapshots(),
         builder: (context,snapshot){
           if(snapshot.hasError)
           {
             return Center(
               child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
               ),
             );
           }
           if(snapshot.connectionState==ConnectionState.waiting)
           {
             return Center(
               child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
               ),
             );
           }
             List<RequestTile>requestAccept=[];
             final data=snapshot.data.docs;
             String uid;
             for(var usid in data){
              uid=usid.data()['userDocId'];
              requestAccept.add(RequestTile(uid: uid,reqUid: usid.id,));
             }
             return Column(
               children: requestAccept,
             );
         },
         )
        ),
      ),
    );
  }
}

class RequestTile extends StatefulWidget {
String uid,reqUid;
RequestTile({this.uid,this.reqUid});
  @override
  _RequestTileState createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  String name,imgUrl;
  bool loaded= false;
  getUserData()async{
    final userData= await _firestore.collection('user').doc(widget.uid).get();
   name=userData.data()['name'];
   setState(() {
     loaded=true;
   });
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded? Padding(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('images/profile.jpg'),
            radius: 30,
          ),
          SizedBox(width: 5.0,),
          Text(name??' ',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),),
          SizedBox(width: 45,),
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
          SizedBox(width: 16,),

          RaisedButton(
            textColor: Colors.white,
            color: Colors.teal,
            child: Text('Accept',),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)
            ),
            onPressed: ()async{
              AlertBoxes _alert=AlertBoxes();
              // _alert.loadingAlertBox(context);
              try {
                await _firestore.collection('user').doc(Provider
                    .of<UserDetails>(context, listen: false)
                    .getUserDocID).collection('requests')
                    .doc(widget.reqUid)
                    .delete();

                final msgDocId = _firestore.collection('messages').doc();
                msgDocId.set({
                  'dateTime': DateTime.now().toString()
                });
                await _firestore.collection('user').doc(Provider
                    .of<UserDetails>(context, listen: false)
                    .getUserDocID).collection('friends').doc().set({
                  'userDocId': widget.uid,
                  'messageDocId': msgDocId.id
                });
                await _firestore.collection('user').doc(widget.uid).collection(
                    'friends').doc().set({
                  'userDocId': Provider
                      .of<UserDetails>(context, listen: false)
                      .getUserDocID,
                  'messageDocId': msgDocId.id
                });
                // Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HomeScreen()));
                print('ho gya kaam');
              }
              catch(e){
                print(e);
              }
            },
          )
        ],
      ),
    ):Padding(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 12.0),
      child: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
      )),
    );
  }
}

