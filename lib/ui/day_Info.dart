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
        padding: EdgeInsets.all(20),
        itemCount: _sheduleList.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 30,
              //shadowColor: Colors.redAccent,
              margin: EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.grey[800], Colors.grey[850]],
                        begin: Alignment(1.0, 0.0),
                        end: Alignment(1.0, 1.0)),
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    //verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _sheduleList[index].name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.school),
                              Text(' ' + _sheduleList[index].type,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Text(_sheduleList[index].auditorium,
                                  textAlign: TextAlign.start)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.directions_walk),
                              Text(_sheduleList[index].group,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.person),
                              Text(_sheduleList[index].lecturer,
                                  textAlign: TextAlign.start),
                            ],
                          )
                        ],
                      )),
                      // Expanded(
                      //     child:
                      Text(_sheduleList[index].time, textAlign: TextAlign.end)
                      //)
                    ],
                  )));
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
                  return Center(
                      child: ListTile(
                    title: Image.asset(
                      'assets/image/rem.jpg',
                      scale: 1,
                    ),
                    subtitle: Text(
                      'ДEНЬ САМОСТОЯТЕЛЬНЫХ ЗАНЯТИЙ ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ));
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
