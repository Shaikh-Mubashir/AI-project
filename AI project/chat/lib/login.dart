import 'package:chat/mainPage.dart';
import 'package:chat/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'controller/createUser.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username =TextEditingController();
  TextEditingController _password =TextEditingController();
  CreateUser _createUser;
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context)=>SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Image(image: AssetImage(
                        'images/pic.png'
                    ),
                      height: 300,width: 480,),
                    SizedBox(height: 30,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
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
                            borderRadius: BorderRadius.circular(20 ),

                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required Field'),
                        //  RangeValidator(min: 8, max: 12, errorText: '* Password should be in the range of 8-12')
                        ]),
                        controller: _password,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.keyboard_hide),
                          suffix: Icon(Icons.remove_red_eye),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70,),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                      child: Text('Log In',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      onPressed: ()async{
                        final progress=ProgressHUD.of(context);
                        if(_key.currentState.validate()){
                          _createUser =CreateUser();
                          progress.showWithText('Loading...');
                          bool check = await _createUser.logInUser(context, _username.text, _password.text);
                          if(check==true)
                          {
                            progress.dismiss();
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                          }
                          else{
                            print('nhi chl rha');
                            progress.dismiss();
                          }
                        }

                      },
                    ),
                    TextButton(
                      child: Text('I do not have an Account?Sign Up',
                        style: TextStyle(
                            color: Colors.black45
                        ),),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
