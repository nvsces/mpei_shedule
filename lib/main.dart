import 'package:flutter/material.dart';
import 'package:mpeischedule/feature/data/datasources/parser_data_source.dart';
import 'package:mpeischedule/ui/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/authShedule/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var nameGroup = preferences.getString('group') ?? "";
  AuthState state;

  if (nameGroup.isEmpty) {
    state = NotLogginState();
  } else {
    state = LoginState(nameGroup);
    ParserDataSource.inizializate(nameGroup);
  }
  runApp(HomePage(state));
}
