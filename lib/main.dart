import 'package:flutter/material.dart';
import 'package:mpeischedule/bloc/auth_state.dart';
import 'package:mpeischedule/common/fetch_http.dart';
import 'package:mpeischedule/ui/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  runApp(HomePage(state));
}
