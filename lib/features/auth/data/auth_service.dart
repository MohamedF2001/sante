// ============================================================
// lib/features/auth/data/auth_service.dart
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_model.dart';
import '../domain/enfant_model.dart';
import 'package:uuid/uuid.dart';

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
    DateTime? dateNaissanceEnfant,
    String genreEnfant = 'M',
    String? photoBase64Enfant,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = cred.user!.uid;

      final premierEnfant = EnfantModel(
        id: const Uuid().v4(),
        nom: nomEnfant,
        genre: genreEnfant,
        dateNaissance: dateNaissanceEnfant,
        photoUrl: photoBase64Enfant,
      );

      final user = UserModel(
        uid: uid,
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        enfants: [premierEnfant],
        activeEnfantId: premierEnfant.id,
      );

      await _db.collection('users').doc(uid).set(user.toMap());
      await cred.user!.updateDisplayName('$prenom $nom');
      return user;
    } on FirebaseAuthException catch (e) {
      throw _translateError(e.code);
    }
  }

  // ─── MODIFIER PROFIL ────────────────────────────────────
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
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return;
      final userModel = UserModel.fromFirestore(doc.data()!, uid);

      final updates = <String, dynamic>{};
      if (nom != null) updates['nom'] = nom;
      if (prenom != null) updates['prenom'] = prenom;
      if (telephone != null) updates['telephone'] = telephone;
      if (email != null) {
        updates['email'] = email;
        await _auth.currentUser?.updateEmail(email);
      }

      if (password != null && password.isNotEmpty) {
        await _auth.currentUser?.updatePassword(password);
      }

      // Mettre à jour l'enfant actif si des infos sont fournies
      if (nomEnfant != null || dateNaissanceEnfant != null || genreEnfant != null || photoBase64Enfant != null) {
        final activeId = userModel.activeEnfantId;
        final nouveauxEnfants = userModel.enfants.map((e) {
          if (e.id == activeId) {
            return EnfantModel(
              id: e.id,
              nom: nomEnfant ?? e.nom,
              dateNaissance: dateNaissanceEnfant ?? e.dateNaissance,
              genre: genreEnfant ?? e.genre,
              photoUrl: photoBase64Enfant ?? e.photoUrl,
            );
          }
          return e;
        }).toList();

        updates['enfants'] = nouveauxEnfants.map((e) {
          final map = e.toMap();
          map['id'] = e.id;
          return map;
        }).toList();
      }

      if (updates.isNotEmpty) {
        await _db.collection('users').doc(uid).update(updates);
        if (nom != null || prenom != null) {
          final doc = await _db.collection('users').doc(uid).get();
          final currentNom = nom ?? doc.data()?['nom'] ?? '';
          final currentPrenom = prenom ?? doc.data()?['prenom'] ?? '';
          await _auth.currentUser?.updateDisplayName('$currentPrenom $currentNom');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _translateError(e.code);
    }
  }

  // ─── AJOUTER ENFANT ─────────────────────────────────────
  Future<void> addEnfant(String uid, EnfantModel enfant) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final user = UserModel.fromFirestore(doc.data()!, uid);
    final nouveauxEnfants = [...user.enfants, enfant];

    await _db.collection('users').doc(uid).update({
      'enfants': nouveauxEnfants.map((e) {
        final map = e.toMap();
        map['id'] = e.id;
        return map;
      }).toList(),
    });
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