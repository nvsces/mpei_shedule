import 'package:adaptive_theme/adaptive_theme.dart';

abstract class ThemeEvent {}

class ThemeLightEvent extends ThemeEvent {
  AdaptiveThemeManager themeAdaptiv;
  ThemeLightEvent(this.themeAdaptiv);
}

class ThemeDarkEvent extends ThemeEvent {
  AdaptiveThemeManager themeAdaptiv;
  ThemeDarkEvent(this.themeAdaptiv);
}
