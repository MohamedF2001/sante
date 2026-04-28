// ============================================================
// lib/features/auth/data/auth_service.dart
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ─── INSCRIPTION ────────────────────────────────────────
  Future<UserModel> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String telephone,
    required String nomEnfant,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = cred.user!.uid;

      final user = UserModel(
        uid: uid, nom: nom, prenom: prenom,
        email: email, telephone: telephone, nomEnfant: nomEnfant,
      );

      await _db.collection('users').doc(uid).set(user.toMap());
      await cred.user!.updateDisplayName('$prenom $nom');
      return user;
    } on FirebaseAuthException catch (e) {
      throw _translateError(e.code);
    }
  }

  // ─── CONNEXION ──────────────────────────────────────────
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final doc =
      await _db.collection('users').doc(cred.user!.uid).get();
      if (!doc.exists) throw 'Profil introuvable.';
      return UserModel.fromFirestore(doc.data()!, cred.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _translateError(e.code);
    }
  }

  // ─── RÉCUPÉRER PROFIL ───────────────────────────────────
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc.data()!, uid);
  }

  // ─── DÉCONNEXION ────────────────────────────────────────
  Future<void> logout() => _auth.signOut();

  // ─── TRADUCTION ERREURS ─────────────────────────────────
  String _translateError(String code) {
    const errors = {
      'email-already-in-use': 'Cet email est déjà utilisé.',
      'invalid-email': 'Adresse email invalide.',
      'weak-password': 'Mot de passe trop faible (min. 6 caractères).',
      'user-not-found': 'Aucun compte trouvé avec cet email.',
      'wrong-password': 'Mot de passe incorrect.',
      'too-many-requests': 'Trop de tentatives. Réessayez plus tard.',
      'network-request-failed': 'Vérifiez votre connexion internet.',
    };
    return errors[code] ?? 'Erreur : $code';
  }
}