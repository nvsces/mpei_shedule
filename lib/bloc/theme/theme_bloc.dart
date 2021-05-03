import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpeischedule/bloc/theme/theme_evemt.dart';
import 'package:mpeischedule/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(false));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeLightEvent) {
      event.themeAdaptiv.setLight();
      yield ThemeState(false);
    }
    if (event is ThemeDarkEvent) {
      event.themeAdaptiv.setDark();
      yield ThemeState(true);
    }
  }
}
