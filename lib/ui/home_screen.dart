import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mpeischedule/bloc/auth_bloc.dart';
import 'package:mpeischedule/bloc/auth_event.dart';
import 'package:mpeischedule/bloc/auth_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/ui/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  AuthState authState;
  HomePage(this.authState, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkTheme = false;

  Widget iconExit(BuildContext context) {
    AuthBloc authBlocC = BlocProvider.of(context);
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () async {
          authBlocC.add(ExitEvent());
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove('group');
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(widget.authState),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return MaterialApp(
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  title: Text('Расписание'),
                  actions: [
                    iconExit(context),
                    Icon(_getAppBarIcon()),
                    CupertinoSwitch(
                      value: _darkTheme,
                      onChanged: (bool value) {
                        setState(() {
                          _darkTheme = !_darkTheme;
                        });
                      },
                    )
                  ],
                ),
                body: LandingPage(),
              ));
        }));
  }

  _getAppBarIcon() {
    if (!_darkTheme) {
      return Icons.lightbulb_outline;
    } else {
      return Icons.highlight;
    }
  }
}
