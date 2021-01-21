import 'package:flutter/foundation.dart';

abstract class SheduleEvent {}

class SheduleLoadEvent extends SheduleEvent {
  String namrGroup;
  SheduleLoadEvent({@required this.namrGroup});
}

class SheduleNextEvent extends SheduleEvent {
  String namrGroup;
  String date;
  SheduleNextEvent({@required this.namrGroup, @required this.date});
}

class SheduleBackEvent extends SheduleEvent {
  String namrGroup;
  String date;
  SheduleBackEvent({@required this.namrGroup, @required this.date});
}
