import 'package:chatting_app/Components/app_bar.dart';
import 'package:chatting_app/Screens/conversation.dart';
import 'package:chatting_app/Services/database.dart';
import 'package:chatting_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Widget searchList() {
    return searchSnapshot == null
        ? Container()
        : ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.documents[index].data['name'],
                userEmail: searchSnapshot.documents[index].data['email'],
              );
            },
          );
  }

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUserName(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
      print('here ${searchSnapshot.documents[0].data['name']}');
    });
  }

  //create chatroom,sen user to conversation screen ,pushreplacement
  createChatroomAndStartConverstion(String userName) {
    if(userName == Constants.myName){
      print('you cant chat with u');
      return;
    }
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Conversation(chatRoomId: chatRoomId,)));
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: kSimpleTextStyle.copyWith(fontSize: 18)),
              Text(
                userEmail,
                style: kSimpleTextStyle.copyWith(fontSize: 18),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConverstion(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Message'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(this.context, 'Search'),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    enableSuggestions: false,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "search username",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        child: Icon(
                          Icons.search,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
