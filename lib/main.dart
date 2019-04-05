import 'package:flutter/material.dart';
import 'package:toptal_chat/push_notifications/push_notifications_handler.dart';

import 'login/login_view.dart';
import 'model/chat_repo.dart';
import 'push_notifications/push_notifications_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    PushNotificationsHandler pushNotificationsHandler = PushNotificationsHandler(context);
    pushNotificationsHandler.setup();
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