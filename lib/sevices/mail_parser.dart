import 'package:html/parser.dart';
import 'package:mpeischedule/models/mail_header.dart';
import 'package:requests/requests.dart' as req;

class MailParser {
  static Future<bool> init(String login, String password) async {
    //'ShanyginDS'
    //'mit463u'

    Map<String, String> body = {
      'curl': 'Z2FowaZ2F',
      'forcedownlevel': '0',
      'formdir': '2',
      'username': login,
      'password': password,
      'isUtf8': '1',
      'trusted': '4'
    };
    var r = await req.Requests.post('https://mail.mpei.ru/CookieAuth.dll?Logon',
        body: body);
    r.raiseForStatus();

    var d = await req.Requests.get('https://mail.mpei.ru/owa/');

    if (d.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<List<MailHeader>> getListHeader() async {
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
      // if (i != 0) k = 2;
      // var lesson = lessonStroka[i].getElementsByTagName('td');
      // List<String> listHeader = [];
      // for (int j = 0; j < lesson.length; j++) {
      //   if (lesson[j].attributes.length < k) listHeader.add(lesson[j].text);
      // }
      // MailHeader header = MailHeader(
      //     title: listHeader[0], author: listHeader[1], dateTime: listHeader[2]);
      // mailHeader.add(header);
      //------------
      var lesson = lessonStroka[i].getElementsByTagName('td');
      var messageIm = lesson[1].getElementsByClassName('sI')[0];
      var image = messageIm.attributes;
      var status = image['alt'];
      MailHeader header = MailHeader(
          title: lesson[4].text,
          author: lesson[5].text,
          dateTime: lesson[6].text,
          status: status);
      mailHeader.add(header);
    }

    return mailHeader;
  }

  static Future<List<String>> getListRef() async {
    List<String> listRef = [];
    var d = await req.Requests.get('https://mail.mpei.ru/owa/');
    String dbody = d.content();

    var document = parse(dbody);

    var chckMsg = document.getElementsByTagName('input');
    chckMsg.forEach((element) {
      if (element.attributes['type'] == 'checkbox' &&
          element.attributes['name'] == 'chkmsg') {
        listRef.add(element.attributes['value']);
      }
    });

    return listRef;
  }

  static Future<String> getText(String urlRef) async {
    String msgUrl = 'https://mail.mpei.ru/owa/?ae=Item&t=IPM.Note&id=';
    var msgResponse = await req.Requests.get(msgUrl + urlRef);
    var documentMsg = parse(msgResponse.content());
    var textMsg = documentMsg.getElementsByClassName('PlainText');
    if (textMsg.length > 0) {
      var textAwait = textMsg[0];
      [0];
      var el = textAwait.text;
      return el;
    } else
      return "";
  }
}
