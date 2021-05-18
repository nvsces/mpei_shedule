import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

class LessonDayEmptyModel extends LessonDayEntity {
  LessonDayEmptyModel({
    required dayTime,
    required groupId,
  }) : super(dayTime: dayTime, groupId: groupId);

  factory LessonDayEmptyModel.fromJson(Map<String, dynamic> json) {
    return LessonDayEmptyModel(
      dayTime: json['dayTime'],
      groupId: json['groupId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dayTime': dayTime,
      'groupId': groupId,
    };
  }
}
