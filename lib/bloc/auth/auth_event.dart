abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String nameGroup;
  LoginEvent(this.nameGroup);
}

class ExitEvent extends AuthEvent {}
