import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_event.dart';
import 'package:mpeischedule/bloc/controller/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_event.dart';
import 'package:mpeischedule/feature/data/repositories/lesson_day_repositories_imp.dart';
import 'package:mpeischedule/feature/domain/usecases/get_all_day_lesson.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_bloc.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_event.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_state.dart';
import 'package:mpeischedule/feature/presentation/widgets/lesson_day_list_view.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/feature/presentation/widgets/scrool_day.dart';

import '../../../locator_service.dart';

class LessonDayPage extends StatelessWidget {
  String nameGroup;
  LessonDayPage({
    required this.nameGroup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SheduleBloc>(
      create: (context) => sl<SheduleBloc>(),
      child: BlocProvider<ControllerBloc>(
        create: (context) => ControllerBloc(),
        child: BlocBuilder<SheduleBloc, SheduleState>(
          builder: (context, state) {
            final SheduleBloc sheduleBloc = BlocProvider.of(context);
            final ControllerBloc ctrlBloc = BlocProvider.of(context);
            if (state is SheduleFirstState) {
              sheduleBloc.add(
                  SheduleLoadEvent(namrGroup: nameGroup, date: DateTime.now()));
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
                  LessonDayListView(listDay: state.loadedLesson)
                ],
              );
            }
            final AuthBloc authBlocC = BlocProvider.of(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(S.of(context).error_shedule),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).accentColor)),
                    child: Text(
                      S.of(context).choose_group_label,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    onPressed: () {
                      authBlocC.add(ExitEvent());
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
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

String createTitleTime(DateTime time) {
  DateTime start = time;
  DateTime end = time.add(Duration(days: 6));

  String title = start.toString().replaceAll('-', '.').substring(0, 10) +
      '  -  ' +
      end.toString().replaceAll('-', '.').substring(0, 10);
  return title;
}
