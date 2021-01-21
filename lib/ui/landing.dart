import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/auth_bloc.dart';
import 'package:mpeischedule/bloc/auth_event.dart';
import 'package:mpeischedule/bloc/auth_state.dart';
import 'package:mpeischedule/ui/home_body_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController _controller = TextEditingController();

  // Stream<String> getGroup() {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var nameGroup = pref.getString('group') ?? "";
  //   return nameGroup;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoginState) {
        return BodyBloc(state.nameGroup);
      } else {
        final AuthBloc authBloc = BlocProvider.of(context);
        return Container(
            child: Center(
                child: Column(
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              cursorHeight: 12,
              textCapitalization: TextCapitalization.characters,
              controller: _controller,
              //obscureText: true,
              decoration: InputDecoration(
                // border: OutlineInputBorder(),
                labelText: 'Номер группы',
              ),
            ),
            RaisedButton(
              onPressed: () async {
                var nameGroup = _controller.text.toString();
                authBloc.add(LoginEvent(nameGroup));
                SharedPreferences pref = await SharedPreferences.getInstance();
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
                child: const Text('Продолжить', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        )));
      }
    });
  }
}
