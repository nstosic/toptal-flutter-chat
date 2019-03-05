import 'package:flutter/material.dart';

import 'login/login_view.dart';
import 'main/main_view.dart';
import 'create_chatroom/create_chatroom_view.dart';
import 'instant_messaging/instant_messaging_view.dart';

class NavigationHelper {

  static void navigateToLogin(
      BuildContext context,
      { bool addToBackStack: false }) {
    if (addToBackStack) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen())
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen())
      );
    }
  }

  static void navigateToMain(
      BuildContext context,
      { bool addToBackStack: false }) {
    if (addToBackStack) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    }
  }

  static void navigateToAddChat(
      BuildContext context,
      { bool addToBackStack: false }) {
    if (addToBackStack) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateChatroomScreen())
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateChatroomScreen())
      );
    }
  }

  static void navigateToInstantMessaging(
      BuildContext context,
      String displayName,
      String chatroomId,
      { bool addToBackStack: false }) {
    if (addToBackStack) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InstantMessagingScreen(displayName: displayName, chatroomId: chatroomId))
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstantMessagingScreen(displayName: displayName, chatroomId: chatroomId))
      );
    }
  }
}