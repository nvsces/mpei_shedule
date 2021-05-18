abstract class SheduleEvent {}

class SheduleLoadEvent extends SheduleEvent {
  DateTime date;
  String namrGroup;
  SheduleLoadEvent({required this.namrGroup, required this.date});
}

class SheduleNextEvent extends SheduleEvent {
  String namrGroup;
  DateTime date;
  SheduleNextEvent({required this.namrGroup, required this.date});
}

class SheduleBackEvent extends SheduleEvent {
  String namrGroup;
  DateTime date;
  SheduleBackEvent({required this.namrGroup, required this.date});
}
