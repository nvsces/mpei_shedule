import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/shedule/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule/shedule_state.dart';
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
        final List<String> param =
            await sheduleRepository.getGroupId(name: event.namrGroup);
        final List<DayLesson> _loadLessonList =
            await sheduleRepository.getAllDayLesson(name: event.namrGroup);
        var date = DateTime.parse(param[1].replaceAll('.', '-'))
            .subtract(Duration(days: 7));
        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: param[0],
            dateTime: date,
            listDayName: _createDateList(date));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else if (event is SheduleNextEvent) {
      yield SheduleLoadingState();
      try {
        var date = event.date.add(Duration(days: 7));
        var dateString = date.toString().replaceAll('-', '.').substring(0, 10);
        final List<DayLesson> _loadLessonList = await sheduleRepository.getDay(
            name: event.namrGroup, date: dateString);

        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: event.namrGroup,
            dateTime: date,
            listDayName: _createDateList(date));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else if (event is SheduleBackEvent) {
      yield SheduleLoadingState();
      try {
        var date = event.date.subtract(Duration(days: 7));
        var dateString = date.toString().replaceAll('-', '.').substring(0, 10);
        final List<DayLesson> _loadLessonList = await sheduleRepository.getDay(
            name: event.namrGroup, date: dateString);

        yield SheduleLoadedState(
            loadedLesson: _loadLessonList,
            groupId: event.namrGroup,
            dateTime: date,
            listDayName: _createDateList(date));
      } catch (_) {
        yield SheduleEmptyState();
      }
    } else
      yield SheduleEmptyState();
  }

  /// help function
  String _getMonth(int month) {
    print('Месяц = ' + month.toString());
    switch (month) {
      case 1:
        return "Янв";
        break;
      case 13:
        return "Янв";
        break;
      case 2:
        return "Фев";
        break;
      case 3:
        return "Мар";
        break;
      case 4:
        return "Апр";
        break;
      case 5:
        return "Май";
        break;
      case 6:
        return "Июн";
        break;
      case 7:
        return "Июл";
        break;
      case 8:
        return "Авг";
        break;
      case 9:
        return "Сен";
        break;
      case 10:
        return "Окт";
        break;
      case 11:
        return "Ноя";
        break;
      case 12:
        return "Дек";
        break;
      default:
        return "TTT";
        break;
    }
  }

  List<int> _checkValid(int k, int month) {
    List<int> longMonth = [1, 3, 5, 7, 8, 10, 12];
    bool shortMonth = true;
    longMonth.forEach((element) {
      if (month == element) shortMonth = false;
    });
    List<int> param = [];
    int outh = -1;
    int full = 31;
    if (month != 2) {
      if (shortMonth) full = 30;
    } else
      full = 28;

    outh = k - full;
    if (outh > 0) {
      param.add(outh);
      param.add(month + 1);
    } else {
      param.add(k);
      param.add(month);
    }
    return param;
  }

  List<String> _createDateList(DateTime time) {
    List<String> listTime = [];
    int startDay = time.day;

    for (int i = 0; i < 7; i++) {
      int k = _checkValid(startDay + i, time.month)[0];
      String month = _getMonth(_checkValid(startDay + i, time.month)[1]);
      String temp = k.toString() + " " + month;
      listTime.add(temp);
    }

    return listTime;
  }
}

String createTitleTime(DateTime time) {
  DateTime start = time;
  DateTime end = time.add(Duration(days: 6));

  String title = start.toString().replaceAll('-', '.').substring(0, 10) +
      '  -  ' +
      end.toString().replaceAll('-', '.').substring(0, 10);
  return title;
}
