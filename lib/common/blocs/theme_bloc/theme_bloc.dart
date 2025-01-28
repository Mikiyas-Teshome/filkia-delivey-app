import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../themes/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(Brightness systemBrightness)
      : super(systemBrightness == Brightness.dark
            ? DarkThemeState(AppTheme.getDarkTheme(), isSystemDefault: true)
            : LightThemeState(AppTheme.getLightTheme(),
                isSystemDefault: true)) {
    on<ToggleThemeEvent>((event, emit) {
      if (state is LightThemeState) {
        emit(DarkThemeState(AppTheme.getDarkTheme(), isSystemDefault: false));
      } else {
        emit(LightThemeState(AppTheme.getLightTheme(), isSystemDefault: false));
      }
    });

    on<SystemThemeChangedEvent>((event, emit) {
      // Respect system theme if app is in system default mode.
      if (state.isSystemDefault) {
        if (event.systemBrightness == Brightness.dark) {
          emit(DarkThemeState(AppTheme.getDarkTheme(), isSystemDefault: true));
        } else {
          emit(
              LightThemeState(AppTheme.getLightTheme(), isSystemDefault: true));
        }
      }
    });
  }
}
