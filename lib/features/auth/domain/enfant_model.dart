// ============================================================
// lib/features/auth/domain/enfant_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class EnfantModel {
  final String id;
  final String nom;
  final DateTime? dateNaissance;
  final String genre; // 'M' or 'F'
  final String? photoUrl;

  EnfantModel({
    required this.id,
    required this.nom,
    this.dateNaissance,
    required this.genre,
    this.photoUrl,
  });

  factory EnfantModel.fromFirestore(Map<String, dynamic> data, String id) {
    return EnfantModel(
      id: id,
      nom: data['nom'] ?? '',
      dateNaissance: (data['dateNaissance'] as Timestamp?)?.toDate(),
      genre: data['genre'] ?? 'M',
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'dateNaissance': dateNaissance != null ? Timestamp.fromDate(dateNaissance!) : null,
    'genre': genre,
    'photoUrl': photoUrl,
  };
}
