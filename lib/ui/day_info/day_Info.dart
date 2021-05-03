import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_event.dart';
import 'package:mpeischedule/bloc/controller/controller_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';
import 'package:mpeischedule/ui/card_shedule.dart';
import 'package:mpeischedule/ui/day_info/book_image.dart';

class DayInfoLesson extends StatelessWidget {
  List<DayLesson?>? listDay;
  DayInfoLesson({
    required this.listDay,
  });
  PageController controller = PageController(initialPage: 0);

  Widget buildListView(BuildContext ctx, List<Lesson> _sheduleList) {
    return Container(
        child: Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _sheduleList.length,
        itemBuilder: (context, index) {
          return CardShedule(_sheduleList[index]);
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
            itemCount: listDay!.length,
            itemBuilder: (context, index) {
              if (listDay![index] == null) {
                return BookImage();
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(listDay![index]!.date!)),
                      buildListView(context, listDay![index]!.lesson!)
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
