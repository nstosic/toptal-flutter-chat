import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptal_chat/base/bloc_widget.dart';

import 'package:toptal_chat/login/login_bloc.dart';
import 'package:toptal_chat/login/login_event.dart';
import 'package:toptal_chat/login/login_state.dart';
import 'package:toptal_chat/navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocWidget<LoginEvent, LoginState, LoginBloc>(
        builder: (BuildContext context, LoginState state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator(strokeWidth: 4.0));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 256.0,
                    height: 32.0,
                    child: RaisedButton(
                      onPressed: () => BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                      child: Text(
                        "Login with Google",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 256.0,
                    height: 32.0,
                    child: RaisedButton(
                      onPressed: () => BlocProvider.of<LoginBloc>(context).onLoginFacebook(),
                      child: Text(
                        "Login with Facebook",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void navigateToMain() {
    NavigationHelper.navigateToMain(context);
  }
}
