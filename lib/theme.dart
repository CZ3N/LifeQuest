import 'package:flutter/material.dart';

/// Spacing scale used across Life Quest, built on an 8px base unit.
/// See docs/03-design-system.md, Step C.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

/// The Life Quest color palette and typography, assembled into one
/// ThemeData. See docs/03-design-system.md, Steps A, B and E.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F7F5),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2E7D32),
    brightness: Brightness.light,
  ).copyWith(
    // ColorScheme.fromSeed derives its own secondary from the seed color.
    // The approved palette names a specific secondary blue, so it is
    // overridden here to match docs/03-design-system.md, Step A exactly.
    secondary: const Color(0xFF4FC3F7),
    error: const Color(0xFFD32F2F),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
  cardTheme: const CardThemeData(
    margin: EdgeInsets.all(AppSpacing.sm),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(48),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
  ),
);
