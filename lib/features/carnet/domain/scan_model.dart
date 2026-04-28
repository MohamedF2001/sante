// ============================================================
// lib/features/carnet/domain/scan_model.dart
// Stockage image en Base64 dans Firestore (pas besoin de Storage)
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class ScanModel {
  final String id;
  final String userId;
  final String imageBase64; // Image encodée en Base64
  final DateTime date;
  final String? titre;

  ScanModel({
    required this.id,
    required this.userId,
    required this.imageBase64,
    required this.date,
    this.titre,
  });

  factory ScanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScanModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      imageBase64: data['imageBase64'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      titre: data['titre'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'imageBase64': imageBase64,
    'date': Timestamp.fromDate(date),
    'titre': titre,
    'createdAt': FieldValue.serverTimestamp(),
  };
}