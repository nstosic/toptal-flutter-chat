import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'events/login_event.dart';
import 'login_state.dart';
import '../model/login_repo.dart';
import '../model/user_repo.dart';
import '../model/user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  StreamSubscription<FirebaseUser> _authStateListener;

  void onLoginGoogle() async {
    dispatch(LoginEventInProgress());
    final googleSignInRepo = GoogleSignIn(
        signInOption: SignInOption.standard, scopes: ["profile", "email"]);
    final account = await googleSignInRepo.signIn();
    if (account != null) {
      LoginRepo.getInstance().signInWithGoogle(account);
    } else {
      dispatch(LogoutEvent());
    }
  }

  void onLoginFacebook() async {
    dispatch(LoginEventInProgress());
    final facebookSignInRepo = FacebookLogin();
    final signInResult =
        await facebookSignInRepo.logInWithReadPermissions(["email"]);
    if (signInResult.status == FacebookLoginStatus.loggedIn) {
      LoginRepo.getInstance().signInWithFacebook(signInResult);
    } else if (signInResult.status == FacebookLoginStatus.cancelledByUser) {
      dispatch(LogoutEvent());
    } else {
      dispatch(LoginErrorEvent(signInResult.errorMessage));
    }
  }

  void onLogout() async {
    dispatch(LoginEventInProgress());
    bool result = await LoginRepo.getInstance().signOut();
    if (result) {
      dispatch(LogoutEvent());
    }
  }

  @override
  LoginState get initialState {
    _authStateListener = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        final loginProvider = user.providerId;
        UserRepo.getInstance().setCurrentUser(User.fromFirebaseUser(user));
        if (loginProvider == "google") {
          dispatch(LoginWithGoogleEvent());
        } else {
          dispatch(LoginWithFacebookEvent());
        }
      } else {
        dispatch(LogoutEvent());
      }
    }, onError: (error) {
      dispatch(LoginErrorEvent(error));
    });
    return LoginState.initial();
  }

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield LoginState.set(true, true);
    } else if (event is LoginWithFacebookEvent) {
      yield LoginState.set(true, true);
    } else if (event is LogoutEvent) {
      yield LoginState.set(false, false);
    } else if (event is LoginEventInProgress) {
      yield LoginState.set(currentState.loggedIn, true);
    } else if (event is LoginErrorEvent) {

    }
  }

  @override
  void dispose() {
    _authStateListener.cancel();
    super.dispose();
  }
}
