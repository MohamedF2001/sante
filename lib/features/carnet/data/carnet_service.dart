import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/vaccin_model.dart';
import '../domain/scan_model.dart';

class CarnetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    // MODE SIMULATION : Pour éviter les frais Firebase Storage
    // On simule un délai de téléchargement
    await Future.delayed(const Duration(seconds: 2));

    final scanId = const Uuid().v4();

    // On utilise une image de placeholder de haute qualité pour la démo
    // ou on pourrait stocker le chemin local (mais il serait perdu au redémarrage)
    const mockImageUrl = 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop';

    // Save metadata to Firestore (Firestore reste gratuit)
    final scan = ScanModel(
      id: scanId,
      userId: userId,
      imageUrl: mockImageUrl,
      date: DateTime.now(),
    );

    await _firestore.collection('scans').doc(scanId).set(scan.toMap());
  }
}
