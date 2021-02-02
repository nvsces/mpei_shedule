import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/bars/bars_event.dart';
import 'package:mpeischedule/bloc/bars/bars_state.dart';
import 'package:mpeischedule/sevices/bars_repository.dart';

class BarsBloc extends Bloc<BarsEvent, BarsState> {
  final BarsRepository barsRepository;
  BarsBloc(this.barsRepository) : super(BarsFirstState());

  @override
  Stream<BarsState> mapEventToState(BarsEvent event) async* {
    if (event is BarsLoadEvent) {
      yield BarsLoadingState();
      try {
        final String userName = await barsRepository.getUserName();
        yield BarsLoadedState(userName);
      } catch (_) {
        yield BarsErroeState();
      }
    }
  }
}
