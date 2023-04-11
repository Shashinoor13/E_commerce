<<<<<<< HEAD
import 'package:app_1/models/userModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class fireBaseHelper {
static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
=======
import '/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {

  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }

}
>>>>>>> f1b81ee59923c1cb8b61b9e5437e391fb7bf4a2c
