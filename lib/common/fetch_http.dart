import 'dart:convert' show utf8;
import 'package:ffi/ffi.dart';
import 'package:html/dom.dart';
import 'dart:collection';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mpeischedule/models/day_lesson.dart';
import 'package:mpeischedule/models/lesson.dart';
import 'package:mpeischedule/models/mail_header.dart';
import 'package:mpeischedule/models/mail_message.dart';
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

void onClkRdMsg(oLnk, sT, iI, fC) {
  // stFrm();
  // var msgId = 0;
  // if (g_oFrm.chkmsg) {
  //   if (isNaN(g_oFrm.chkmsg.length))
  //     msgId = g_oFrm.chkmsg.value;
  //   else
  //     msgId = g_oFrm.chkmsg[iI].value;
  //   msgId = urlEnc(msgId);
  //   if ((msgId != 0) && (sT != "")) {
  //     var sHref = "";
  //     if (a_fIsJnkFld)
  //       sHref = "?ae=Item&id=" + msgId;
  //     else if (sT.indexOf("IPM.Appointment") == 0)
  //       sHref = "?ae=PreFormAction&a=Open&t=" + sT + "&id=" + msgId;
  //     else if (fC == 1)
  //       sHref = "?ae=Item&t=" + sT + "&a=Open&s=Draft&id=" + msgId;
  //     else
  //       sHref = "?ae=Item&t=" + sT + "&id=" + msgId;
  //     if (a_fWP) oLnk.target = "_blank";
  //     oLnk.href = sHref;
  //   }
  // }
}

// String urlEnc(String s) {
//   var out = Utf8.fromUtf8(s);
//   return out;
// }

void testMail() async {
  //'https://mail.mpei.ru/owa/?ae=Item&t=IPM.Note&id=RgAAAAAPjy5SY9aEQLCLwP8phAgIBwDObzvhn0pHQY6zDpXkxVixAGfZDOaVAADObzvhn0pHQY6zDpXkxVixAIsxrn2qAAAJ'
  //'https://mail.mpei.ru/owa/?ae=Item&t=IPM.Note&id=RgAAAAAPjy5SY9aEQLCLwP8phAgIBwDObzvhn0pHQY6zDpXkxVixAGfZDOaVAADObzvhn0pHQY6zDpXkxVixAIsxrn2pAAAJ'

  List<Map> mapList = [];
  List<String> listRef = [];
  String baseMsg =
      'RgAAAAAPjy5SY9aEQLCLwP8phAgIBwDObzvhn0pHQY6zDpXkxVixAGfZDOaVAADObzvhn0pHQY6zDpXkxVixAIsxrn2oAAAJ';

  Map<String, String> body = {
    'curl': 'Z2FowaZ2F',
    'forcedownlevel': '0',
    'formdir': '2',
    'username': 'ShanyginDS',
    'password': 'mit463u',
    'isUtf8': '1',
    'trusted': '4'
  };
  var r = await req.Requests.post('https://mail.mpei.ru/CookieAuth.dll?Logon',
      body: body);
  String bodyr = r.content();
  print(bodyr);
  r.raiseForStatus();
  var d = await req.Requests.get('https://mail.mpei.ru/owa/');
  String dbody = d.content();

  var document = parse(dbody);
  var table = document.getElementsByClassName('lvw')[0];
  var t2 = table.getElementsByTagName('tbody')[0];
  var lessonStroka = t2.getElementsByTagName('tr');
  lessonStroka.removeAt(0);
  lessonStroka.removeAt(0);
  lessonStroka.removeAt(0);

  List<MailHeader> mailHeader = [];
  int k = 3;
  for (int i = 0; i < lessonStroka.length; i++) {
    if (i != 0) k = 2;
    var lesson = lessonStroka[i].getElementsByTagName('td');
    List<String> listHeader = [];
    for (int j = 0; j < lesson.length; j++) {
      if (lesson[j].attributes.length < k) listHeader.add(lesson[j].text);
    }
    MailHeader header = MailHeader(
        title: listHeader[0], author: listHeader[1], dateTime: listHeader[2]);
    mailHeader.add(header);
  }

  print('финиш');

  var chckMsg = document.getElementsByTagName('input');
  chckMsg.forEach((element) {
    if (element.attributes['type'] == 'checkbox' &&
        element.attributes['name'] == 'chkmsg') {
      listRef.add(element.attributes['value']);
    }
  });
  //print(lesson.toString());
  String msgUrl = 'https://mail.mpei.ru/owa/?ae=Item&t=IPM.Note&id=';
  var msgResponse = await req.Requests.get(msgUrl + listRef[0]);
  var documentMsg = parse(msgResponse.content());
  var textMsg = documentMsg.getElementsByClassName('PlainText')[0];
  var el = textMsg.text;
  ////////////////////////////////////////////////
  // el.forEach((element) {
  //   print(element.text);
  // });
  // print(el);
  // mapList.forEach((element) {});
  // print(atr);
  print('finish');
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
