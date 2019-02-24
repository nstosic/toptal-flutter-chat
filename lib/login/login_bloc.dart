import 'dart:async';
import 'package:bloc/bloc.dart';

import 'events/login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  void onLoginGoogle() {}

  void onLoginFacebook() {}

  void onLogout() {}

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(
    LoginState currentState,
    LoginEvent event
  ) async* {
    if (event is LoginWithGoogleEvent) {
      
    } else if (event is LoginWithFacebookEvent) {

    } else if (event is LogoutEvent) {

    }
  }
}
