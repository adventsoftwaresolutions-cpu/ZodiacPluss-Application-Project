import 'package:flutter/material.dart';

sealed class AppColors {
  AppColors._();

  // =========================
  // Brand — distinct from zp_client per your call
  // =========================

  static const Color primary = Color(0xFF007D88);
  static const Color primaryVariant = Color(0xFF0F848E);

  static const Color secondary = Color(0xFFE8EBE4);
  static const Color secondaryVariant = Color(0xFFFBFBFB);

  // =========================
  // Neutrals
  // =========================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color separatorLight = Color(0x1A000000);
  static const Color separatorDark = Color(0x26FFFFFF);

  // =========================
  // Semantic
  // =========================

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF42A5F5);

  // =========================
  // Gradients
  // =========================

  static const LinearGradient topBarGradient = LinearGradient(
    colors: <Color>[primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}