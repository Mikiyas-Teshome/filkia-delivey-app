import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber, // Primary color scheme
  primaryColor: Colors.amber, // Primary color for widgets like AppBar
  scaffoldBackgroundColor: Colors.white, // Background color
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // Text and icon colors for AppBar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.amber, // FAB background color
    foregroundColor: Colors.white, // FAB icon color
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF4BA00),
      foregroundColor: Colors.black,
    ),
  ),
  textTheme: GoogleFonts.interTextTheme(),

  dialogTheme: DialogTheme(
    backgroundColor: Colors.white, // Dialog background
    titleTextStyle: TextStyle(
      color: Colors.red.shade800, // Title text color
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.black87, // Content text color
      fontSize: 16.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners
    ),
  ),
  // textTheme: TextTheme(
  //   headlineSmall: TextStyle(
  //     fontWeight: FontWeight.bold,
  //     color: Colors.amber.shade800,
  //   ),
  // ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle:
        const TextStyle(color: Colors.amber), // Floating label color
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber.shade300, width: 1.5),
    ),
  ),
);
