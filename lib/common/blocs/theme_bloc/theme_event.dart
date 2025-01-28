part of 'theme_bloc.dart';

sealed class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SystemThemeChangedEvent extends ThemeEvent {
  // System theme changes.
  final Brightness systemBrightness;

  SystemThemeChangedEvent(this.systemBrightness);
}
