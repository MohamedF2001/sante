import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_model.dart';

class AuthService {
  // Instances Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de l'état de connexion (écouté par le provider)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  // ─── INSCRIPTION ────────────────────────────────────────────
  Future<UserModel> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String telephone,
    required String nomEnfant,
  }) async {
    try {
      // 1. Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Créer le profil dans Firestore
      final userModel = UserModel(
        uid: uid,
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        nomEnfant: nomEnfant,
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());

      // 3. Mettre à jour le displayName Firebase
      await credential.user!.updateDisplayName('$prenom $nom');

      return userModel;
    } on FirebaseAuthException catch (e) {
      // Traduire les erreurs Firebase en messages lisibles
      throw _translateError(e.code);
    }
  }

  // ─── CONNEXION ──────────────────────────────────────────────
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupérer les données depuis Firestore
      final doc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) {
        throw 'Profil utilisateur introuvable';
      }

      return UserModel.fromFirestore(doc.data()!, credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _translateError(e.code);
    }
  }

  // ─── RÉCUPÉRER PROFIL ───────────────────────────────────────
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc.data()!, uid);
    } catch (e) {
      return null;
    }
  }

  // ─── DÉCONNEXION ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ─── TRADUCTION DES ERREURS FIREBASE ────────────────────────
  String _translateError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Une erreur est survenue. Réessayez.';
    }
  }
}
