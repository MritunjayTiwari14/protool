import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.redditSans().fontFamily,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    primary: Color.fromARGB(255, 104, 73, 250),
    onPrimary: Colors.white,

    secondary: Color.fromARGB(255, 104, 73, 250),
    onSecondary: Colors.black,

    surface: Colors.white,
    onSurface: Color(0xFF121212),

    error: Color(0xFFB00020),
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 104, 73, 250),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 104, 73, 250),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black, // Text and icon color
      backgroundColor: const Color.fromARGB(255, 104, 73, 250),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 104, 73, 250),
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.redditSans().fontFamily,
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
    backgroundColor: Colors.black,
    foregroundColor: Color.fromARGB(255, 104, 73, 250),
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 104, 73, 250),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 104, 73, 250), // Text and icon color for dark mode
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: Color.fromARGB(255, 104, 73, 250),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    )
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 104, 73, 250),
    foregroundColor: Colors.black,
    shape: CircleBorder()
  )
);
