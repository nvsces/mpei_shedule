import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller_event.dart';
import 'package:mpeischedule/bloc/shedule_bloc.dart';
import 'package:mpeischedule/bloc/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule_state.dart';
import 'package:mpeischedule/sevices/shedule_repository.dart';
import 'package:mpeischedule/ui/day_Info.dart';
import 'package:mpeischedule/ui/scrool_day.dart';

class BodyBloc extends StatelessWidget {
  String nameGroup;
  BodyBloc(this.nameGroup);
  final sheduleRepository = SheduleRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SheduleBloc>(
        create: (context) => SheduleBloc(sheduleRepository: sheduleRepository),
        child: BlocProvider<ControllerBloc>(
            create: (context) => ControllerBloc(),
            child: BlocBuilder<SheduleBloc, SheduleState>(
              builder: (context, state) {
                final SheduleBloc sheduleBloc = BlocProvider.of(context);
                final ControllerBloc ctrlBloc = BlocProvider.of(context);
                if (state is SheduleFirstState) {
                  sheduleBloc.add(SheduleLoadEvent(
                      namrGroup: nameGroup, date: DateTime.now()));
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SheduleLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SheduleLoadedState) {
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
                            ctrlBloc.add(CtrlCurrentEvent(0));
                            sheduleBloc.add(SheduleNextEvent(
                                namrGroup: state.groupId,
                                date: state.dateTime));
                          },
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.navigate_before),
                          onPressed: () {
                            ctrlBloc.add(CtrlCurrentEvent(0));
                            sheduleBloc.add(SheduleBackEvent(
                                namrGroup: state.groupId,
                                date: state.dateTime));
                          },
                        ),
                      ),
                      ScrollDay(state.listDayName),
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
