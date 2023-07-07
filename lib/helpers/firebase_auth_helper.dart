import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_firestore.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //TODO : Sign In Anonymously
  Future<Map<String, dynamic>> SignInAnonymously() async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          res = {'error': 'Server Temporary Closed...'};
          break;
      }
    }

    return res;
  }

  //TODO :Sign Up With Email Password
  Future<Map<String, dynamic>> createUserWithEmailPassword(
      {required String? fullName,
      required String? email,
      required String? password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);

      User? user = userCredential.user;
      if (user != null) {
        await DatabaseServices(uid: user.uid).updateUserData(fullName!, email);
      }
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      print("-----------------------");
      print(e.code);
      print("-----------------------");
      switch (e.code) {
        case 'invalid-email':
          res = {'error': 'Invalid Email....'};
          break;
        case 'weak-password':
          res = {'error': 'Your Password is Weak....'};
          break;
        case 'operation-not-allowed':
          res = {'error': 'Server is temporary off....'};
          break;
        case 'email-already-in-use':
          res = {'error': 'Please select another email....'};
          break;
      }
    }
    return res;
  }

  //TODO:LogIn as a Existing user
  Future logInUser({required String? email, required String? password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential? userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);

      User? user = userCredential.user;
      res = {
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      print("-----------------------");
      print(e.code);
      print("-----------------------");
      switch (e.code) {
        case 'invalid-email':
          res = {'error': 'Invalid Email....'};
          break;
        case 'weak-password':
          res = {'error': 'Your Password is Weak....'};
          break;
        case 'operation-not-allowed':
          res = {'error': 'Server is temporary off....'};
          break;
        case 'email-already-in-use':
          res = {'error': 'Please select another email....'};
          break;
      }
    }
    return res;
  }

  //TODO: SignOut
  Future signOut() async {
    try {
      helperFunction.savedUserLoggedInStatus(false);
      helperFunction.savedUserName('');
      helperFunction.savedUserEmail('');
      await firebaseAuth.signOut();
    } catch (e) {}
  }
}
