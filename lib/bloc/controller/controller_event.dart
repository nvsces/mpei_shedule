abstract class ControllerEvent {}

class CtrlNextEvent extends ControllerEvent {}

class CtrlCurrentEvent extends ControllerEvent {
  int index;
  CtrlCurrentEvent(this.index) : assert(index != null);
}

class CtrlBackEvent extends ControllerEvent {}
