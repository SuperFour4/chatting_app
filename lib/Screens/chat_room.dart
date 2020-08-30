import 'package:chatting_app/Helper/authenticate.dart';
import 'package:chatting_app/Helper/helper_functions.dart';
import 'package:chatting_app/Screens/conversation.dart';
import 'package:chatting_app/Screens/search.dart';
import 'package:chatting_app/Services/auth.dart';
import 'package:chatting_app/Services/database.dart';
import 'package:chatting_app/constants.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods objAuth = AuthMethods();
  DatabaseMethods databaseMethods=DatabaseMethods();
  Stream chatRoomStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream:chatRoomStream,
      builder:(context,snapshot){
        return snapshot.hasData?ListView.builder(
          itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
            return ChatRoomTile(userName: snapshot.data.documents[index].data['chatroomId']
              .toString().replaceAll("_", "").replaceAll(Constants.myName, ''),
            chatRoomId: snapshot.data.documents[index].data['chatroomId'],);
            }
        ):Container();
      }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    databaseMethods.getChatRoom(Constants.myName).then((val){
setState(() {
  chatRoomStream=val;
});
    });
    super.initState();
  }
  getUserInfo() async{
      Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text(
              'CHAT ROOM',
              style: TextStyle(
                  letterSpacing: 1.3,
                  fontFamily: 'Dancing',
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  objAuth.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Authenticate()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 30),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Search()));        },
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.search,color: Colors.white,
            ),
          ),
          body: chatRoomList(),
       
      
    );
  }
}
 class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomTile({Key key, this.userName,this.chatRoomId}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
       child: GestureDetector(
         onTap:(){
           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Conversation(chatRoomId: chatRoomId,)));
         },
         child: Container(
           child: Row(
             children: <Widget>[
               Container(
                 width: 50,
                 height: 50,
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   borderRadius: BorderRadius.circular(25),
                 ),
                 child: Align(
                     alignment: Alignment.center,
                     child: Text('${userName.substring(0,1).toUpperCase()}',style: kSimpleTextStyle,)),
               ),
               SizedBox(width: 8,),
               Text(userName,style: kSimpleTextStyle,),
             ],
           ),
         ),
       ),
     );
   }
 }
