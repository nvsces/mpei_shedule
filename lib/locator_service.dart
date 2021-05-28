import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mpeischedule/core/platform/network_info.dart';
import 'package:mpeischedule/feature/data/datasources/shedule_local_data_source.dart';
import 'package:mpeischedule/feature/data/repositories/lesson_day_repositories_imp.dart';
import 'package:mpeischedule/feature/domain/repositories/lesson_day_repositories.dart';
import 'package:mpeischedule/feature/domain/usecases/get_all_day_lesson.dart';
import 'package:mpeischedule/feature/presentation/bloc/shedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerFactory(() => SheduleBloc(getAllDayLesson: sl(), network: sl()));
  //UseCases
  sl.registerLazySingleton(() => GetAllDayLesson(sl()));
  //Repository
  sl.registerLazySingleton<LessonDayRepository>(
    () => LessonDayRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<SheduleLocalDataSource>(
    () => SheduleLocalDataSourceImpl(sharedPreferences: sl()),
  );
  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
