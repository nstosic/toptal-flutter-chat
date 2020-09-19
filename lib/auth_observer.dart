import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/model/user_repo.dart';
import 'package:toptal_chat/navigation_helper.dart';

class AuthObserver extends NavigatorObserver {
  AuthObserver() {
    _setup();
  }

  StreamSubscription<firebase.User> _authStateListener;

  Future<void> _setup() async {
    await Firebase.initializeApp();
    if (_authStateListener == null) {
      _authStateListener = firebase.FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          final loginProvider = user.providerData.first.providerId;
          UserRepo.getInstance().setCurrentUser(User.fromFirebaseUser(user));
          if (loginProvider == "google") {
            // TODO analytics call for google login provider
          } else {
            // TODO analytics call for facebook login provider
          }
          NavigationHelper.navigateToMain(navigator.context, removeUntil: (_) => false);
        } else {
          NavigationHelper.navigateToLogin(navigator.context, removeUntil: (_) => false);
        }
      }, onError: (error) {
        NavigationHelper.navigateToLogin(navigator.context, removeUntil: (_) => false);
      });
    }
  }

  void close() {
    _authStateListener?.cancel();
  }
}
