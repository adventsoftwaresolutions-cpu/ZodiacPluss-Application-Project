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

        scaffoldBackgroundColor: const Color(0xFFF7F9EF),

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

        scaffoldBackgroundColor: const Color(0xFF08120D),

        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryVariant,
          secondary: AppColors.secondaryVariant,

          surface: Color(0xFF102019),

          error: AppColors.error,

          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
      );
}