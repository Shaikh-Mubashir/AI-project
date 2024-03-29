import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:chat/Services/ascii.dart';
import 'package:chat/Services/s-desServices.dart';
import 'package:chat/components/alertBoxes.dart';
import 'package:chat/screens/mainPage.dart';
import 'package:chat/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../controller/createUser.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  CreateUser _createUser;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<bool> onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text(
                'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // this line exits the app.
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('images/pic.png'),
                    height: 300,
                    width: 480,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: MultiValidator([
                        RequiredValidator(errorText: '* Required Field'),
                        EmailValidator(errorText: '* Email Badly Formatted')
                      ]),
                      controller: _username,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.yellow),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      obscureText: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: '* Required Field'),
                        LengthRangeValidator(
                            min: 8,
                            max: 10,
                            errorText:
                                'Your Password should be in the range of 8-10')
                      ]),
                      controller: _password,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.keyboard_hide),
                        suffix: Icon(Icons.remove_red_eye),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  TextButton(
                      onPressed: () {
                        String s = "ilhan";
                        SDESServices enc = SDESServices();
                        //Generating random key
                        Random rand = Random();
                        int j = rand.nextInt(s.length);
                        String key = s.codeUnitAt(j).toRadixString(2);
                        key = "0" + key + "10";
                        print("MY KEY:- $key");
                        List<String> keyValues = enc.keyGeneration(key);
                        print("K1:- ${keyValues[0]}");
                        print("K2:- ${keyValues[1]}");
                        List<String> CT =
                            enc.sDesEncryption(s, keyValues[0], keyValues[1]);
                        print(CT);
                        List<int> list = [];
                        String res = "";
                        CT.forEach((element) {
                          // list.add(int.parse(element, radix: 2));
                          res = res + myAscii[element];
                        });
                        //print(list);
                        //print(utf8.decode(list, allowMalformed: true));
                        print(res);
                        print(
                            "======================================================");
                        List<String> PT =
                            enc.sDesDecryption(res, keyValues[0], keyValues[1]);
                        print(PT);
                        List<int> list2 = [];
                        String res2 = "";
                        PT.forEach((element) {
                          // list.add(int.parse(element, radix: 2));
                          res2 = res2 + myAscii[element];
                        });
                        //print(list);
                        //print(utf8.decode(list, allowMalformed: true));
                        print(res2);
                      },
                      child: Text("Encrypt")),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      AlertBoxes _alert = AlertBoxes();
                      if (_key.currentState.validate()) {
                        // try {
                        _createUser = CreateUser();
                        //progress.showWithText('Loading...');
                        _alert.loadingAlertBox(context);
                        await _createUser
                            .logInUser(context, _username.text, _password.text)
                            .then((check) {
                          print('At log in screen =>?$check');
                          if (check) {
                            Navigator.pop(context);
                            print('printing => $check');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            _alert.simpleAlertBox(context, 'Failed to Log in.',
                                'Wrong user email or password.');
                            print('nhi chl rha');
                          }
                        });
                        // } catch (e) {
                        // _alert.simpleAlertBox(context, 'Failed to Log in.',
                        //     'Something went wrong.');
                        // }
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      'I do not have an Account?Sign Up',
                      style: TextStyle(color: Colors.black45),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
