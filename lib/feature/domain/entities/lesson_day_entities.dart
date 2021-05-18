import 'package:equatable/equatable.dart';

class LessonDayEntity extends Equatable {
  final String weekLabel;
  final String dateTime;

  LessonDayEntity({
    required this.weekLabel,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [weekLabel, dateTime];
}
