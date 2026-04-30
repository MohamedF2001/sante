// ============================================================
// lib/main.dart
// Point d'entrée de l'application Santé Famille
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Point d'entrée principal
void main() async {
  // ⚠️ OBLIGATOIRE avant tout appel Flutter/Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signInAnonymously();
  runApp(
    // ProviderScope est obligatoire pour Riverpod
    const ProviderScope(
      child: SanteFamilleApp(),
    ),
  );
}

class SanteFamilleApp extends ConsumerWidget {
  const SanteFamilleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écouter l'état de connexion Firebase en temps réel
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Santé Famille',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,

      // Gérer les 3 états : chargement / connecté / déconnecté
      home: authState.when(
        // ── Firebase charge l'état Auth ──────────────────
        loading: () => const _SplashScreen(),

        // ── Utilisateur connecté → Dashboard ────────────
        // ── Utilisateur non connecté → Login ────────────
        data: (user) {
          if (user != null) {
            return AppRoutes.routes[AppRoutes.dashboard]!(context);
          }
          return AppRoutes.routes[AppRoutes.login]!(context);
        },

        // ── Erreur Firebase → Login par défaut ──────────
        error: (_, __) => AppRoutes.routes[AppRoutes.login]!(context),
      ),
    );
  }
}

// ── Écran de chargement (splash) ─────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(Icons.health_and_safety, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Santé Famille',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'E-Carnet Bénin',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}