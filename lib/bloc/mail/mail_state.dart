import 'package:flutter/foundation.dart';
import 'package:mpeischedule/models/mail_header.dart';

abstract class MailState {}

class MailFirstState extends MailState {}

class MailLoadingState extends MailState {}

class MailLoadedState extends MailState {
  List<MailHeader> listHeader;
  List<String> text;
  MailLoadedState({@required this.listHeader, @required this.text})
      : assert(listHeader != null);
}

class MailEmptyState extends MailState {}

class MailErrorState extends MailState {}
