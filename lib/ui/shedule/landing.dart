import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_event.dart';
import 'package:mpeischedule/bloc/authShedule/auth_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/ui/shedule/home_body_bloc.dart';
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
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoginState) {
        return BodyBloc(state.nameGroup);
      } else {
        final AuthBloc authBloc = BlocProvider.of(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                textAlign: TextAlign.center,
                cursorHeight: 12,
                textCapitalization: TextCapitalization.characters,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: S.of(context).input_name_group_label,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: RaisedButton(
                onPressed: () async {
                  var nameGroup = _controller.text.toString();
                  authBloc.add(LoginEvent(nameGroup));
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('group', nameGroup);
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(S.of(context).landing_btn_label,
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
