import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

class LessonDayListModel extends LessonDayEntity {
  LessonDayListModel({
    required weekLabel,
    required dateTime,
    required this.lessons,
  }) : super(weekLabel: weekLabel, dateTime: dateTime);

  final List<LessonModel> lessons;

  factory LessonDayListModel.fromJson(Map<String, dynamic> json) {
    return LessonDayListModel(
      weekLabel: json['weekLabel'],
      dateTime: json['dateTime'],
      lessons: (json['lessons'] as List<Map<String, dynamic>>)
          .map((e) => LessonModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekLabel': weekLabel,
      'dateTime': dateTime,
      'lessons': lessons.map((e) => e.toJson()),
    };
  }
}
