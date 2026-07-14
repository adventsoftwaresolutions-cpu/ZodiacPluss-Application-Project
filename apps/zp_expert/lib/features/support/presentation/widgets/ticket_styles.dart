import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';

abstract final class TicketStyles {
  static const TextStyle pageTitle = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle pageSubtitle = TextStyle(
    color: AppColors.white,
    fontSize: 12,
  );
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.ticketText,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle cardSubtitle = TextStyle(
    color: AppColors.mutedText,
    fontSize: 13,
    height: 1.35,
  );
  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.ticketText,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle optionalText = TextStyle(
    color: AppColors.mutedText,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle helperText = TextStyle(
    color: AppColors.mutedText,
    fontSize: 10,
    height: 1.2,
  );
  static const TextStyle uploadTitle = TextStyle(
    color: AppColors.mutedText,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle uploadSubtitle = TextStyle(
    color: AppColors.mutedText,
    fontSize: 11,
  );
  static const TextStyle statusTitle = TextStyle(
    color: AppColors.ticketText,
    fontWeight: FontWeight.w700,
    fontSize: 15,
  );
  static const TextStyle statusSubtitle = TextStyle(
    color: AppColors.mutedText,
    fontSize: 12,
  );
}
