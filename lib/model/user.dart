import 'login_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends LoginResponse {
  final String uid;
  final String displayName;
  final String photoUrl;

  User(this.uid, this.displayName, this.photoUrl);

  User.fromFirebaseUser(FirebaseUser firebaseUser) : this(firebaseUser.uid, firebaseUser.displayName, firebaseUser.photoUrl);

  Map<String, dynamic> get map {
    return {
      "uid": uid,
      "displayName": displayName,
      "photoUrl": photoUrl
    };
  }
}