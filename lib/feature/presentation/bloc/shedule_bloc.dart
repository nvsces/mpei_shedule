import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/core/platform/network_info.dart';
import 'package:mpeischedule/feature/data/datasources/shedule_parser_data_source.dart';
import 'package:mpeischedule/feature/domain/usecases/get_all_day_lesson.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_event.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_state.dart';

import '../../../locator_service.dart';

class SheduleBloc extends Bloc<SheduleEvent, SheduleState> {
  final GetAllDayLesson getAllDayLesson;
  NetworkInfo network;

  SheduleBloc({required this.getAllDayLesson, required this.network})
      : super(SheduleFirstState());

  @override
  Stream<SheduleState> mapEventToState(SheduleEvent event) async* {
    if (event is SheduleLoadEvent) {
      yield* _mapFetchSheduleLoadEventToState(
        event.namrGroup,
        event.date,
        ActionEvent.now,
      );
    }
    if (event is SheduleBackEvent) {
      yield* _mapFetchSheduleLoadEventToState(
        event.namrGroup,
        event.date,
        ActionEvent.back,
      );
    }
    if (event is SheduleNextEvent) {
      yield* _mapFetchSheduleLoadEventToState(
        event.namrGroup,
        event.date,
        ActionEvent.next,
      );
    }
  }

  Stream<SheduleState> _mapFetchSheduleLoadEventToState(
    String nameGroup,
    DateTime dateTime,
    ActionEvent action,
  ) async* {
    yield SheduleLoadingState();
    DateTime date = DateTime.now();
    String groupId = nameGroup;
    String url = '';
    if (await network.isConnected) {
      switch (action) {
        case ActionEvent.now:
          {
            try {
              url = urlNow + nameGroup;
              List<String> params =
                  await SheduleParserDataSource.getParams(groupName: nameGroup);
              date = DateTime.parse(params[1].replaceAll('.', '-'))
                  .subtract(Duration(days: 7));
              groupId = params[0];
              break;
            } catch (e) {
              yield SheduleErrorState();
              break;
            }
          }
        case ActionEvent.back:
          {
            date = dateTime.subtract(Duration(days: 7));
            var dateString =
                date.toString().replaceAll('-', '.').substring(0, 10);
            url = baseUrl + nameGroup + '&start=' + dateString;
            break;
          }

        default:
          {
            date = dateTime.add(Duration(days: 7));
            var dateString =
                date.toString().replaceAll('-', '.').substring(0, 10);
            url = baseUrl + nameGroup + '&start=' + dateString;
            // url =
            //     'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=14297&start=2021.09.13';
            break;
          }
      }
    }
    final failOrLessonDay = await getAllDayLesson(url);

    yield failOrLessonDay.fold(
      (failure) => SheduleErrorState(),
      (lessonday) => SheduleLoadedState(
        loadedLesson: lessonday,
        groupId: groupId,
        dateTime: date,
        listDayName: _createDateList(date),
      ),
    );
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

  String _getMonth(int month) {
    print('Месяц = ' + month.toString());
    switch (month) {
      case 1:
        return "Янв";
      case 13:
        return "Янв";
      case 2:
        return "Фев";
      case 3:
        return "Мар";
      case 4:
        return "Апр";
      case 5:
        return "Май";
      case 6:
        return "Июн";
      case 7:
        return "Июл";
      case 8:
        return "Авг";
      case 9:
        return "Сен";
      case 10:
        return "Окт";
      case 11:
        return "Ноя";
      case 12:
        return "Дек";
      default:
        return "TTT";
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
}
