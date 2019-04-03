import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../model/user_repo.dart';

class PushNotificationsHandler {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void setup() {
    if (Platform.isIOS) {
      _requestPermissionOniOS();
    } else if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
    }


  }

  void _requestPermissionOniOS() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      if (settings.alert) {
        _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
      }
    });
  }
}