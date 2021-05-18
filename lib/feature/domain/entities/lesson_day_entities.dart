import 'package:equatable/equatable.dart';

class LessonDayEntity extends Equatable {
  final String dayTime;
  final String groupId;

  LessonDayEntity({
    required this.dayTime,
    required this.groupId,
  });

  @override
  List<Object?> get props => [dayTime, groupId];
}
