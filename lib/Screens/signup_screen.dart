import 'package:chatting_app/Components/button.dart';
import 'package:chatting_app/Components/text_field.dart';
import 'package:chatting_app/Helper/helper_functions.dart';
import 'package:chatting_app/Services/auth.dart';
import 'package:chatting_app/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/Components/app_bar.dart';

import '../constants.dart';
import 'chat_room.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  AuthMethods objAuth = AuthMethods();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMe() {
    if (formKey.currentState.validate()) {
      Map<String,String> userMap={
        'email': emailController.text,
        'name': userNameController.text,
      };

      HelperFunctions.saveUserEmailInSharedPreference(emailController.text);
      HelperFunctions.saveUserNameInSharedPreference(userNameController.text);
      setState(() {
        isLoading = true;
      });
      objAuth
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        print("${value.uid}");
      });
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      databaseMethods.uploadUserInfo(userMap);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, 'VNR SIGN UP PAGE'),
        body: isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
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
                                hintString: 'username',
                                controller: userNameController,
                                validator: (value) {
                                  String valueTemp = value.toString();
                                  return valueTemp.isEmpty ||
                                          valueTemp.length < 2
                                      ? "Please provide valid user name"
                                      : null;
                                },
                              ),
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
                                obsecure: true,
                                controller: passwordController,
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
                          buttonText: 'Sign Up',
                          indicator: true,
                          onTap: () {
                            //TODO
                            signMe();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Button(
                          buttonText: 'Sign Up With Google',
                          indicator: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account?"),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: (){
                                widget.toggle();
                              },
                              child: Text(
                                "Sign In now",
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
