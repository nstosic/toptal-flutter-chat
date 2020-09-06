import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:toptal_chat/util/constants.dart';
import 'package:toptal_chat/model/login_response.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/firebase_repo.dart';
import 'package:toptal_chat/model/user_repo.dart';

class LoginRepo {
  static LoginRepo _instance;
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore;

  LoginRepo._internal(this._firestore);

  factory LoginRepo.getInstance() {
    if (_instance == null) {
      _instance = LoginRepo._internal(FirebaseRepo.getInstance().firestore);
    }
    return _instance;
  }

  Future<LoginResponse> _signIn(firebase.AuthCredential credentials) async {
    final authResult = await _auth.signInWithCredential(credentials);
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      final token = await UserRepo.getInstance().getFCMToken();
      User serializedUser = User(
        user.uid,
        user.displayName,
        user.photoURL,
        token,
      );
      await _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(user.uid)
          .set(serializedUser.map, SetOptions(merge: true));
      return User(
        user.uid,
        user.displayName,
        user.photoURL,
        token,
      );
    } else {
      return LoginFailedResponse(ErrorMessages.NO_USER_FOUND);
    }
  }

  Future<bool> _signOut() async {
    return _auth.signOut().catchError((error) {
      print("LoginRepo::logOut() encountered an error:\n${error.error}");
      return false;
    }).then((value) {
      return true;
    });
  }

  Future<LoginResponse> signInWithGoogle(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    final credentials = firebase.GoogleAuthProvider.credential(
        idToken: authentication.idToken, accessToken: authentication.accessToken);
    return _signIn(credentials);
  }

  Future<LoginResponse> signInWithFacebook(LoginResult result) async {
    final credentials = firebase.FacebookAuthProvider.credential(result.accessToken.token);
    return _signIn(credentials);
  }

  Future<bool> signOut() async {
    return _signOut();
  }
}
