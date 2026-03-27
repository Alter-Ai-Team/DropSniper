import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF121212);
  static const card = Color(0xFF1E1E1E);
  static const neonGreen = Color(0xFF39FF14);
  static const crimson = Color(0xFFDC143C);
  static const accentBlue = Color(0xFF00E5FF);
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accentBlue,
      secondary: AppColors.neonGreen,
      error: AppColors.crimson,
      surface: AppColors.card,
    ),
  );
}
