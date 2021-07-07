import 'package:chatting_app/Helper/authenticate.dart';
import 'package:chatting_app/Helper/helper_functions.dart';
import 'package:chatting_app/Screens/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState

    //getLoggedInState();
    screenShotDisable();
    super.initState();
  }
  screenShotDisable() async {
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_SECURE);
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(primaryColor: Colors.blue),
      home: userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}

class IamBlank extends StatefulWidget {
  @override
  _IamBlankState createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
