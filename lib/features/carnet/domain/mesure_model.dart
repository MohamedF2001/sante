// ============================================================
// lib/features/carnet/domain/mesure_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class MesureModel {
  final String id;
  final String userId;
  final String enfantId;
  final double? poids; // en kg
  final double? taille; // en cm
  final DateTime date;

  MesureModel({
    required this.id,
    required this.userId,
    required this.enfantId,
    this.poids,
    this.taille,
    required this.date,
  });

  factory MesureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MesureModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      enfantId: data['enfantId'] ?? '',
      poids: (data['poids'] as num?)?.toDouble(),
      taille: (data['taille'] as num?)?.toDouble(),
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'enfantId': enfantId,
    'poids': poids,
    'taille': taille,
    'date': Timestamp.fromDate(date),
  };
}
