// ============================================================
// lib/features/auth/domain/user_model.dart
// Modèle utilisateur
// ============================================================

class UserModel {
  final String uid;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String nomEnfant;
  final DateTime? dateNaissanceEnfant;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.nomEnfant,
    this.dateNaissanceEnfant,
    this.photoUrl,
  });

  // Convertit un document Firestore en UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      nomEnfant: data['nomEnfant'] ?? '',
      dateNaissanceEnfant: data['dateNaissanceEnfant'] != null
          ? (data['dateNaissanceEnfant'] as dynamic).toDate()
          : null,
      photoUrl: data['photoUrl'],
    );
  }

  // Convertit le UserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'nomEnfant': nomEnfant,
      'dateNaissanceEnfant': dateNaissanceEnfant,
      'photoUrl': photoUrl,
      'createdAt': DateTime.now(),
    };
  }

  // Nom complet
  String get fullName => '$prenom $nom';
}



