abstract class BarsState {}

class BarsFirstState extends BarsState {}

class BarsLoadingState extends BarsState {}

class BarsLoadedState extends BarsState {
  String username;
  BarsLoadedState(this.username) : assert(username != null);
}

class BarsErroeState extends BarsState {}
