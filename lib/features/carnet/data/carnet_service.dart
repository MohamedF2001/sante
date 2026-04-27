import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../domain/vaccin_model.dart';
import '../domain/scan_model.dart';

class CarnetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ─── VACCINS ───────────────────────────────────────────────

  Stream<List<VaccinModel>> getVaccins(String userId) {
    return _firestore
        .collection('vaccins')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VaccinModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> addVaccin(VaccinModel vaccin) async {
    await _firestore.collection('vaccins').add(vaccin.toMap());
  }

  Future<void> toggleVaccinStatus(String vaccinId, bool currentStatus) async {
    await _firestore.collection('vaccins').doc(vaccinId).update({
      'estFait': !currentStatus,
    });
  }

  // ─── SCANS ─────────────────────────────────────────────────

  Stream<List<ScanModel>> getScans(String userId) {
    return _firestore
        .collection('scans')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> uploadScan(String userId, File file) async {
    final scanId = const Uuid().v4();
    final ref = _storage.ref().child('scans/$userId/$scanId.jpg');

    // Upload file
    await ref.putFile(file);
    final imageUrl = await ref.getDownloadURL();

    // Save to Firestore
    final scan = ScanModel(
      id: scanId,
      userId: userId,
      imageUrl: imageUrl,
      date: DateTime.now(),
    );

    await _firestore.collection('scans').doc(scanId).set(scan.toMap());
  }
}
