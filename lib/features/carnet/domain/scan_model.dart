import 'package:cloud_firestore/cloud_firestore.dart';

class ScanModel {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime date;

  ScanModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
    };
  }

  factory ScanModel.fromFirestore(Map<String, dynamic> map, String id) {
    return ScanModel(
      id: id,
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
