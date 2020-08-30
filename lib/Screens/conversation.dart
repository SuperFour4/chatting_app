import 'package:chatting_app/Components/app_bar.dart';
import 'package:chatting_app/Services/database.dart';
import 'package:chatting_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;

  const Conversation({Key key, this.chatRoomId}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Stream chatMessageStream;
  TextEditingController messageController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Widget chatMessgeLive() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data['message'],
                      snapshot.data.documents[index].data['sendBy'] ==
                          Constants.myName);
                })
            : Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.getConversationMessages(
          chatRoomId: widget.chatRoomId, messageMap: messageMap);
    }
    messageController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.retrieveConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(this.context, "Messages"),
      body: Stack(
        children: <Widget>[
          chatMessgeLive(),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    enableSuggestions: false,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "type message",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
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
                          Icons.send,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16) ,
          decoration: BoxDecoration(
            borderRadius: isSendByMe?BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ):
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            ),
          ),

          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
