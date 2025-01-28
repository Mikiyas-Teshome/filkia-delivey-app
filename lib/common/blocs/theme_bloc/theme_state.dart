part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {
  final ThemeData themeData;
  final bool isSystemDefault; // True if following the system theme.

  const ThemeState(this.themeData, this.isSystemDefault);
}

class LightThemeState extends ThemeState {
  LightThemeState(ThemeData themeData, {bool isSystemDefault = false})
      : super(themeData, isSystemDefault);
}

class DarkThemeState extends ThemeState {
  DarkThemeState(ThemeData themeData, {bool isSystemDefault = false})
      : super(themeData, isSystemDefault);
}
