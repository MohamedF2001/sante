// ============================================================
// lib/features/auth/presentation/providers/auth_provider.dart
// Provider Riverpod pour l'authentification
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_service.dart';
import '../../domain/user_model.dart';

// Provider du service Auth (singleton)
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider qui écoute l'état de connexion Firebase en temps réel
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Provider du profil utilisateur complet
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  return ref.read(authServiceProvider).getUserProfile(user.uid);
});

// ─── StateNotifier pour les actions Auth ───────────────────
// Gère les états : initial, loading, success, error

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final UserModel? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  // Inscription
  Future<void> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String telephone,
    required String nomEnfant,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        nomEnfant: nomEnfant,
      );
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Connexion
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authService.login(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  // Réinitialiser l'état d'erreur
  void resetError() {
    state = state.copyWith(status: AuthStatus.initial);
  }
}

// Provider du notifier
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});