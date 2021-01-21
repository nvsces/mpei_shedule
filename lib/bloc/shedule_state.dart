import 'package:flutter/foundation.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';

abstract class SheduleState {}

class SheduleFirstState extends SheduleState {}

class SheduleLoadingState extends SheduleState {}

class SheduleEmptyState extends SheduleState {}

class SheduleLoadedState extends SheduleState {
  List<DayLesson> loadedLesson;
  List<String> listDayName;
  String groupId;
  DateTime dateTime;
  SheduleLoadedState(
      {@required this.loadedLesson,
      @required this.groupId,
      @required this.dateTime,
      @required this.listDayName})
      : assert(loadedLesson != null);
}

class SheduleErrorState extends SheduleState {}
