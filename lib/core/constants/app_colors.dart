import 'package:flutter/material.dart';

class AppColors {
  // === PALETTE PRINCIPALE ===
  static const Color vertForet = Color(0xFF1B6B4A);
  static const Color vertNature = Color(0xFF2E8B57);
  static const Color vertDoux = Color(0xFF4CAF7D);
  static const Color vertClair = Color(0xFFA8D5BA);
  static const Color vertPastel = Color(0xFFD6EFE1);
  static const Color vertBg = Color(0xFFF0FAF4);

  // === ACCENTS CHALEUREUX ===
  static const Color ocre = Color(0xFFE8A44A);
  static const Color ocreClair = Color(0xFFFFF3DC);
  static const Color peche = Color(0xFFF9D5B3);
  static const Color terracotta = Color(0xFFC97B4B);

  // === NEUTRES ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color grisPerle = Color(0xFFF7F9F8);
  static const Color grisDoux = Color(0xFFE8EDEB);
  static const Color grisTexte = Color(0xFF5A6B62);
  static const Color noirDoux = Color(0xFF1A2820);

  // Aliases for easier use
  static const Color primary = vertForet;
  static const Color accent = ocre;
  static const Color background = vertBg;
  static const Color textPrimary = noirDoux;
  static const Color textSecondary = grisTexte;
  static const Color danger = terracotta;
  static const Color success = vertNature;
  static const Color warning = ocre;

  AppColors._();
}
