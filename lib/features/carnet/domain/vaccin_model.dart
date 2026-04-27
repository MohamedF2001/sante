import 'package:cloud_firestore/cloud_firestore.dart';

class VaccinModel {
  final String id;
  final String userId;
  final String nom;
  final DateTime date;
  final bool estFait;

  VaccinModel({
    required this.id,
    required this.userId,
    required this.nom,
    required this.date,
    this.estFait = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nom': nom,
      'date': Timestamp.fromDate(date),
      'estFait': estFait,
    };
  }

  factory VaccinModel.fromFirestore(Map<String, dynamic> map, String id) {
    return VaccinModel(
      id: id,
      userId: map['userId'] ?? '',
      nom: map['nom'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      estFait: map['estFait'] ?? false,
    );
  }
}
