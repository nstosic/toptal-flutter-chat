abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LogoutEvent extends LoginEvent {}

class LoginEventInProgress extends LoginEvent {}

class LoginErrorEvent extends LoginEvent {
  LoginErrorEvent(this.error);

  final dynamic error;
}