// ============================================================
// lib/features/auth/domain/user_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

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

  String get fullName => '$prenom $nom';

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      nomEnfant: data['nomEnfant'] ?? '',
      dateNaissanceEnfant:
      (data['dateNaissanceEnfant'] as Timestamp?)?.toDate(),
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'telephone': telephone,
    'nomEnfant': nomEnfant,
    'dateNaissanceEnfant': dateNaissanceEnfant != null
        ? Timestamp.fromDate(dateNaissanceEnfant!)
        : null,
    'photoUrl': photoUrl,
    'createdAt': FieldValue.serverTimestamp(),
  };
}