import 'package:dartz/dartz.dart';
import 'package:mpeischedule/core/error/failure.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

abstract class LessonDayRepository {
  Future<Either<Failure, List<LessonDayEntity>>> getAllDayLesson(String url);
}
