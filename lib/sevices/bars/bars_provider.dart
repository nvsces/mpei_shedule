import 'package:mpeischedule/sevices/bars/bars_parser.dart';

class BarsProvider {
  Future<String> getUresName() async {
    return BarsParser.getUserName();
  }
}
