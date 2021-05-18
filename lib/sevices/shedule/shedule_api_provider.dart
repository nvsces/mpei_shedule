import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:mpeischedule/common/fetch_http.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';

enum ActionEvent { next, back, now }

class SheduleProvider {
  List<DayLesson?> createEmptyListDay() {
    List<DayLesson?> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(null);
    }
    return list;
  }

  List<DayLesson?> initPage(List<DayLesson> dayList) {
    List<DayLesson?> pageList = [];
    for (int i = 0; i < 6; i++) {
      pageList.add(null);
    }
    for (int j = 0; j < dayList.length; j++) {
      switch (dayList[j].day) {
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

  Future<List<String>?> getGroupId({required String groupName}) async {
    Response commonResponse = await fetchHttpShedule(
        'https://mpei.ru/Education/timetable/Pages/default.aspx?group=' +
            groupName);
    if (commonResponse.statusCode == 200) {
      List<Element> weekTr = trueResponse(commonResponse);
      var header = weekTr[0]
          .getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
      String headerStrinId =
          header.getElementsByTagName('a')[1].attributes.values.toString();
      var groupId = headerStrinId.substring(11, 15);
      var currentDate = headerStrinId.substring(
          headerStrinId.length - 11, headerStrinId.length - 1);
      List<String> list = [];
      list.add(groupId);
      list.add(currentDate);
      return list;
    }
  }

  Future<List<DayLesson?>> dayListAction(String groupId, String date) async {
    List<DayLesson?> pageListDayLesson;
    Response response = await fetchHttpShedule(
        'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=' +
            groupId +
            '&start=' +
            date);
    if (response.statusCode == 200) {
      List<Element> weekTr = trueResponse(response);
      if (weekTr.length < 3) {
        print('CСессии нет');
        pageListDayLesson = createEmptyListDay();
        return pageListDayLesson;
      } else {
        List<DayLesson> dayList = getListDay(weekTr);
        pageListDayLesson = initPage(dayList);
        return pageListDayLesson;
      }
    } else {
      print('Status Code not 200');
      pageListDayLesson = createEmptyListDay();
      return pageListDayLesson;
    }
  }

  Future<List<DayLesson?>?> getDayListLessonFull(
      {required String groupId, required ActionEvent action}) async {
    List<DayLesson?>? pageListDayLesson;

    String urlNow =
        'https://mpei.ru/Education/timetable/Pages/default.aspx?group=';
    String baseUrl = 'https://mpei.ru/Education/timetable/Pages/table.aspx';

    Response commonResponse = await fetchHttpShedule(
        'https://mpei.ru/Education/timetable/Pages/default.aspx?group=' +
            groupId);

    if (commonResponse.statusCode == 200) {
      List<Element> weekTr = trueResponse(commonResponse);

      String nextRef = getNextHref(weekTr);
      String backRef = getBackHref(weekTr);

      switch (action) {
        case ActionEvent.now:
          pageListDayLesson = await testhttpparse(urlNow + groupId);
          break;
        case ActionEvent.next:
          pageListDayLesson = await testhttpparse(baseUrl + nextRef);
          break;
        case ActionEvent.back:
          pageListDayLesson = await testhttpparse(baseUrl + backRef);
          break;
        default:
          pageListDayLesson = createEmptyListDay();
          break;
      }
      return pageListDayLesson;
    } else {
      return null;
    }
  }

  Future<List<DayLesson?>?> testhttpparse(String urlhttp) async {
    List<DayLesson?> pageListDayLesson;

    Response response = await fetchHttpShedule(urlhttp);

    if (response.statusCode == 200) {
      List<Element> weekTr = trueResponse(response);
      if (weekTr.length < 3) {
        print('CСессии нет');
        pageListDayLesson = createEmptyListDay();
        return pageListDayLesson;
      } else {
        List<DayLesson> dayList = getListDay(weekTr);
        pageListDayLesson = initPage(dayList);
        return pageListDayLesson;
      }
    } else {
      print('Status Code not 200');
      pageListDayLesson = createEmptyListDay();
      return pageListDayLesson;
    }
  }

  List<Element> trueResponse(Response response) {
    var document = parse(response.body);
    var tableWeek =
        document.getElementsByClassName('mpei-galaktika-lessons-grid-tbl')[0];
    return tableWeek
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr');
  }

  String getNextHref(List<Element> weekTr) {
    var header =
        weekTr[0].getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
    final String headerStringRight =
        header.getElementsByTagName('a')[1].attributes.values.toString();
    final String hrefNext =
        headerStringRight.substring(1, headerStringRight.length - 1);

    return hrefNext;
  }

  String getBackHref(List<Element> weekTr) {
    var header =
        weekTr[0].getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
    String headerStringLeft =
        header.getElementsByTagName('a')[0].attributes.values.toString();
    String hrefBack =
        headerStringLeft.substring(1, headerStringLeft.length - 1);

    return hrefBack;
  }

  List<DayLesson> getListDay(List<Element> weekTr) {
    List<DayLesson> dayList = [];
    List<Lesson> listLesson = [];
    String dayWeek = "";

    for (int i = 1; i < weekTr.length; i++) {
      var iter =
          weekTr[i].getElementsByClassName('mpei-galaktika-lessons-grid-date');

      if (iter.length != 0) {
        if (i != 1) {
          var lessonList = copyListLesson(listLesson);
          dayList.add(DayLesson(
              dayWeek.substring(0, 2), dayWeek.substring(4), lessonList));
          listLesson.clear();
        }
        dayWeek = getDateFormat(weekTr[i]);
      } else {
        var lesson = getLesson(weekTr[i]);
        listLesson.add(lesson);
        if (i == weekTr.length - 1) {
          dayList.add(DayLesson(
              dayWeek.substring(0, 2), dayWeek.substring(4), listLesson));
        }
      }
    }
    return dayList;
  }

  List<Lesson> copyListLesson(List<Lesson> input) {
    List<Lesson> copylist = [];
    for (int i = 0; i < input.length; i++) {
      var lesson = Lesson(
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

  String getDateFormat(Element element) {
    return element.getElementsByTagName('td')[0].text;
  }

  Lesson getLesson(Element element) {
    var time = element.getElementsByTagName('td')[0].text;
    var channel =
        element.getElementsByTagName('td')[1].getElementsByTagName('span');
    String name = channel[0].text.toString();
    String type = channel[1].text.toString();
    String auditorium = channel[2].text.toString();
    String group = channel[3].text.toString();
    String lector = channel[4].text.toString();

    return Lesson(
        name: name,
        type: type,
        auditorium: auditorium,
        group: group,
        lecturer: lector,
        time: time);
  }
}
