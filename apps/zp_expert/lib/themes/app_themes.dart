import 'package:flutter/material.dart';

import 'app_colors.dart';

sealed class AppThemes {
  AppThemes._();

  // =========================
  // Light Theme
  // =========================
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.white,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
          onError: Colors.white,
        ),
        dividerColor: AppColors.separatorLight,
        dividerTheme: const DividerThemeData(
          color: AppColors.separatorLight,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black45,
          type: BottomNavigationBarType.fixed,
        ),
      );

  // =========================
  // Dark Theme
  // =========================
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryVariant,
          secondary: AppColors.secondaryVariant,
          surface: Color(0xFF1A1826),
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        dividerColor: AppColors.separatorDark,
        dividerTheme: const DividerThemeData(
          color: AppColors.separatorDark,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1826),
          selectedItemColor: AppColors.primaryVariant,
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
        ),
      );
}