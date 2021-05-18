import 'package:mpeischedule/feature/domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  LessonModel({
    required name,
    required type,
    required auditorium,
    required group,
    required lecturer,
    required time,
  }) : super(
            auditorium: auditorium,
            type: type,
            name: name,
            group: group,
            lecturer: lecturer,
            time: time);

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      name: json['name'],
      type: json['type'],
      auditorium: json['auditorium'],
      group: json['group'],
      lecturer: json['lecturer'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'auditorium': auditorium,
      'group': group,
      'lecturer': lecturer,
      'time': time
    };
  }
}
