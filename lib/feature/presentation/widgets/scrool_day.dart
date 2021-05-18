import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_bloc.dart';
import 'package:mpeischedule/bloc/controller/controller_event.dart';
import 'package:mpeischedule/bloc/controller/controller_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollDay extends StatelessWidget {
  List<String> listTime;
  List<String> day = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"];
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
                ? Theme.of(context).accentColor
                : Colors.grey[850],
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          day[index] + ' ' + listTime[index],
          style: (state as CtrlIndexState).sectionIndex == index
              ? TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor)
              : TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
