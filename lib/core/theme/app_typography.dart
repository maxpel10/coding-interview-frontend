import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme(TextTheme base) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      displaySmall: inter.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: inter.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      bodyLarge: inter.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 22,
        height: 1.2,
      ),
      bodyMedium: inter.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.35,
      ),
      bodySmall: inter.bodySmall?.copyWith(
        color: AppColors.textMuted,
        fontSize: 14,
        height: 1.35,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        fontSize: 11,
        color: AppColors.textSecondary,
      ),
      labelLarge: inter.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.primaryOn,
      ),
    );
  }
}
