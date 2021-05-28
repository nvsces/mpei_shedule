import 'package:flutter/material.dart';
import 'package:mpeischedule/feature/presentation/pages/home_screen.dart';
import 'package:mpeischedule/locator_service.dart' as di;
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
  }
  await di.init();
  runApp(HomePage(state));
}
