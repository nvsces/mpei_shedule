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
//  'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=' +
//             groupId +
//             '&start=' +
//             date

class ParserDataSource {
  static late String groupId;
  static late String currentDate;

  static Future<List<LessonDayEntity>> getDayListLessonFull(
      {required url}) async {
    //List<LessonDayEntity> pageListDayLesson;

    // http.Response commonResponse = await http.get(
    //   Uri.parse('$urlNow$groupName'),
    // );

    // if (commonResponse.statusCode == 200) {
    //   List<Element> weekTr = _trueResponse(commonResponse);

    //   String nextRef = _getNextHref(weekTr);
    //   print(nextRef);
    //   String backRef = _getBackHref(weekTr);
    //   print(backRef);

    // pageListDayLesson= await _parserPage(url);

    // switch (action) {
    //   case ActionEvent.now:
    //     pageListDayLesson = await _parserPage(urlNow + groupName);
    //     break;
    //   case ActionEvent.next:
    //     pageListDayLesson = await _parserPage(baseUrl + nextRef);
    //     break;
    //   case ActionEvent.back:
    //     pageListDayLesson = await _parserPage(baseUrl + backRef);
    //     break;
    //   default:
    //     pageListDayLesson = _createEmptyListDay();
    //     break;
    // }
    // return pageListDayLesson;
    return await _parserPage(url);
  }

  static String _getNextHref(List<Element> weekTr) {
    var header =
        weekTr[0].getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
    String headerStringRight =
        header.getElementsByTagName('a')[1].attributes.values.toString();
    return headerStringRight.substring(1, headerStringRight.length - 1);
  }

  static String _getBackHref(List<Element> weekTr) {
    var header =
        weekTr[0].getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
    String headerStringLeft =
        header.getElementsByTagName('a')[0].attributes.values.toString();
    return headerStringLeft.substring(1, headerStringLeft.length - 1);
  }

  static List<LessonDayEmptyModel> _createEmptyListDay() {
    List<LessonDayEmptyModel> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(
          LessonDayEmptyModel(weekLabel: _createWeekLabel(i), dateTime: ''));
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

  static List<LessonDayEntity> _initPage(List<LessonDayEntity> dayList) {
    List<LessonDayEntity> pageList = [];
    for (int i = 0; i < 6; i++) {
      pageList.add(
          LessonDayEmptyModel(weekLabel: _createWeekLabel(i), dateTime: ''));
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

  static Future<List<LessonDayEntity>> _parserPage(String url) async {
    List<LessonDayEntity> pageListDayLesson;

    http.Response response = await http.get(Uri.parse(url));
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
      String groupId = headerStrinId.substring(11, 15);
      String currentDate = headerStrinId.substring(
          headerStrinId.length - 11, headerStrinId.length - 1);
      return Future.value([groupId, currentDate]);
    } else
      throw ServerException();
  }

  static List<Element> _trueResponse(http.Response response) {
    var document = parse(response.body);
    var tableWeek =
        document.getElementsByClassName('mpei-galaktika-lessons-grid-tbl')[0];
    return tableWeek
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr');
  }
}
