import 'package:firebase_core/firebase_core.dart';
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
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Toptal Chat',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginScreen(),
            navigatorObservers: [AuthObserver(), PushNotificationsHandler()],
          );
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    ChatRepo.getInstance().dismiss();
    super.dispose();
  }
}
