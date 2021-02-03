abstract class MpeiAuthEvent {}

class MpeiLoginEvent extends MpeiAuthEvent {
  String login;
  String password;
  MpeiLoginEvent(this.login, this.password);
}

class MpeiExitEvent extends MpeiAuthEvent {}

class MpeiCheckAuthEvent extends MpeiAuthEvent {}
