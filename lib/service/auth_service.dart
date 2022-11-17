import 'package:chat_app_groupie/helper/helper_functions.dart';
import 'package:chat_app_groupie/service/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //*login
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //*register
  Future registerUserWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //call db to update user data
      await DbService(uid: user.uid).updateUser(
        fullName: fullName,
        email: email,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //*signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(isUserLoggedIn: false);
      await HelperFunctions.saveUserEmailSharedRef(email: "");
      await HelperFunctions.saveUserFullNameSharedRef(fullName: "");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
