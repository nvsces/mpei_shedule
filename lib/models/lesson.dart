import 'package:flutter/foundation.dart';

class Lesson {
  String name;
  String type;
  String auditorium;
  String group;
  String lecturer;
  String time;

  Lesson(
      {@required this.name,
      @required this.type,
      @required this.auditorium,
      @required this.group,
      @required this.lecturer,
      @required this.time});
}
