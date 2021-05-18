import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

abstract class SheduleState {}

class SheduleFirstState extends SheduleState {}

class SheduleLoadingState extends SheduleState {}

class SheduleEmptyState extends SheduleState {}

class SheduleLoadedState extends SheduleState {
  List<LessonDayEntity> loadedLesson;
  List<String> listDayName;
  String groupId;
  DateTime dateTime;
  SheduleLoadedState(
      {required this.loadedLesson,
      required this.groupId,
      required this.dateTime,
      required this.listDayName});
}

class SheduleErrorState extends SheduleState {}
