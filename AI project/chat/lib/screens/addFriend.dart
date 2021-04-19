import 'package:chat/components/alertBoxes.dart';
import 'package:chat/controller/requestsController.dart';
import 'package:chat/models/userDetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController userName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Add Friend',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: userName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
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
                  SizedBox(
                    height: 20.0,
                  ),
                  userName.text.isEmpty
                      ? Text(
                          'No users.',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black26),
                        )
                      : StreamBuilder(
                          stream: _firestore
                              .collection('user')
                              .where('name', isEqualTo: userName.text)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal));
                            }
                            List<UserRequestTile> users = [];
                            final data = snapshot.data.docs;
                            for (var us in data) {
                              users.add(UserRequestTile(
                                  us.data()['name'], us.id, ''));
                            }

                            return users.isNotEmpty
                                ? Column(
                                    children: users,
                                  )
                                : Text(
                                    'No user Found. Try correcting username',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.black26),
                                  );
                          })
                ],
              ),
            ),
          ),
        ));
  }
}

class UserRequestTile extends StatefulWidget {
  String uid, name, imgUrl;
  UserRequestTile(this.name, this.uid, this.imgUrl);
  @override
  _UserRequestTileState createState() => _UserRequestTileState();
}

class _UserRequestTileState extends State<UserRequestTile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('images/profile.jpg'),
        radius: 35.0,
      ),
      title: Text(
        widget.name,
        style: TextStyle(
            color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
          onPressed: () async {
            AlertBoxes _alert = AlertBoxes();
            _alert.loadingAlertBox(context);
            Requests req = Requests();
            String check = await req.sendRequest(
                Provider.of<UserDetails>(context, listen: false).getUserDocID,
                widget.uid);
            print('printing check => $check');
            if (check == 'sent') {
              Navigator.pop(context);
              setState(() {
                sent = true;
              });
            } else if (check == 'already') {
              Navigator.pop(context);
              print('already');
              _alert.simpleAlertBox(context, 'Failed to send Request',
                  'User already is your friend.');
            } else {
              Navigator.pop(context);
              print('failed');
              _alert.simpleAlertBox(context, 'Failed to send Request',
                  'Something went wrong. Please try again later.');
            }
          },
          icon: !sent
              ? CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.add,
                    size: 16.0,
                    color: Colors.white,
                  ),
                )
              : CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.check,
                    size: 16.0,
                    color: Colors.white,
                  ),
                )),
    );
  }
}
