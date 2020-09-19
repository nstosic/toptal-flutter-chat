import 'package:flutter/material.dart';

import 'package:toptal_chat/login/login_view.dart';
import 'package:toptal_chat/main/main_view.dart';
import 'package:toptal_chat/create_chatroom/create_chatroom_view.dart';
import 'package:toptal_chat/instant_messaging/instant_messaging_view.dart';

bool Function(Route<dynamic>) _defaultRule = (_) => true;

class NavigationHelper {
  static void navigateToLogin(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  static void navigateToMain(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  static void navigateToAddChat(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CreateChatroomScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateChatroomScreen()));
    }
  }

  static void navigateToInstantMessaging(
    BuildContext context,
    String displayName,
    String chatroomId, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InstantMessagingScreen(
            displayName: displayName,
            chatroomId: chatroomId,
          ),
        ),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InstantMessagingScreen(
            displayName: displayName,
            chatroomId: chatroomId,
          ),
        ),
      );
    }
  }
}
