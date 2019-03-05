class LoginState {
  bool loggedIn;
  bool loading;

  LoginState._internal({this.loggedIn, this.loading});

  factory LoginState.initial() => LoginState._internal(loggedIn: false, loading: false);

  factory LoginState.set(bool loggedIn, bool loading) => LoginState._internal(loggedIn: loggedIn, loading: loading);
}