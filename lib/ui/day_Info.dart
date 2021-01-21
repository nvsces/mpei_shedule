import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller_event.dart';
import 'package:mpeischedule/bloc/controller_state.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';

class DayInfoLesson extends StatelessWidget {
  List<DayLesson> listDay;
  DayInfoLesson({@required this.listDay, Key key}) : super(key: key);
  PageController controller = PageController(initialPage: 0);

  Widget buildListView(BuildContext ctx, List<Lesson> _sheduleList) {
    return Container(
        child: Expanded(
      child: ListView.builder(
        itemCount: _sheduleList.length,
        itemBuilder: (context, index) {
          return Card(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(12),
              gradient: LinearGradient(
                  colors: [Colors.grey[800], Colors.grey[850]],
                  begin: Alignment(1.0, 0.0),
                  end: Alignment(1.0, 1.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _sheduleList[index].name,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(_sheduleList[index].type, textAlign: TextAlign.start),
                Text(_sheduleList[index].auditorium,
                    textAlign: TextAlign.start),
                Text(_sheduleList[index].group, textAlign: TextAlign.start),
                Text(_sheduleList[index].lecturer, textAlign: TextAlign.start),
                Text(_sheduleList[index].time, textAlign: TextAlign.end),
              ],
            ),
          ));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerBloc, ControllerState>(
        listener: (context, state) {
      if (state is CtrlIndexState) {
        controller.jumpToPage(state.sectionIndex);
      }
    }, builder: (context, stateCtrl) {
      final ControllerBloc ctrlbloc = BlocProvider.of(context);
      return Expanded(
          child: PageView.builder(
              onPageChanged: (number) {
                ctrlbloc.add(CtrlCurrentEvent(number));
              },
              controller: controller,
              itemCount: listDay.length,
              itemBuilder: (context, index) {
                if (listDay[index] == null) {
                  return (Text('День самостоятельных занятий'));
                } else
                  return Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text(listDay[index].date),
                          buildListView(context, listDay[index].lesson)
                        ],
                      ));
                //Text(listShdl[index].auditorium)
              }));
    });
  }
}
