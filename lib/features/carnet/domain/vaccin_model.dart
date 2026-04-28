

// ============================================================
// lib/features/carnet/domain/vaccin_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

enum VaccinStatut { fait, avenir, planifie, urgent }

class VaccinModel {
  final String id;
  final String userId;
  final String nom;
  final DateTime datePrevu;
  final DateTime? dateRealise;
  final VaccinStatut statut;
  final String? centre;
  final String? notes;
  // Âge recommandé (ex: "À la naissance", "6 semaines")
  final String ageRecommande;

  VaccinModel({
    required this.id,
    required this.userId,
    required this.nom,
    required this.datePrevu,
    this.dateRealise,
    required this.statut,
    this.centre,
    this.notes,
    required this.ageRecommande,
  });

  bool get isFait => statut == VaccinStatut.fait;

  /// Nombre de jours restants avant le vaccin
  int get daysUntil => datePrevu.difference(DateTime.now()).inDays;

  factory VaccinModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VaccinModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      nom: data['nom'] ?? '',
      datePrevu: (data['datePrevu'] as Timestamp).toDate(),
      dateRealise: (data['dateRealise'] as Timestamp?)?.toDate(),
      statut: VaccinStatut.values.firstWhere(
            (s) => s.name == data['statut'],
        orElse: () => VaccinStatut.planifie,
      ),
      centre: data['centre'],
      notes: data['notes'],
      ageRecommande: data['ageRecommande'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'nom': nom,
    'datePrevu': Timestamp.fromDate(datePrevu),
    'dateRealise':
    dateRealise != null ? Timestamp.fromDate(dateRealise!) : null,
    'statut': statut.name,
    'centre': centre,
    'notes': notes,
    'ageRecommande': ageRecommande,
    'createdAt': FieldValue.serverTimestamp(),
  };
}


