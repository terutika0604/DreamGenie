import 'package:flutter/material.dart';

class AppTheme {
  static const seedColor = Colors.deepPurple;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor, brightness: Brightness.light),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
    useMaterial3: true,
  );
}
