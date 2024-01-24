import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found/models/current_user.dart';
import 'package:lost_and_found/screens/homepage/home_page.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //CurrentUser model to Store the UID
  CurrentUser? _currentUserFromFirebase(User user) {
    return user != null ? CurrentUser(currentUserUid: user.uid) : null;
  }

  //result has the value of the Signed in user and it is returned to the Current user Model
  Future signInUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _currentUserFromFirebase(user!);
    } catch (e) {
      print("Sign In Error: $e");
    }
  }

  //GOOGLE SignIn Method
  Future<void> signInUserWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await _auth.signInWithCredential(credential);

    User user = result.user!;

    await _firestore.collection("users").doc(user.uid).set({
      "fullName": user.displayName,
      "phoneNo": user.phoneNumber,
      "emailAddress": user.email,
      "UID": user.uid,
    });

    if (result == null) {
      print("NO USER");
    } else {
      _currentUserFromFirebase(user);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  //RESET PASSWORD
  Future forgotPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Forgot Password: $e");
    }
  }

  Future<CurrentUser?> createUserWithEmailAndPassword(
      String email, String password, String fullName, String phoneNo) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await _firestore.collection("users").doc(user.uid).set({
        "fullName": fullName,
        "phoneNo": phoneNo,
        "emailAddress": email,
        "UID": user.uid,
        "profilePhoto": "",
      });
      return _currentUserFromFirebase(user);
    } catch (e) {
      print("New User: $e");
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Sign Out: $e");
    }
  }
}
