import 'package:flutter/foundation.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/sevices/shedule/shedule_api_provider.dart';

class SheduleRepository {
  SheduleProvider _sheduleProvider = SheduleProvider();

  Future<List<String?>?>? getGroupId({required String name}) {
    return _sheduleProvider.getGroupId(groupName: name);
  }

  Future<List<DayLesson?>?> getDay(
      {required String name, required String date}) {
    return _sheduleProvider.dayListAction(name, date);
  }

  Future<List<DayLesson?>?> getAllDayLesson(
      {required String name, ActionEvent actionEvent = ActionEvent.now}) {
    return _sheduleProvider.getDayListLessonFull(
        groupId: name, action: actionEvent);
  }
}
