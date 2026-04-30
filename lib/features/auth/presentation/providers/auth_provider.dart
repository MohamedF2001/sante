// ============================================================
// lib/features/auth/presentation/providers/auth_provider.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_service.dart';
import '../../domain/user_model.dart';
import '../../domain/enfant_model.dart';

// Provider singleton du service
final authServiceProvider = Provider<AuthService>((_) => AuthService());

// Stream de l'état Firebase (connecté / déconnecté)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Profil complet de l'utilisateur connecté
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return null;
  return ref.read(authServiceProvider).getUserProfile(user.uid);
});

// ─── État des actions Auth ───────────────────────────────

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

  AuthState copyWith({AuthStatus? status, String? errorMessage, UserModel? user}) =>
      AuthState(
        status: status ?? this.status,
        errorMessage: errorMessage,
        user: user ?? this.user,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;
  AuthNotifier(this._service) : super(const AuthState());

  Future<void> register({
    required String email, required String password,
    required String nom,   required String prenom,
    required String telephone, required String nomEnfant,
    DateTime? dateNaissanceEnfant,
    String genreEnfant = 'M',
    String? photoBase64Enfant,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _service.register(
        email: email, password: password,
        nom: nom, prenom: prenom,
        telephone: telephone, nomEnfant: nomEnfant,
        dateNaissanceEnfant: dateNaissanceEnfant,
        genreEnfant: genreEnfant,
        photoBase64Enfant: photoBase64Enfant,
      );
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _service.login(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AuthState();
  }

  Future<void> updateProfile({
    required String uid,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? password,
    String? nomEnfant,
    DateTime? dateNaissanceEnfant,
    String? genreEnfant,
    String? photoBase64Enfant,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _service.updateProfile(
        uid: uid,
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        password: password,
        nomEnfant: nomEnfant,
        dateNaissanceEnfant: dateNaissanceEnfant,
        genreEnfant: genreEnfant,
        photoBase64Enfant: photoBase64Enfant,
      );
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> addEnfant(String uid, EnfantModel enfant) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _service.addEnfant(uid, enfant);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  void resetError() => state = state.copyWith(status: AuthStatus.initial);
}

final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});