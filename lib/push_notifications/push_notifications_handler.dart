import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../model/user_repo.dart';
import '../model/chat_repo.dart';
import '../model/user.dart';
import '../navigation_helper.dart';

class PushNotificationsHandler {
  BuildContext context;

  PushNotificationsHandler(this.context);

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void setup() {
    if (Platform.isIOS) {
      _requestPermissionOniOS();
    } else if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("Incoming notification message:");
        print(message);
      },
      onResume: (Map<String, dynamic> message) {
        _handleIncomingNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        _handleIncomingNotification(message);
      }
    );
  }

  void _requestPermissionOniOS() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      if (settings.alert) {
        _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
      }
    });
  }

  void _handleIncomingNotification(Map<String, dynamic> payload) async {
    Map<String, dynamic> userMap = payload["other_member_id"];
    User otherUser = User(userMap["uid"], userMap["displayName"], userMap["photoUrl"], userMap["fcmToken"]);
    User currentUser = await UserRepo.getInstance().getCurrentUser();
    if (currentUser == null) {
      return;
    }
    ChatRepo.getInstance()
        .getChatroom(payload["tag"], currentUser, otherUser)
        .then((chatroom) {
          NavigationHelper.navigateToInstantMessaging(context, otherUser.displayName, chatroom.id);
        });
  }
}