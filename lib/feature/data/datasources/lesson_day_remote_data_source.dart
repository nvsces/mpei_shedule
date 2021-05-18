import 'package:mpeischedule/feature/data/models/lesoon_day_list_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_day_empty_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/sevices/shedule/shedule_api_provider.dart';

abstract class LessonDayRemoteDataSource {
  Future<List<LessonDayEntity>> getAllLessonDay(String groupID);
}

class LessonDayRemoteDataSourceImpl implements LessonDayRemoteDataSource {
  final http.Client client = http.Client();
  SheduleProvider _sheduleProvider = SheduleProvider();
  //LessonDayRemoteDataSourceImpl({required this.client});
  LessonDayRemoteDataSourceImpl();
  @override
  Future<List<LessonDayEntity>> getAllLessonDay(String groupID) async {
    List<LessonDayEntity> rezult = [];
    List<LessonModel> lessonList = [];
    List<DayLesson?>? listProvider = await _getAllDayLesson(groupId: groupID);
    if (listProvider != null) {
      for (int i = 0; i < listProvider.length; i++) {
        if (listProvider[i] != null) {
          lessonList.clear();
          for (int j = 0; j < listProvider[i]!.lesson!.length; j++) {
            lessonList.add(
              LessonModel(
                name: listProvider[i]!.lesson![j].name,
                type: listProvider[i]!.lesson![j].type,
                auditorium: listProvider[i]!.lesson![j].auditorium,
                group: listProvider[i]!.lesson![j].group,
                lecturer: listProvider[i]!.lesson![j].lecturer,
                time: listProvider[i]!.lesson![j].time,
              ),
            );
          }
          rezult.add(LessonDayListModel(
            weekLabel: 'listProvider[i]!.date',
            dateTime: 'listProvider[i]!.groupId',
            lessons: lessonList,
          ));
        } else {
          rezult.add(LessonDayEmptyModel(weekLabel: '', dateTime: ''));
        }
      }
    }
    return Future.value(rezult);
  }

  Future<List<DayLesson?>?> _getAllDayLesson(
      {required String groupId, ActionEvent actionEvent = ActionEvent.now}) {
    return _sheduleProvider.getDayListLessonFull(
        groupId: groupId, action: actionEvent);
  }
}
