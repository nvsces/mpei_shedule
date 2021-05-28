import 'package:mpeischedule/core/error/exeption.dart';
import 'package:mpeischedule/core/platform/network_info.dart';
import 'package:mpeischedule/feature/data/datasources/shedule_local_data_source.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';
import 'package:mpeischedule/feature/data/datasources/shedule_parser_data_source.dart';
import 'package:mpeischedule/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:mpeischedule/feature/domain/repositories/lesson_day_repositories.dart';

class LessonDayRepositoryImpl implements LessonDayRepository {
  final SheduleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LessonDayRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LessonDayEntity>>> getAllDayLesson(
      String url) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLessonDay =
            await SheduleParserDataSource.getDayListLessonFull(url: url);
        localDataSource.lessonDayToCash(remoteLessonDay);
        return Right(remoteLessonDay);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localLessonDays =
            await localDataSource.getLastLessonDayFromCash();
        return Right(localLessonDays);
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    try {
      final remoteLessonDay =
          await SheduleParserDataSource.getDayListLessonFull(url: url);
      return Right(remoteLessonDay);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
