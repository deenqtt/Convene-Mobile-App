import 'package:flutter/material.dart';

/// Total height glass nav bar occupies from screen bottom.
/// Use this as minimum bottom padding on any scrollable/sheet content.
double navBarBottom(double safeAreaBottom) =>
    safeAreaBottom > 0 ? safeAreaBottom + 68 + 8 + 16 : 68 + 20 + 16;

class AppColors {
  static const background = Color(0xFF0D1117);
  static const surface    = Color(0xFF111827);
  static const card       = Color(0xFF1A2540);
  static const border     = Color(0x1AFFFFFF); // white/10
  static const blue       = Color(0xFF2563EB);
  static const blueLight  = Color(0xFF60A5FA);
  static const textPrimary   = Colors.white;
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted     = Color(0xFF374151);
  static const red        = Color(0xFFEF4444);
  static const green      = Color(0xFF22C55E);
}

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.blue,
    surface: AppColors.surface,
    background: AppColors.background,
  ),
  fontFamily: 'sans-serif',
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.card,
    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.blue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.blueLight,
    unselectedItemColor: AppColors.textSecondary,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
);
