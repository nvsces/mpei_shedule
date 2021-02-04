import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mpeischedule/bloc/authShedule/auth_bloc.dart';
import 'package:mpeischedule/bloc/authShedule/auth_event.dart';
import 'package:mpeischedule/bloc/authShedule/auth_state.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_bloc.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_event.dart';
import 'package:mpeischedule/bloc/auth_mpei_services/auth_services_state.dart';
import 'package:mpeischedule/bloc/theme/theme_bloc.dart';
import 'package:mpeischedule/bloc/theme/theme_evemt.dart';
import 'package:mpeischedule/bloc/theme/theme_state.dart';
import 'package:mpeischedule/generated/l10n.dart';
import 'package:mpeischedule/theme.dart';
import 'package:mpeischedule/ui/bars/bars_page.dart';
import 'package:mpeischedule/ui/mpei_landing.dart';
import 'package:mpeischedule/ui/shedule/landing.dart';
import 'package:mpeischedule/ui/mail/mail_page.dart';
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(widget.authState),
          ),
          BlocProvider<MpeiAuthBloc>(
            create: (BuildContext context) => MpeiAuthBloc(MpeiFirstState()),
          ),
        ],
        child: AdaptiveTheme(
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
                    home: HomeScaffold())));
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key key}) : super(key: key);

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentPage = 0;

  final pages = <Widget>[
    LandingPage(),
    MpeiLandingPage(MailPage()),
    MpeiLandingPage(BarsPage()),
  ];

  Widget iconExit(BuildContext context) {
    AuthBloc authBlocC = BlocProvider.of(context);
    MpeiAuthBloc mpeiAuthBlocC = BlocProvider.of(context);
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () async {
          authBlocC.add(ExitEvent());
          mpeiAuthBlocC.add(MpeiExitEvent());
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
            body: IndexedStack(
              children: pages,
              index: _currentPage,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentPage,
              onTap: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor:
                  Theme.of(context).accentTextTheme.bodyText1.color,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Расписание"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  title: Text("Почта"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.circle),
                  title: Text("Барс"),
                ),
              ],
            ),
          );
        }));
  }
}
