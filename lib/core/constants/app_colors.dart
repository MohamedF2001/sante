// ============================================================
// lib/core/constants/app_colors.dart
// Palette de couleurs de l'application Santé Famille
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales (vert santé)
  static const Color primary = Color(0xFF1B5E20);       // Vert foncé (header)
  static const Color primaryLight = Color(0xFF2E7D32);  // Vert moyen
  static const Color primarySurface = Color(0xFFE8F5E9); // Vert très clair (fond)
  static const Color accent = Color(0xFF43A047);         // Vert accent

  // Couleurs secondaires
  static const Color warning = Color(0xFFF9A825);        // Orange (alerte)
  static const Color danger = Color(0xFFE53935);         // Rouge (urgent)
  static const Color success = Color(0xFF2E7D32);        // Vert (fait)

  // Neutres
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color border = Color(0xFFE0E0E0);

  // Statuts vaccins
  static const Color vaccinFait = Color(0xFF2E7D32);
  static const Color vaccinAvenir = Color(0xFFF9A825);
  static const Color vaccinUrgent = Color(0xFFE53935);
  static const Color vaccinPlanifie = Color(0xFF1565C0);

  AppColors._(); // Constructeur privé — classe utilitaire
}