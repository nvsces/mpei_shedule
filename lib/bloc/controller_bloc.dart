import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller_event.dart';
import 'package:mpeischedule/bloc/controller_state.dart';

class ControllerBloc extends Bloc<ControllerEvent, ControllerState> {
  ControllerBloc() : super(CtrlIndexState(sectionIndex: 0));

  int sectionIndex = 0;

  @override
  Stream<ControllerState> mapEventToState(ControllerEvent event) async* {
    if (event is CtrlNextEvent) {
      sectionIndex++;
      yield CtrlIndexState(sectionIndex: sectionIndex);
    } else if (event is CtrlBackEvent) {
      sectionIndex--;
      yield CtrlIndexState(sectionIndex: sectionIndex);
    } else if (event is CtrlCurrentEvent) {
      sectionIndex = event.index;
      yield CtrlIndexState(sectionIndex: sectionIndex);
    }
  }
}
