import 'dart:developer';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mpeischedule/core/error/exeption.dart';
import 'package:mpeischedule/feature/data/models/lesoon_day_list_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_day_empty_model.dart';
import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/feature/domain/entities/lesson_day_entities.dart';

enum ActionEvent { next, back, now }
const String urlNow =
    'https://mpei.ru/Education/timetable/Pages/default.aspx?group=';

const String baseUrl =
    'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=';

class SheduleParserDataSource {
  static Future<List<LessonDayListModel>> getDayListLessonFull(
      {required url}) async {
    return await _parserPage(url);
  }

  static List<LessonDayListModel> _createEmptyListDay() {
    List<LessonDayListModel> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(LessonDayListModel(
        weekLabel: _createWeekLabel(i),
        dateTime: '',
        lessons: [],
      ));
    }
    return list;
  }

  static List<LessonModel> _copyListLesson(List<LessonModel> input) {
    List<LessonModel> copylist = [];
    for (int i = 0; i < input.length; i++) {
      var lesson = LessonModel(
          name: input[i].name,
          type: input[i].type,
          auditorium: input[i].auditorium,
          group: input[i].group,
          lecturer: input[i].lecturer,
          time: input[i].time);
      copylist.add(lesson);
    }

    return copylist;
  }

  static String _getDateFormat(Element element) {
    return element.getElementsByTagName('td')[0].text;
  }

  static LessonModel _getLesson(Element element) {
    var time = element.getElementsByTagName('td')[0].text;
    var channel =
        element.getElementsByTagName('td')[1].getElementsByTagName('span');
    String name = channel[0].text.toString();
    String type = channel[1].text.toString();
    String auditorium = channel[2].text.toString();
    String group = channel[3].text.toString();
    String lector = channel[4].text.toString();

    return LessonModel(
        name: name,
        type: type,
        auditorium: auditorium,
        group: group,
        lecturer: lector,
        time: time);
  }

  static List<LessonDayListModel> _getListDay(List<Element> weekTr) {
    List<LessonDayListModel> dayList = [];
    List<LessonModel> listLesson = [];
    String dayWeek = "";

    for (int i = 1; i < weekTr.length; i++) {
      var iter =
          weekTr[i].getElementsByClassName('mpei-galaktika-lessons-grid-date');
      print(iter);

      if (iter.length != 0) {
        if (i != 1) {
          List<LessonModel> lessonList = _copyListLesson(listLesson);
          dayList.add(LessonDayListModel(
            weekLabel: dayWeek.substring(0, 2),
            dateTime: dayWeek.substring(4),
            lessons: lessonList,
          ));
          listLesson.clear();
        }
        dayWeek = _getDateFormat(weekTr[i]);
      } else {
        LessonModel lesson = _getLesson(weekTr[i]);
        listLesson.add(lesson);
        if (i == weekTr.length - 1) {
          dayList.add(LessonDayListModel(
            weekLabel: dayWeek.substring(0, 2),
            dateTime: dayWeek.substring(4),
            lessons: listLesson,
          ));
        }
      }
    }
    return dayList;
  }

  static String _createWeekLabel(int numberWeek) {
    switch (numberWeek) {
      case 0:
        return "Пн";
      case 1:
        return "Вт";
      case 2:
        return "Ср";
      case 3:
        return "Чт";
      case 4:
        return "Пт";
      default:
        return "Сб";
    }
  }

  static List<LessonDayListModel> _initPage(List<LessonDayListModel> dayList) {
    List<LessonDayListModel> pageList = [];
    for (int i = 0; i < 6; i++) {
      pageList.add(LessonDayListModel(
          weekLabel: _createWeekLabel(i), dateTime: '', lessons: []));
    }
    for (int j = 0; j < dayList.length; j++) {
      switch (dayList[j].weekLabel) {
        case "Пн":
          pageList[0] = dayList[j];
          break;
        case "Вт":
          pageList[1] = dayList[j];
          break;
        case "Ср":
          pageList[2] = dayList[j];
          break;
        case "Чт":
          pageList[3] = dayList[j];
          break;
        case "Пт":
          pageList[4] = dayList[j];
          break;
        case "Сб":
          pageList[5] = dayList[j];
          break;
      }
    }
    return pageList;
  }

  static Future<List<LessonDayListModel>> _parserPage(String url) async {
    List<LessonDayListModel> pageListDayLesson;

    http.Response response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      List<Element> weekTr = _trueResponse(response);
      if (weekTr.length < 3) {
        print('CСессии нет');
        pageListDayLesson = _createEmptyListDay();
        return pageListDayLesson;
      } else {
        List<LessonDayListModel> dayList = _getListDay(weekTr);
        pageListDayLesson = _initPage(dayList);
        return pageListDayLesson;
      }
    } else {
      throw ServerException();
    }
  }

  static Future<List<String>> getParams({required String groupName}) async {
    http.Response commonResponse = await http.get(
      Uri.parse(
          'https://mpei.ru/Education/timetable/Pages/default.aspx?group=$groupName'),
    );
    if (commonResponse.statusCode == 200) {
      List<Element> weekTr = _trueResponse(commonResponse);
      var header = weekTr[0]
          .getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
      String headerStrinId =
          header.getElementsByTagName('a')[1].attributes.values.toString();
      var splitData = headerStrinId.split('&');
      var groupId = splitData[0].split('=')[1];
      var currentDate = splitData[1].split('=')[1].replaceAll(')', '');
      return Future.value([groupId, currentDate]);
    } else
      throw ServerException();
  }

  static List<Element> _trueResponse(http.Response response) {
    var document = parse(response.body);
    log(response.body.toString());
    print(document.body.toString());
    var tableWeek =
        document.getElementsByClassName('mpei-galaktika-lessons-grid-tbl')[0];
    var tbody = tableWeek.getElementsByTagName('tbody')[0];
    return tbody.getElementsByTagName('tr');
  }
}