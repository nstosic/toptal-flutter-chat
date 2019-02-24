class LoginState {
  final bool loggedIn;

  const LoginState({this.loggedIn});

  factory LoginState.initial() => LoginState(loggedIn: false);
}