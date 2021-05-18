import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_event.dart';
import 'package:mpeischedule/bloc/authShedule/auth_state.dart';
import 'package:mpeischedule/feature/presentation/pages/lesson_day_page.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/bloc/authShedule/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage();

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginState) {
          return LessonDayPage(state.nameGroup);
        } else {
          final AuthBloc authBloc = BlocProvider.of(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30),
                child: TextField(
                  style: TextStyle(color: Theme.of(context).accentColor),
                  textAlign: TextAlign.center,
                  cursorHeight: 12,
                  textCapitalization: TextCapitalization.characters,
                  controller: _controller,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    helperStyle:
                        TextStyle(color: Theme.of(context).accentColor),
                    hintStyle: TextStyle(color: Theme.of(context).accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 2.0),
                    ),
                    labelText: S.of(context).input_name_group_label,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () async {
                    var nameGroup = _controller.text.toString();
                    authBloc.add(LoginEvent(nameGroup));
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString('group', nameGroup);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor)),
                  child: Text(
                    S.of(context).landing_btn_label,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
