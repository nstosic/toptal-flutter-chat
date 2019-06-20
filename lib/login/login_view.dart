import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'login_bloc.dart';
import 'login_state.dart';
import '../navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      builder: (context) => LoginBloc(),
      child: LoginWidget(widget: widget, widgetState: this)
    );
  }

}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key key, @required this.widget, @required this.widgetState}) : super(key: key);

  final LoginScreen widget;
  final _LoginState widgetState;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).setupAuthStateListener(this);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocBuilder(
          bloc: BlocProvider.of<LoginBloc>(context),
          builder: (context, LoginState state) {
            if (state.loading) {
              return Center(
                  child: CircularProgressIndicator(strokeWidth: 4.0)
              );
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
                        onPressed: () => BlocProvider.of<LoginBloc>(context).onLoginGoogle(this),
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
                        onPressed: () => BlocProvider.of<LoginBloc>(context).onLoginFacebook(this),
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
          }),
    );
  }



  void navigateToMain() {
      NavigationHelper.navigateToMain(widgetState.context);
  }
}
