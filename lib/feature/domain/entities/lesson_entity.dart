import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final String name;
  final String type;
  final String auditorium;
  final String group;
  final String lecturer;
  final String time;

  LessonEntity({
    required this.name,
    required this.type,
    required this.auditorium,
    required this.group,
    required this.lecturer,
    required this.time,
  });

  @override
  List<Object?> get props => [name, type, auditorium, group, lecturer, time];
}
