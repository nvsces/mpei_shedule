import 'package:flutter/foundation.dart';
import 'package:mpeischedule/models/mail_header.dart';

class MailMessage {
  MailHeader header;
  String text;

  MailMessage(@required this.header, @required this.text);
}
