import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_event.dart';
import 'package:mpeischedule/bloc/controller/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_event.dart';
import 'package:mpeischedule/bloc/shedule/shedule_bloc.dart';
import 'package:mpeischedule/bloc/shedule/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule/shedule_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/sevices/shedule_repository.dart';
import 'package:mpeischedule/ui/shedule/day_Info.dart';
import 'package:mpeischedule/ui/shedule/scrool_day.dart';

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
                      buildSheduleTile(state, sheduleBloc, ctrlBloc),
                      ScrollDay(state.listDayName),
                      DayInfoLesson(listDay: state.loadedLesson)
                    ],
                  );
                }
                final AuthBloc authBlocC = BlocProvider.of(context);
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(S.of(context).error_shedule),
                    RaisedButton(
                        child: Text(S.of(context).choose_group_label),
                        onPressed: () {
                          authBlocC.add(ExitEvent());
                        })
                  ],
                ));
              },
            )));
  }

  Widget buildSheduleTile(SheduleLoadedState state, SheduleBloc sheduleBloc,
      ControllerBloc ctrlBloc) {
    return ListTile(
      title: Text(
        createTitleTime(state.dateTime),
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: () {
          ctrlBloc.add(CtrlCurrentEvent(0));
          sheduleBloc.add(
              SheduleNextEvent(namrGroup: state.groupId, date: state.dateTime));
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          ctrlBloc.add(CtrlCurrentEvent(0));
          sheduleBloc.add(
              SheduleBackEvent(namrGroup: state.groupId, date: state.dateTime));
        },
      ),
    );
  }
}
