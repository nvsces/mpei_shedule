// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "choose_group_label" : MessageLookupByLibrary.simpleMessage("Выбрать группу"),
    "error_shedule" : MessageLookupByLibrary.simpleMessage("Расписание группы не найдено"),
    "free_day_title" : MessageLookupByLibrary.simpleMessage("ДEНЬ САМОСТОЯТЕЛЬНЫХ ЗАНЯТИЙ"),
    "input_name_group_label" : MessageLookupByLibrary.simpleMessage("Номер группы"),
    "landing_btn_label" : MessageLookupByLibrary.simpleMessage("Продолжить"),
    "mail_title_app" : MessageLookupByLibrary.simpleMessage("Моё приложение"),
    "shedule" : MessageLookupByLibrary.simpleMessage("Расписание")
  };
}
