import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.vertForet,
        primary: AppColors.vertForet,
        secondary: AppColors.vertNature,
        surface: AppColors.vertBg,
        onPrimary: AppColors.white,
      ),

      // Typographie : Playfair Display pour les titres, DM Sans pour le corps
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.noirDoux,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.vertForet,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.vertForet,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.noirDoux,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.grisTexte,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grisTexte,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.grisTexte,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.vertDoux,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.vertForet,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vertForet,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grisDoux),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grisDoux),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.vertForet, width: 2),
        ),
        hintStyle: GoogleFonts.dmSans(
          color: AppColors.grisTexte.withOpacity(0.5),
          fontSize: 14,
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      scaffoldBackgroundColor: AppColors.vertBg,
    );
  }

  AppTheme._();
}
