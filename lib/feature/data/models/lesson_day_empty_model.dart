import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

class LessonDayEmptyModel extends LessonDayEntity {
  LessonDayEmptyModel({
    required weekLabel,
    required dateTime,
  }) : super(weekLabel: weekLabel, dateTime: dateTime);

  factory LessonDayEmptyModel.fromJson(Map<String, dynamic> json) {
    return LessonDayEmptyModel(
      weekLabel: json['weekLabel'],
      dateTime: json['dateTime'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'weekLabel': weekLabel,
      'dateTime': dateTime,
    };
  }
}
