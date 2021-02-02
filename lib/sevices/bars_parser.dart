import 'package:html/parser.dart';
import 'package:requests/requests.dart' as req;

class BarsParser {
  //очистить куки .clearStoredCookies(hostname)

  static Future<bool> init(String login, String password) async {
    //'ShanyginDS'
    //'mit463u'
    Map<String, String> body = {'UserName': login, 'Password': password};
    var r =
        await req.Requests.post('https://bars.mpei.ru/bars_web/', body: body);
    //get('https://google.com');
    r.raiseForStatus();
    var d = await req.Requests.get('https://bars.mpei.ru/bars_web/');
    String dbody = d.content();

    var document = parse(dbody);
    var tableWeek = document.getElementsByClassName('font-weight-bold');
    String text = "";
    if (tableWeek.length > 0) {
      text = tableWeek[0].text;
    }
    if (text.isNotEmpty)
      return true;
    else
      return false;
  }

  static Future<String> getUserName() async {
    var d = await req.Requests.get('https://bars.mpei.ru/bars_web/');
    String dbody = d.content();

    var document = parse(dbody);
    var tableWeek = document.getElementsByClassName('font-weight-bold');
    String text = "Пусто";
    if (tableWeek.length > 0) {
      text = tableWeek[0].text;
    }

    return text;
  }
}
