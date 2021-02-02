import 'package:mpeischedule/models/mail_header.dart';

import 'mail_parser.dart';

class MailProvider {
  Future<List<MailHeader>> getListHeader() {
    return MailParser.getListHeader();
  }

  Future<List<String>> getListText(List<String> ref) async {
    List<String> listText = [];
    for (int i = 0; i < ref.length; i++) {
      String text = await getText(ref[i]);
      listText.add(text);
    }

    return listText;
  }

  Future<List<String>> getListRef() async {
    return MailParser.getListRef();
  }

  Future<String> getText(String refUrl) {
    return MailParser.getText(refUrl);
  }
}
