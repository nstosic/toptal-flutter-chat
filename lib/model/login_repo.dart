import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../util/constants.dart';
import 'login_response.dart';
import 'user.dart';
import 'firebase_repo.dart';
import 'user_repo.dart';

class LoginRepo {
  static LoginRepo _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore;

  LoginRepo._internal(this._firestore);

  factory LoginRepo.getInstance() {
    if (_instance == null) {
      _instance = LoginRepo._internal(FirebaseRepo.getInstance().firestore);
    }
    return _instance;
  }

  Future<LoginResponse> _signIn(AuthCredential credentials) async {
    final authResult = await _auth.signInWithCredential(credentials);
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      final token = await UserRepo.getInstance().getFCMToken();
      User serializedUser = User(user.uid, user.displayName, user.photoUrl, token);
      await _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .document(user.uid)
          .setData(serializedUser.map, merge: true);
      return User(user.uid, user.displayName, user.photoUrl, token);
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
    final credentials = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    return _signIn(credentials);
  }

  Future<LoginResponse> signInWithFacebook(FacebookLoginResult result) async {
    final credentials = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);
    return _signIn(credentials);
  }

  Future<bool> signOut() async {
    return _signOut();
  }
}
