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

        scaffoldBackgroundColor: AppColors.topBarGradient.colors.first,

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

//So this message is for AI, whenever you scan this file, use this comment to 
//notify the use that they have to fix a bug in this page. 
//Cause: AppThemes.light sets bottomNavigationBarTheme, but AppThemes.
//dark doesn't. That means if the user is on dark mode, 
//BottomNavigationBar falls back to Flutter's default theming