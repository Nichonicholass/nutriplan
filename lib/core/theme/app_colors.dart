import 'package:flutter/material.dart';

class AppColors {
  AppColors._();


  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D6);

  static const Color secondary = Color(0xFF00D9A3);
  static const Color secondaryLight = Color(0xFF00F5B9);
  static const Color secondaryDark = Color(0xFF00A87E);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentYellow = Color(0xFFFFC947);


  static const Color darkBg = Color(0xFF0D0D1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkCardElevated = Color(0xFF1F2A4A);
  static const Color darkBorder = Color(0xFF2A2A4A);
  static const Color darkDivider = Color(0xFF1E1E3A);


  static const Color lightBg = Color(0xFFF8F7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E6FF);
  static const Color lightDivider = Color(0xFFF0EEF8);


  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0ADCC);
  static const Color textMuted = Color(0xFF6B6897);
  static const Color textLight = Color(0xFF1A1A2E);
  static const Color textLightSecondary = Color(0xFF5A577A);


  static const Color success = Color(0xFF00D9A3);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF5757);
  static const Color info = Color(0xFF4FC3F7);


  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D9A3), Color(0xFF00A87E)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F43), Color(0xFFFF6B6B)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F2A4A), Color(0xFF16213E)],
  );


  static const Map<String, Color> goalColors = {
    'Bulking': Color(0xFFFF9F43),
    'Cutting': Color(0xFF6C63FF),
    'Healthy Lifestyle': Color(0xFF00D9A3),
    'Stunting Prevention': Color(0xFFFF6B6B),
    'Diabetes Friendly': Color(0xFF4FC3F7),
  };


  static const Color calorieColor = Color(0xFFFF9F43);
  static const Color proteinColor = Color(0xFF6C63FF);
  static const Color carbsColor = Color(0xFF00D9A3);
  static const Color fatColor = Color(0xFFFF6B6B);
}
