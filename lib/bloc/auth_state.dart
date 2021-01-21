abstract class AuthState {}

class LoginState extends AuthState {
  String nameGroup;
  LoginState(this.nameGroup);
}

class NotLogginState extends AuthState {}
