import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/theme/theme_event.dart';
import 'package:money_tracker/bloc/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: lightTheme, isDarkMode: false)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);

    add(LoadThemeEvent()); // Load theme when bloc is created
  }

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDarkMode") ?? false;
    emit(ThemeState(themeData: isDark ? darkTheme : lightTheme, isDarkMode: isDark));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newMode = !state.isDarkMode;
    final newTheme = newMode ? darkTheme : lightTheme;
    emit(ThemeState(themeData: newTheme, isDarkMode: newMode));

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", newMode);
  }
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.blueAccent),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[900]),
);