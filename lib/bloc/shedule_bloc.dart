import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule_state.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/sevices/shedule_api_provider.dart';
import 'package:mpeischedule/sevices/shedule_repository.dart';

class SheduleBloc extends Bloc<SheduleEvent, SheduleState> {
  final SheduleRepository sheduleRepository;

  SheduleBloc({this.sheduleRepository}) : super(SheduleFirstState());
  @override
  Stream<SheduleState> mapEventToState(SheduleEvent event) async* {
    if (event is SheduleLoadEvent) {
      yield SheduleLoadingState();
      try {
        print("loading data");
        final List<String> param =
            await sheduleRepository.getGroupId(name: event.namrGroup);

        final List<DayLesson> _loadLessonList =
            await sheduleRepository.getAllDayLesson(name: event.namrGroup);
        //print(groupId);
        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: param[0],
            dateTime: DateTime.parse(param[1].replaceAll('.', '-'))
                .subtract(Duration(days: 7)));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else if (event is SheduleNextEvent) {
      yield SheduleLoadingState();
      try {
        print("loading data");
        final List<DayLesson> _loadLessonList = await sheduleRepository.getDay(
            name: event.namrGroup, date: event.date);
        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: event.namrGroup,
            dateTime: DateTime.parse(event.date.replaceAll('.', '-')));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else if (event is SheduleBackEvent) {
      yield SheduleLoadingState();
      try {
        print("loading data");
        final List<DayLesson> _loadLessonList = await sheduleRepository.getDay(
            name: event.namrGroup, date: event.date);
        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: event.namrGroup,
            dateTime: DateTime.parse(event.date.replaceAll('.', '-')));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else
      yield SheduleEmptyState();
  }
}
