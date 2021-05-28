import 'dart:convert';

import 'package:mpeischedule/core/error/exeption.dart';
import 'package:mpeischedule/feature/data/models/lesoon_day_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SheduleLocalDataSource {
  Future<List<LessonDayListModel>> getLastLessonDayFromCash();
  Future<void> lessonDayToCash(List<LessonDayListModel> lessons);
}

const CACHED_LESSONDAY_LIST = 'CACHED_LESSONDAY_LIST';

class SheduleLocalDataSourceImpl extends SheduleLocalDataSource {
  final SharedPreferences sharedPreferences;

  SheduleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LessonDayListModel>> getLastLessonDayFromCash() async {
    final jsonLessonDayList =
        sharedPreferences.getStringList(CACHED_LESSONDAY_LIST);
    if (jsonLessonDayList != null && jsonLessonDayList.isNotEmpty) {
      return Future.value(jsonLessonDayList
          .map((lessons) => LessonDayListModel.fromJson(json.decode(lessons)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> lessonDayToCash(List<LessonDayListModel> lessons) async {
    final List<String> jsonLessonDayList =
        lessons.map((lessons) => json.encode(lessons.toJson())).toList();

    sharedPreferences.setStringList(CACHED_LESSONDAY_LIST, jsonLessonDayList);
    print('LessonDays to write Cache: ${jsonLessonDayList.length}');
    return Future.value(jsonLessonDayList);
  }
}
