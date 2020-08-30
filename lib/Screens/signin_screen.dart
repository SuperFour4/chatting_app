import 'package:chatting_app/Components/app_bar.dart';
import 'package:chatting_app/Components/button.dart';
import 'package:chatting_app/Helper/helper_functions.dart';
import 'package:chatting_app/Services/auth.dart';
import 'package:chatting_app/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/constants.dart';
import 'package:chatting_app/Components/text_field.dart';

import 'chat_room.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  DatabaseMethods databaseMethods = DatabaseMethods();

  signMe() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailInSharedPreference(emailController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByEmail(emailController.text).then((val) {
        setState(() {
          snapshotUserInfo = val;
        });
        HelperFunctions.saveUserNameInSharedPreference(
            snapshotUserInfo.documents[0].data['name']);

        HelperFunctions.saveUserEmailInSharedPreference(
            snapshotUserInfo.documents[0].data['email']);
      });
      try {
        authMethods
            .signInWithEmailAndPassword(
            emailController.text, passwordController.text)
            .then((value) {
          if (value != null) {
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => ChatRoom()));
          }
          else{
            setState(() {
              isLoading=false;
            });
          }
        });
      } catch (e) {
        print('her error found');
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, 'VNR CHATIING APP'),
        body: SingleChildScrollView(
          child: isLoading == true
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              InputTextField(
                                hintString: 'email',
                                controller: emailController,
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : 'please provide valid email id';
                                },
                              ),
                              InputTextField(
                                hintString: 'password',
                                controller: passwordController,
                                obsecure: true,
                                validator: (val) {
                                  String value = val.toString();
                                  return value.length > 6
                                      ? null
                                      : 'please provide password greater than 6 char';
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forgot Password?',
                            style: kSimpleTextStyle.copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Button(
                          buttonText: 'Sign In',
                          indicator: true,
                          onTap: () {
                            signMe();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Button(
                          buttonText: 'Sign In With Google',
                          indicator: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account?"),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.toggle();
                                });
                              },
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
