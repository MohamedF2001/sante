// ============================================================
// lib/features/auth/domain/user_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'enfant_model.dart';

class UserModel {
  final String uid;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final List<EnfantModel> enfants;
  final String? photoUrl;
  final String? activeEnfantId;

  UserModel({
    required this.uid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    this.enfants = const [],
    this.photoUrl,
    this.activeEnfantId,
  });

  String get fullName => '$prenom $nom';

  EnfantModel? get activeEnfant {
    if (activeEnfantId == null || enfants.isEmpty) {
      return enfants.isNotEmpty ? enfants.first : null;
    }
    return enfants.firstWhere((e) => e.id == activeEnfantId, orElse: () => enfants.first);
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    final enfantsData = data['enfants'] as List<dynamic>? ?? [];
    return UserModel(
      uid: uid,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      enfants: enfantsData
          .map((e) => EnfantModel.fromFirestore(e as Map<String, dynamic>, e['id'] ?? ''))
          .toList(),
      photoUrl: data['photoUrl'],
      activeEnfantId: data['activeEnfantId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'telephone': telephone,
    'enfants': enfants.map((e) {
      final map = e.toMap();
      map['id'] = e.id;
      return map;
    }).toList(),
    'photoUrl': photoUrl,
    'activeEnfantId': activeEnfantId,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}