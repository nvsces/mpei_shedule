import 'package:flutter/foundation.dart';
import 'package:mpeischedule/models/lesson.dart';

class DayLesson {
  String? day;
  String? date;
  String? groupId;

  List<Lesson>? lesson;

  DayLesson(
    @required this.day,
    @required this.date,
    @required this.lesson,
  );
}
