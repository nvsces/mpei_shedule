import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mpeischedule/bloc/auth/auth_bloc.dart';
import 'package:mpeischedule/bloc/auth/auth_event.dart';
import 'package:mpeischedule/bloc/auth/auth_state.dart';
import 'package:mpeischedule/bloc/theme/theme_bloc.dart';
import 'package:mpeischedule/bloc/theme/theme_evemt.dart';
import 'package:mpeischedule/bloc/theme/theme_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/theme.dart';
import 'package:mpeischedule/ui/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  AuthState authState;
  HomePage(this.authState, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(widget.authState),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return AdaptiveTheme(
              light: kLightTheme,
              dark: kDarkTheme,
              initial: AdaptiveThemeMode.dark,
              builder: (light, dark) => MaterialApp(
                      localizationsDelegates: [
                        S.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: S.delegate.supportedLocales,
                      darkTheme: dark,
                      theme: light,
                      home: HomeScaffold()));
        }));
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({Key key}) : super(key: key);

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

  _getAppBarIcon(bool darkTheme) {
    if (!darkTheme) {
      return Icons.lightbulb_outline;
    } else {
      return Icons.highlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
          final ThemeBloc themeBloc = BlocProvider.of(context);
          final themeAdaptiv = AdaptiveTheme.of(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black54,
              title: Text('Расписание'),
              actions: [
                iconExit(context),
                Icon(_getAppBarIcon(state.isDarkTheme)),
                CupertinoSwitch(
                  value: state.isDarkTheme,
                  onChanged: (bool value) {
                    if (state.isDarkTheme) {
                      themeBloc.add(ThemeLightEvent(themeAdaptiv));
                    } else {
                      themeBloc.add(ThemeDarkEvent(themeAdaptiv));
                    }
                  },
                )
              ],
            ),
            body: LandingPage(),
          );
        }));
  }
}
