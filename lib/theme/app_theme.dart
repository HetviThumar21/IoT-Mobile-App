import 'dart:ui';
import 'package:flutter/material.dart';

class AppTheme {
  // 🌞 LIGHT MODE (lavender / off-white / premium)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF2F3FF),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6D6AF6),
      secondary: Color(0xFF8B88FF),
      surface: Color(0xFFF6F7FF),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1B1B2F),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF4B4B6A),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6D6AF6),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Color(0x556D6AF6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  // 🌙 DARK MODE (glassy / deep lavender)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0E1026),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C7AFF),
      secondary: Color(0xFF9C9AFF),
      surface: Color(0xFF1A1C3A),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7C7AFF),
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: Color(0x557C7AFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
