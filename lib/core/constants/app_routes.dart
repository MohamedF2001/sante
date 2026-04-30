// ============================================================
// lib/core/constants/app_routes.dart
// Définition de toutes les routes de l'application
// ============================================================

import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/carnet/presentation/screens/add_vaccin_screen.dart';
import '../../features/carnet/presentation/screens/carnet_screen.dart';
import '../../features/carnet/presentation/screens/scans_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/encyclopedie/presentation/screens/encyclopedie_screen.dart';
import '../../features/forum/presentation/screens/forum_screen.dart';
import '../../features/forum/presentation/screens/post_detail_screen.dart';
import '../../features/hopitaux/presentation/screens/hopitaux_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/pleurs/presentation/screens/pleurs_screen.dart';
import '../../features/profil/presentation/screens/parametre_screen.dart';
import '../../features/profil/presentation/screens/profil_screen.dart';
import '../../features/profil/presentation/screens/modifier_profil_screen.dart';
import '../../features/profil/presentation/screens/ajouter_enfant_screen.dart';
import '../../features/carnet/presentation/screens/growth_curve_screen.dart';
import '../../features/toise/presentation/screens/toise_screen.dart';

class AppRoutes {
  // Noms des routes
  static const String splash    = '/';
  static const String login     = '/login';
  static const String register  = '/register';
  static const String dashboard = '/dashboard';
  static const String carnet    = '/carnet';
  static const String addVaccin = '/carnet/add-vaccin';
  static const String scans     = '/carnet/scans';
  static const String pleurs    = '/pleurs';
  static const String toise     = '/toise';
  static const String hopitaux  = '/hopitaux';
  static const String encyclopedie = '/encyclopedie';
  static const String nutrition = '/nutrition';
  static const String forum     = '/forum';
  static const String postDetail = '/forum/post';
  static const String profil    = '/profil';
  static const String parametres = '/parametres';
  static const String modifierProfil = '/modifier-profil';
  static const String ajouterEnfant = '/ajouter-enfant';
  static const String growthCurve = '/growth-curve';

  // Map routes → widgets
  static Map<String, WidgetBuilder> get routes => {
    login:      (_) => const LoginScreen(),
    register:   (_) => const RegisterScreen(),
    dashboard:  (_) => const DashboardScreen(),
    carnet:     (_) => const CarnetScreen(),
    addVaccin:  (_) => const AddVaccinScreen(),
    scans:      (_) => const ScansScreen(),
    pleurs:     (_) => const PleursScreen(),
    toise:      (_) => const ToiseScreen(),
    hopitaux:   (_) => const HopitauxScreen(),
    encyclopedie: (_) => const EncyclopedieScreen(),
    nutrition:  (_) => const NutritionScreen(),
    forum:      (_) => const ForumScreen(),
    postDetail: (_) => const PostDetailScreen(),
    profil:     (_) => const ProfilScreen(),
    parametres: (_) => const ParametresScreen(),
    modifierProfil: (_) => const ModifierProfilScreen(),
    ajouterEnfant: (_) => const AjouterEnfantScreen(),
    growthCurve: (_) => const GrowthCurveScreen(),
  };

  AppRoutes._();
}