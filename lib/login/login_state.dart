class LoginState {
  bool loading;

  LoginState._internal({this.loading});

  factory LoginState.initial() => LoginState._internal(loading: false);

  factory LoginState.loading(bool loading) => LoginState._internal(loading: loading);
}