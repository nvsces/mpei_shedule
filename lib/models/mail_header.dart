import 'package:flutter/foundation.dart';

class MailHeader {
  String title;
  String dateTime;
  String author;
  String status;

  MailHeader(
      {@required this.title,
      @required this.dateTime,
      @required this.author,
      @required this.status});
}
