  import 'package:flutter/material.dart';
// Light theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade600, // Button background color
    onSecondary: Colors.black, // Button text color for selected state
    tertiary: Colors.grey.shade400, // Unselected button background
    inversePrimary: Colors.black, // Text color for unselected state
  ),
);

// Dark theme
  // Dark theme
  ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade800,
      tertiary: Colors.grey.shade600, // Unselected button background
      onSecondary: Colors.white, // Selected button text color
    ),
  );