import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_bloc.dart';
import 'login_state.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        bloc: _bloc, child: LoginWidget(widget: widget));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key key, @required this.widget}) : super(key: key);

  final LoginScreen widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocBuilder(
          bloc: BlocProvider.of<LoginBloc>(context),
          builder: (context, LoginState state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () =>
                        BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                    child: Text(
                      "Google Sign-In",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.redAccent,
                  ),
                  RaisedButton(
                    onPressed: () =>
                        BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                    child: Text(
                      "Facebook Sign-In",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
