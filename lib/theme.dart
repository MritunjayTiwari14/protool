import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    primary: Color.fromARGB(255, 104, 73, 250),
    onPrimary: Colors.white,

    secondary: Color(0xFF03DAC6),
    onSecondary: Colors.black,

    surface: Colors.white,
    onSurface: Color(0xFF121212),

    error: Color(0xFFB00020),
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF6200EE),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6200EE),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,

    primary: Color.fromARGB(255, 104, 73, 250),
    onPrimary: Colors.black,

    secondary: Color(0xFF03DAC6),
    onSecondary: Colors.black,

    surface: Colors.black,
    onSurface: Colors.white,

    error: Color(0xFFCF6679),
    onError: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 104, 73, 250),
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 104, 73, 250),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
