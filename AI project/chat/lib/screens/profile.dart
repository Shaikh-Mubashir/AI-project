import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/userDetail.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController username = TextEditingController(text: 'Shaikh');
  String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = username.text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(child: Consumer<UserDetails>(
        builder: (context, data, child) {
          return Container(
            child: Center(
              child: Container(
                height: 390.0,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                          elevation: 10,
                          child: Container(
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.getUserName,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        //showAlertDialog(context, username);
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 31.0,
                                      width: 300,
                                      child: Divider(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      data.getEmail,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 270.0),
                      child: Center(
                        child: Container(
                          width: 110.0,
                          height: 120.0,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                  radius: 55.0,
                                  backgroundImage:
                                      NetworkImage(data.getImageUrl)
                                  //  backgroundColor: Colors.white,

                                  ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
