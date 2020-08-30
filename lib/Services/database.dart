import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  getUserByUserName(String username)async{
   return await Firestore.instance.collection('users').where('name', isEqualTo: username ).getDocuments();
  }
  getUserByEmail(String email)async{
    return await Firestore.instance.collection('users').where('email', isEqualTo: email ).getDocuments();
  }
  uploadUserInfo(userMap){
    Firestore.instance.collection('users').add(userMap).catchError((e){
      print(e.toString());
    });
  }
  createChatRoom(String chatRoomId,chatRoomMap){
    Firestore.instance.collection("ChatRoom").document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  getConversationMessages({String chatRoomId,messageMap}){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).collection('chats').add(messageMap).catchError((e){
          print(e.toString());
    });
  }
  retrieveConversationMessages(String chatRoomId)async{
    return Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).collection('chats').orderBy('time',descending: false)
        .snapshots();
  }
  getChatRoom(String userName)async{
    return Firestore.instance.collection('ChatRoom')
.where('users',arrayContains: userName).snapshots();
  }
}