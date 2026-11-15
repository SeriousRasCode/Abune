import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF12324A);
  static const gold = Color(0xFFC79A39);
  static const burgundy = Color(0xFF7B3438);
  static const parchment = Color(0xFFF8F4EA);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      brightness: brightness,
      primary: dark ? const Color(0xFFB6D5E8) : navy,
      secondary: dark ? const Color(0xFFE8C777) : burgundy,
      surface: dark ? const Color(0xFF172735) : const Color(0xFFFFFDF8),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? const Color(0xFF0F1B26) : parchment,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? const Color(0xFF14283A) : navy,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: dark ? const Color(0xFF3D5263) : const Color(0xFFE4D9C3),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: dark ? const Color(0xFF34566D) : const Color(0xFFE8DFC9),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
    );
  }
}
