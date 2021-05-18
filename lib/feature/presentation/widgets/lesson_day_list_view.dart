import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_event.dart';
import 'package:mpeischedule/bloc/controller/controller_state.dart';
import 'package:mpeischedule/feature/data/models/lesoon_day_list_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_day_empty_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';
import 'package:mpeischedule/feature/presentation/widgets/card_lesson.dart';
import 'package:mpeischedule/feature/presentation/widgets/book_image.dart';

class LessonDayListView extends StatelessWidget {
  List<LessonDayEntity> listDay;
  LessonDayListView({
    required this.listDay,
  });
  PageController controller = PageController(initialPage: 0);

  Widget buildListView(BuildContext ctx, List<LessonModel> _sheduleList) {
    return Container(
        child: Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _sheduleList.length,
        itemBuilder: (context, index) {
          return CardLesson(_sheduleList[index]);
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
      },
      builder: (context, stateCtrl) {
        final ControllerBloc ctrlbloc = BlocProvider.of(context);
        return Expanded(
          child: PageView.builder(
            onPageChanged: (number) {
              ctrlbloc.add(CtrlCurrentEvent(number));
            },
            controller: controller,
            itemCount: listDay.length,
            itemBuilder: (context, index) {
              if (listDay[index] is LessonDayListModel) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(listDay[index].dateTime)),
                      buildListView(context,
                          (listDay[index] as LessonDayListModel).lessons)
                    ],
                  ),
                );
              } else {
                return BookImage();
              }
            },
          ),
        );
      },
    );
  }
}
