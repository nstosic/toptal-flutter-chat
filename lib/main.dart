import 'package:flutter/material.dart';
import 'package:toptal_chat/push_notifications/push_notifications_handler.dart';

import 'login/login_view.dart';
import 'model/chat_repo.dart';
import 'push_notifications/push_notifications_handler.dart';

void main() {
  runApp(MyApp());
  PushNotificationsHandler pushNotificationsHandler = PushNotificationsHandler();
  pushNotificationsHandler.setup();
}

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
    );
  }

  @override
  void dispose() {
    ChatRepo.getInstance().dismiss();
    super.dispose();
  }
}