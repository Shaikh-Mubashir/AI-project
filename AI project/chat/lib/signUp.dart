import 'package:chat/controller/createUser.dart';
import 'package:chat/login.dart';
import 'package:chat/models/userDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cpassword = TextEditingController();
  CreateUser _createUser;
  AlertState _alertBoxes;
  GlobalKey<FormState> _key= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Register Your Self'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)=>SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('images/profile.jpg'),
                        radius: 65,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required Field`')
                        ]),
                        controller: _username,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.keyboard_hide),
                          hintText: 'Username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required Field'),
                          EmailValidator(errorText: '* Email badly formatted')
                        ]),
                        controller: _email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(

                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required Field'),
                         // RangeValidator(min: 8, max: 10, errorText: '* Password should be in the range of 8-10')
                        ]),
                        controller: _password,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.keyboard_hide),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _cpassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.keyboard_hide),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {
                          if(_key.currentState.validate())
                          print('aa rha ai');
                          {final progress = ProgressHUD.of(context);
                            try {
                              _createUser = CreateUser();
                              progress.showWithText('Loading...');
                              bool check = await _createUser.registerUser(
                                  _username.text, _email.text, _password.text);
                              if (check == true) {
                                print('aaa');
                                progress.dismiss();

                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                              else {
                                progress.dismiss();
                                print('Nhi chla kaam');
                               _alertBoxes= AlertState();
                                ///alert box lgaana
                              }
                            }
                            catch(e){
                              progress.dismiss();
                              ///alert box lgaana

                            }
                            //Provider.of<UserDetails>(context,listen: false).setUserDetails(name: _username.text,email: _email.text,password: _password.text);
                          }

                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
class AlertState extends State {

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Alert Message Title Text.'),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        RaisedButton(
          onPressed: () => showAlert(context),
          child: Text('Click Here To Show Alert Dialog Box'),
          textColor: Colors.white,
          color: Colors.green,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ),
    );
  }
}