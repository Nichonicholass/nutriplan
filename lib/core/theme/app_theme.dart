import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Nunito',
      textTheme: _buildTextTheme(isLight: false),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito',
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textLight,
      ),
      fontFamily: 'Nunito',
      textTheme: _buildTextTheme(isLight: true),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito',
        ),
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textLightSecondary),
        hintStyle: const TextStyle(color: AppColors.textLightSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLightSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static TextTheme _buildTextTheme({required bool isLight}) {
    final baseColor = isLight ? AppColors.textLight : AppColors.textPrimary;
    final secondaryColor = isLight ? AppColors.textLightSecondary : AppColors.textSecondary;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: baseColor, fontFamily: 'Nunito'),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: baseColor, fontFamily: 'Nunito'),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: baseColor, fontFamily: 'Nunito'),
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: baseColor, fontFamily: 'Nunito'),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: baseColor, fontFamily: 'Nunito'),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: baseColor, fontFamily: 'Nunito'),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: baseColor, fontFamily: 'Nunito'),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: baseColor, fontFamily: 'Nunito'),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: secondaryColor, fontFamily: 'Nunito'),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: baseColor, fontFamily: 'Nunito'),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: baseColor, fontFamily: 'Nunito'),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondaryColor, fontFamily: 'Nunito'),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: baseColor, fontFamily: 'Nunito'),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: secondaryColor, fontFamily: 'Nunito'),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: secondaryColor, fontFamily: 'Nunito'),
    );
  }
}
