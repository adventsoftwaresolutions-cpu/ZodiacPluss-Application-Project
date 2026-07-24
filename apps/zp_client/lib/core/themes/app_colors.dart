import 'package:flutter/material.dart';

sealed class AppColors {
  AppColors._();

  // =========================
  // Brand
  // =========================

  static const Color primary = Color(0xFFCFE8C1);
  static const Color primaryVariant = Color(0xFFA0C38B);

  static const Color secondary = Color(0xFF0080C6);
  static const Color secondaryVariant = Color(0xFF49BFFF);

  // =========================
  // Neutrals
  // =========================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color yellow = Color(0xFFFFD500);

  // =========================
  // Semantic
  // =========================

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF42A5F5);

  // =========================
  // Gradients
  // =========================

  static const LinearGradient topBarGradient = LinearGradient(
    colors: [
      primary,
      primaryVariant,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}