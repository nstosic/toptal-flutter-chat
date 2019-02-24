abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LogoutEvent extends LoginEvent {}