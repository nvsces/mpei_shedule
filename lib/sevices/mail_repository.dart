import 'package:mpeischedule/models/mail_header.dart';
import 'package:mpeischedule/sevices/mail_api_provider.dart';
import 'package:mpeischedule/sevices/mail_parser.dart';

class MailRepository {
  MailProvider _mailProvider = MailProvider();

  Future<List<MailHeader>> getListHeader() {
    return _mailProvider.getListHeader();
  }

  Future<List<String>> getListRef() {
    return _mailProvider.getListRef();
  }

  Future<List<String>> getListText(List<String> ref) {
    return _mailProvider.getListText(ref);
  }

  Future<String> getText(String refUrl) {
    return _mailProvider.getText(refUrl);
  }
}
