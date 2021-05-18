import 'package:mpeischedule/core/error/exeption.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';
import 'package:mpeischedule/feature/data/datasources/parser_data_source.dart';
import 'package:mpeischedule/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:mpeischedule/feature/domain/repositories/lesson_day_repositories.dart';

class LessonDayRepositoryImpl implements LessonDayRepository {
  @override
  Future<Either<Failure, List<LessonDayEntity>>> getAllDayLesson(
      String group, ActionEvent action) async {
    try {
      final remoteLessonDay = await ParserDataSource.getDayListLessonFull(
        groupName: group,
        action: action,
      );
      return Right(remoteLessonDay);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
