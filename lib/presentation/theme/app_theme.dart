import 'package:flutter/material.dart';

//Light Theme 

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blueGrey.shade100,
    secondary: Colors.blueGrey.shade600,
    onSecondary: Colors.white,
    tertiary: Colors.blueGrey.shade200,
    inversePrimary: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blueGrey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.blueGrey.shade600,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blueGrey.shade500,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blueGrey.shade600,
        width: 2.0,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.blueGrey.shade600,
    ),
  ),
);

// Dark theme
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.teal.shade400,
    onSecondary: Colors.black,
    tertiary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade400,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade900,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.teal.shade400,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.teal.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.teal.shade400,
        width: 2.0,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.teal.shade400,
    ),
  ),
);
