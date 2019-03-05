abstract class LoginResponse {}

class LoginFailedResponse extends LoginResponse {
  final String error;

  LoginFailedResponse(this.error);
}