import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //*Add the userdata to cloud firestore
  Future<void> addUserInformation(userData) async {
    _firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(userData)
        .catchError((e) {
      print("[AddUserInfo] : $e");
    });
  }

  //*Fetch the user information from the firestore, where
  getUserInformation(String email) async {
    return _firebaseFirestore
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print("[getUserInfo] : $e");
    });
  }
}
