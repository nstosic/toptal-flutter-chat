import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'package:toptal_chat/model/login_response.dart';

class User extends LoginResponse {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String fcmToken;

  User(this.uid, this.displayName, this.photoUrl, this.fcmToken);

  User.fromFirebaseUser(firebase.User firebaseUser)
      : this(
          firebaseUser.uid,
          firebaseUser.displayName,
          firebaseUser.photoURL,
          "",
        );

  Map<String, dynamic> get map {
    return {"uid": uid, "displayName": displayName, "photoUrl": photoUrl, "fcmToken": fcmToken};
  }
}
