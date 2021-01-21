import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller_bloc.dart';
import 'package:mpeischedule/bloc/shedule_bloc.dart';
import 'package:mpeischedule/bloc/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule_state.dart';
import 'package:mpeischedule/sevices/shedule_repository.dart';
import 'package:mpeischedule/ui/day_Info.dart';
import 'package:mpeischedule/ui/scrool_day.dart';

class BodyBloc extends StatelessWidget {
  String nameGroup;
  BodyBloc(this.nameGroup);
  var date = DateTime.now();
  String dateString = "";
  final sheduleRepository = SheduleRepository();
  List<String> dayTime = [];

  String getMonth(int month) {
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

  List<int> checkValid(int k, int month) {
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

  List<String> createDateList(DateTime time) {
    List<String> listTime = [];
    int startDay = time.day;

    for (int i = 0; i < 7; i++) {
      int k = checkValid(startDay + i, time.month)[0];
      String month = getMonth(checkValid(startDay + i, time.month)[1]);
      String temp = k.toString() + " " + month;
      listTime.add(temp);
    }

    return listTime;
  }

  String createTitleTime(DateTime time) {
    DateTime start = time;
    DateTime end = time.add(Duration(days: 6));

    String title = start.toString().replaceAll('-', '.').substring(0, 10) +
        '  -  ' +
        end.toString().replaceAll('-', '.').substring(0, 10);
    return title;
  }

  @override
  Widget build(BuildContext context) {
    dateString = date.toString().replaceAll('-', '.').substring(0, 10);
    String groupCurrent = nameGroup;
    return BlocProvider<SheduleBloc>(
        create: (context) => SheduleBloc(sheduleRepository: sheduleRepository),
        child: BlocProvider<ControllerBloc>(
            create: (context) => ControllerBloc(),
            child: BlocBuilder<SheduleBloc, SheduleState>(
              builder: (context, state) {
                final SheduleBloc sheduleBloc = BlocProvider.of(context);
                if (state is SheduleFirstState) {
                  sheduleBloc.add(SheduleLoadEvent(namrGroup: groupCurrent));
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SheduleLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SheduleLoadedState) {
                  date = state.dateTime;
                  dayTime = createDateList(state.dateTime);
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          createTitleTime(state.dateTime),
                          textAlign: TextAlign.center,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.navigate_next),
                          onPressed: () {
                            //groupCurrent = state.groupId;
                            date = date.add(Duration(days: 7));
                            dateString = date
                                .toString()
                                .replaceAll('-', '.')
                                .substring(0, 10);
                            sheduleBloc.add(SheduleNextEvent(
                                namrGroup: state.groupId, date: dateString));
                          },
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.navigate_before),
                          onPressed: () {
                            date = date.subtract(Duration(days: 7));
                            //groupCurrent = state.groupId;
                            dateString = date
                                .toString()
                                .replaceAll('-', '.')
                                .substring(0, 10);
                            sheduleBloc.add(SheduleBackEvent(
                                namrGroup: state.groupId, date: dateString));
                          },
                        ),
                      ),
                      ScrollDay(dayTime),
                      DayInfoLesson(listDay: state.loadedLesson)
                    ],
                  );
                }
                return Container(
                  child: Text('ошибка веб'),
                );
              },
            )));
  }
}
