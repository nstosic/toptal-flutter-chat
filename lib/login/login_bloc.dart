import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:toptal_chat/login/login_event.dart';
import 'package:toptal_chat/login/login_state.dart';
import 'package:toptal_chat/model/login_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);

  void onLoginGoogle() async {
    add(LoginEventInProgress());
    final googleSignInRepo = GoogleSignIn(signInOption: SignInOption.standard, scopes: ["profile", "email"]);
    final account = await googleSignInRepo.signIn();
    if (account != null) {
      LoginRepo.getInstance().signInWithGoogle(account);
    } else {
      add(LogoutEvent());
    }
  }

  void onLoginFacebook() async {
    add(LoginEventInProgress());
    final facebookSignInRepo = FacebookAuth.instance;
    try {
      final signInResult = await facebookSignInRepo.login();
      LoginRepo.getInstance().signInWithFacebook(signInResult);
    } on FacebookAuthException catch (ex) {
      if (ex.errorCode != 'CANCELLED') {
        add(LoginErrorEvent("An error occurred. ${ex.message}"));
      } else {
        add(LogoutEvent());
      }
    }
  }

  void onLogout() async {
    add(LoginEventInProgress());
    bool result = await LoginRepo.getInstance().signOut();
    if (result) {
      add(LogoutEvent());
    }
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginWithFacebookEvent) {
      yield LoginState.loading(false);
    } else if (event is LogoutEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginEventInProgress) {
      yield LoginState.loading(true);
    } else if (event is LoginErrorEvent) {}
  }
}
