import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_event.dart';

class AuthMpei extends StatelessWidget {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwirdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MpeiAuthBloc mpeiAuthBloc = BlocProvider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            textAlign: TextAlign.center,
            cursorHeight: 12,
            textCapitalization: TextCapitalization.characters,
            controller: _loginController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Логин",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            textAlign: TextAlign.center,
            cursorHeight: 12,
            textCapitalization: TextCapitalization.characters,
            controller: _passwirdController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Пароль",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30),
          child: RaisedButton(
              onPressed: () {
                mpeiAuthBloc.add(MpeiLoginEvent(
                    _loginController.text, _passwirdController.text));
              },
              textColor: Colors.white,
              child: Text('Войти')),
        ),
      ],
    );
  }
}
