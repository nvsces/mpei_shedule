import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

class LessonDayListModel extends LessonDayEntity {
  LessonDayListModel({
    required dayTime,
    required groupId,
    required this.lessons,
  }) : super(dayTime: dayTime, groupId: groupId);

  final List<LessonModel> lessons;

  factory LessonDayListModel.fromJson(Map<String, dynamic> json) {
    return LessonDayListModel(
      dayTime: json['dayTime'],
      groupId: json['groupId'],
      lessons: (json['lessons'] as List<Map<String, dynamic>>)
          .map((e) => LessonModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayTime': dayTime,
      'groupId': groupId,
      'lessons': lessons.map((e) => e.toJson()),
    };
  }
}
