import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller_event.dart';
import 'package:mpeischedule/bloc/controller_state.dart';
import 'package:mpeischedule/bloc/shedule_bloc.dart';
import 'package:mpeischedule/bloc/shedule_event.dart';
import 'package:mpeischedule/bloc/shedule_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollDay extends StatelessWidget {
  //ScrollDay({Key key}) : super(key: key);
  List<String> listTime;
  List<String> day = ["Пон", "Вт", "Ср", "Чет", "Пят", "Суб", "Вос"];
  ItemScrollController _scrollController = ItemScrollController();

  ScrollDay(this.listTime);

  Widget buildDayItem(BuildContext context, int index, ControllerState state,
      ControllerBloc ctrlbloc) {
    return GestureDetector(
      onTap: () {
        ctrlbloc.add(CtrlCurrentEvent(index));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
            color: (state as CtrlIndexState).sectionIndex == index
                ? Colors.grey[700]
                : Colors.grey[850],
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          day[index] + ' ' + listTime[index],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35.0,
        child: BlocConsumer<ControllerBloc, ControllerState>(
            listener: (context, state) {
          if (state is CtrlIndexState) {
            _scrollController.scrollTo(
                index: state.sectionIndex,
                duration: Duration(milliseconds: 300));
          }
        }, builder: (context, state) {
          final ControllerBloc ctrlbloc = BlocProvider.of(context);
          return ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,
            itemScrollController: _scrollController,
            itemCount: day.length,
            itemBuilder: (context, index) =>
                buildDayItem(context, index, state, ctrlbloc),
          );
        }));
  }
}
