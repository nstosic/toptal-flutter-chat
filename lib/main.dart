import 'package:flutter/material.dart';
import 'package:toptal_chat/auth_observer.dart';

import 'package:toptal_chat/login/login_view.dart';
import 'package:toptal_chat/model/chat_repo.dart';
import 'package:toptal_chat/push_notifications/push_notifications_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toptal Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      navigatorObservers: [AuthObserver(), PushNotificationsHandler()],
    );
  }

  @override
  void dispose() {
    ChatRepo.getInstance().dismiss();
    super.dispose();
  }
}
