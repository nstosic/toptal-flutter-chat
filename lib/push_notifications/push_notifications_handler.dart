import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:toptal_chat/model/user_repo.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/model/user.dart';
import 'package:toptal_chat/instant_messaging/instant_messaging_view.dart';

class PushNotificationsHandler extends NavigatorObserver {
  PushNotificationsHandler() {
    _setup();
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _setup() {
    if (Platform.isIOS) {
      _requestPermissionOniOS();
    } else if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
    }

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("Incoming notification message:");
      print(message);
      return Future.microtask(() => true);
    }, onResume: (Map<String, dynamic> message) {
      return _handleIncomingNotification(message);
    }, onLaunch: (Map<String, dynamic> message) {
      return _handleIncomingNotification(message);
    });
  }

  void _requestPermissionOniOS() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      if (settings.alert) {
        _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
      }
    });
  }

  Future<bool> _handleIncomingNotification(Map<String, dynamic> payload) async {
    Map<dynamic, dynamic> data = payload["data"];
    User otherUser = User(data["other_member_id"], data["other_member_name"], data["other_member_photo_url"], "");
    User currentUser = await UserRepo.getInstance().getCurrentUser();
    if (currentUser == null) {
      return false;
    }
    ChatRepo.getInstance()
        .getChatroom(
      data["chatroom_id"],
      currentUser,
      otherUser,
    )
        .then(
      (chatroom) {
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => InstantMessagingScreen(
                      displayName: chatroom.displayName,
                      chatroomId: chatroom.id,
                    )),
            (Route<dynamic> route) => route.isFirst);
        return true;
      },
    );
    return false;
  }
}
