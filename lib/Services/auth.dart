
import 'package:chatting_app/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
   final FirebaseAuth _auth = FirebaseAuth.instance;
   User  _userFromFirebase(FirebaseUser user){
      return user != null ? User(userId: user.uid):null;
   }
   Future signInWithEmailAndPassword(String email,String pass)async{
      try{
         AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
         FirebaseUser firebaseUser =result.user;
         return _userFromFirebase(firebaseUser);
      }catch(e)
      {
            print(e);
      }
   }
   Future signUpWithEmailAndPassword(String email,String pass)async{
      try{
         AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
         FirebaseUser firebaseUser =result.user;
         return _userFromFirebase(firebaseUser);
      }catch(e){
         print(e);
      }
   }
   Future resetPassword(String email)async{
      try{
         return await _auth.sendPasswordResetEmail(email: email);
      }catch(e){
         print(e);
      }
   }
   Future signOut() async{
      try{
         return await _auth.signOut();
      }catch(e){
         print(e);
      }
   }
}

