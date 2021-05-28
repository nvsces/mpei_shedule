import 'package:dartz/dartz.dart';
import 'package:mpeischedule/core/error/failure.dart';
import 'package:mpeischedule/feature/data/datasources/shedule_parser_data_source.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';
import 'package:mpeischedule/feature/domain/repositories/lesson_day_repositories.dart';

class GetAllDayLesson {
  final LessonDayRepository lessonDayRepository;

  GetAllDayLesson(this.lessonDayRepository);

  Future<Either<Failure, List<LessonDayEntity>>> call(String url) async {
    return await lessonDayRepository.getAllDayLesson(url);
  }
}
