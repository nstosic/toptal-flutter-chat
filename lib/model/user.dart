import 'login_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends LoginResponse {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String fcmToken;

  User(this.uid, this.displayName, this.photoUrl, this.fcmToken);

  User.fromFirebaseUser(FirebaseUser firebaseUser) : this(firebaseUser.uid, firebaseUser.displayName, firebaseUser.photoUrl, "");

  Map<String, dynamic> get map {
    return {
      "uid": uid,
      "displayName": displayName,
      "photoUrl": photoUrl,
      "fcmToken": fcmToken
    };
  }
}