import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';
import 'package:requests/requests.dart' as req;

fetchHttpShedule(String url) {
  //ar client = http.Client();
  return http.get(Uri.parse(url));
}

List<DayLesson> initPage(List<DayLesson> dayList) {
  List<DayLesson> pageList = [];
  for (int i = 0; i < 7; i++) {
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
  print(pageList.length);
  for (int j = 0; j < pageList.length; j++) {
    if (pageList[j] != null) {
      print('$j:${pageList[j].date}');
    } else {
      print('null');
    }
  }

  return pageList;
}

void testWeb() async {
  //'https://mpei.ru/Education/timetable/Pages/default.aspx?group=ЭР-14-17'
  print('responce');
  Map<String, String> body = {'UserName': 'ShanyginDS', 'Password': 'mit463u'};
  var r = await req.Requests.post('https://bars.mpei.ru/bars_web/', body: body);
  //get('https://google.com');
  r.raiseForStatus();
  var d = await req.Requests.get('https://bars.mpei.ru/bars_web/');
  String dbody = d.content();
  String bodyr = r.content();
  print(bodyr);

  var document = parse(dbody);
  var tableWeek = document.getElementsByClassName('font-weight-bold')[0].text;

  var lesson = document.getElementsByClassName('my-2');
  lesson.forEach((element) {
    print(element.text);
  });

  print(lesson);
  //var name = tableWeek.getElementsByTagName('span')[0].text;
  print(tableWeek);
  // Response response =
  //     await http.post(Uri.parse('https://bars.mpei.ru/bars_web/'), body: body);

  // print(response);
  // if (response.statusCode == 302) {
  //   Response getResponse = await http.get(Uri.parse(
  //       'https://bars.mpei.ru/bars_web/UserName=ShanyginDS&Password=mit463u'));

  //   print(getResponse.body);

  //   print(response.body);
  // } else {
  //   print('error');
}

Future<List<DayLesson>> testhttpparse() async {
  List<DayLesson> pageListDayLesson;
  Response response = await fetchHttpShedule(
      'https://mpei.ru/Education/timetable/Pages/table.aspx?groupoid=9494&start=2020.12.28');
  print(response);
  if (response.statusCode == 200) {
    List<Element> weekTr = trueResponse(response);

    if (weekTr.length < 3) {
      print('CСессии нет');
    } else {
      List<DayLesson> dayList = getListDay(weekTr);
      print(dayList[0].day);
      pageListDayLesson = initPage(dayList);

      // print(weekTr);
      // print('Количество дней ${dayList.length}');
      // print(dayList[1].day);
      // print(dayList[1].date);
      return pageListDayLesson;
    }
  } else {
    print('Status Code not 200');
    return null;
  }
}

List<Element> trueResponse(Response response) {
  var document = parse(response.body);
  var tableWeek =
      document.getElementsByClassName('mpei-galaktika-lessons-grid-tbl')[0];
  return tableWeek.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
}

List<DayLesson> getListDay(List<Element> weekTr) {
  var header =
      weekTr[0].getElementsByClassName('mpei-galaktika-lessons-grid-nav')[0];
  String headerStringLeft =
      header.getElementsByTagName('a')[0].attributes.values.toString();
  String headerStringRight =
      header.getElementsByTagName('a')[1].attributes.values.toString();
  var href_back = headerStringLeft.substring(1, headerStringLeft.length - 1);
  var href_next = headerStringRight.substring(1, headerStringRight.length - 1);

  //day

  List<DayLesson> dayList = [];
  List<Lesson> listLesson = [];
  String dayWeek = "";

  for (int i = 1; i < weekTr.length; i++) {
    var iter =
        weekTr[i].getElementsByClassName('mpei-galaktika-lessons-grid-date');
    print(iter);

    if (iter.length != 0) {
      if (i != 1) {
        dayList.add(DayLesson(
            dayWeek.substring(0, 2), dayWeek.substring(4), listLesson));
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
