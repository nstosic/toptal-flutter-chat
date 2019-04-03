import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';
import '../util/constants.dart';

class UserRepo {
  static UserRepo _instance;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    String userDisplayName = prefs.getString(StorageKeys.USER_DISPLAY_NAME_KEY);
    String userPhotoUrl = prefs.getString(StorageKeys.USER_PHOTO_URL_KEY);
    String fcmToken = prefs.getString(StorageKeys.FCM_TOKEN);
    if (userId != null && userDisplayName != null && userPhotoUrl != null) {
      return User(userId, userDisplayName, userPhotoUrl, fcmToken);
    }
    return null;
  }

  void setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.fcmToken.isEmpty ? prefs.getString(StorageKeys.FCM_TOKEN) : user.fcmToken;
    await prefs.setString(StorageKeys.USER_ID_KEY, user.uid)
        .then((value) => prefs.setString(StorageKeys.USER_DISPLAY_NAME_KEY, user.displayName))
        .then((value) => prefs.setString(StorageKeys.USER_PHOTO_URL_KEY, user.photoUrl))
        .then((value) => prefs.setString(StorageKeys.FCM_TOKEN, token));
  }

  void clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.FCM_TOKEN);
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
