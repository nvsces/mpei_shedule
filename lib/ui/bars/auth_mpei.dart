import 'package:flutter/material.dart';
import 'package:mpeischedule/sevices/bars_parser.dart';
import 'package:mpeischedule/sevices/mail_parser.dart';
import 'package:mpeischedule/ui/bars/bars_page.dart';
import 'package:mpeischedule/ui/bars/bars_scaffold.dart';

class AuthMpei extends StatelessWidget {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwirdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () async {
                bool succes = await BarsParser.init(
                    _loginController.text, _passwirdController.text);
                if (succes) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => BarsScaffold()));
                }
              },
              textColor: Colors.white,
              child: Text('Войти')),
        ),
      ],
    );
  }
}
