import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../contants/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber, // Primary color scheme
  primaryColor: Colors.amber, // Primary color for widgets like AppBar
  scaffoldBackgroundColor: Colors.black54, // Dark background color
  appBarTheme: const AppBarTheme(
    backgroundColor: AppConstants.darkBgColor, // AppBar background color
    // foregroundColor: Colors.black, // Text and icon colors for AppBar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.amber, // FAB background color
    foregroundColor: Colors.black, // FAB icon color
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey.shade900, // Dialog background
    titleTextStyle: TextStyle(
      color: Colors.amber.shade300, // Title text color
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.white70, // Content text color
      fontSize: 16.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners
    ),
  ),
  textTheme: GoogleFonts.interTextTheme().apply(
    bodyColor: Colors.white, // Text color for body
    displayColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle:
        TextStyle(color: Colors.amber.shade300), // Floating label color
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber.shade300, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber.shade600, width: 1.5),
    ),
  ),
);
