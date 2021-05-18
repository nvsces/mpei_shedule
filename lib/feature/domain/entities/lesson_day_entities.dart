import 'package:equatable/equatable.dart';

class LessonDayEntity extends Equatable {
  final String dayTime;

  LessonDayEntity({required this.dayTime});

  @override
  List<Object?> get props => [dayTime];
}
