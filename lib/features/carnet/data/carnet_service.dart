// ============================================================
// lib/features/carnet/data/carnet_service.dart
// Service Firestore uniquement — images en Base64 (pas de Storage)
// ============================================================

import 'dart:io';
import 'dart:convert'; // Pour base64Encode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../domain/scan_model.dart';
import '../domain/vaccin_model.dart';

class CarnetService {
  final _db = FirebaseFirestore.instance;

  // ─── VACCINS ─────────────────────────────────────────────

  Stream<List<VaccinModel>> watchVaccins(String userId) {
    return _db
        .collection('vaccins')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(VaccinModel.fromFirestore).toList();
      list.sort((a, b) => a.datePrevu.compareTo(b.datePrevu));
      return list;
    });
  }

  Future<void> addVaccin(VaccinModel vaccin) async {
    await _db.collection('vaccins').add(vaccin.toMap());
  }

  Future<void> marquerFait(String vaccinId, DateTime dateRealise) async {
    await _db.collection('vaccins').doc(vaccinId).update({
      'statut': VaccinStatut.fait.name,
      'dateRealise': Timestamp.fromDate(dateRealise),
    });
  }

  Future<void> deleteVaccin(String vaccinId) async {
    await _db.collection('vaccins').doc(vaccinId).delete();
  }

  // ─── SCANS — Base64 dans Firestore ───────────────────────

  Stream<List<ScanModel>> watchScans(String userId) {
    return _db
        .collection('scans')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(ScanModel.fromFirestore).toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  /// Compresse l'image et la stocke en Base64 dans Firestore
  /// Pas besoin de Firebase Storage !
  Future<ScanModel> saveScan({
    required String userId,
    required File imageFile,
    String? titre,
  }) async {
    // 1. Compresser l'image pour réduire la taille
    //    (Firestore limite à 1 Mo par document)
    final compressed = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 40,      // Qualité 40% — bon compromis taille/qualité
      minWidth: 600,    // Largeur max 600px
      minHeight: 800,   // Hauteur max 800px
    );

    if (compressed == null) throw 'Impossible de compresser l\'image';

    // 2. Encoder en Base64
    final base64String = base64Encode(compressed);

    // 3. Sauvegarder dans Firestore
    final scan = ScanModel(
      id: '',
      userId: userId,
      imageBase64: base64String,
      date: DateTime.now(),
      titre: titre ??
          'Scan du ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );

    final docRef = await _db.collection('scans').add(scan.toMap());

    return ScanModel(
      id: docRef.id,
      userId: userId,
      imageBase64: base64String,
      date: scan.date,
      titre: scan.titre,
    );
  }

  Future<void> deleteScan(String scanId) async {
    await _db.collection('scans').doc(scanId).delete();
  }

  // ─── VACCINS PAR DÉFAUT (Programme PEV Bénin) ─────────────

  static List<Map<String, dynamic>> vaccinsPEVBenin() {
    return [
      {'nom': 'BCG + Polio 0',             'ageRecommande': 'À la naissance'},
      {'nom': 'DTC-HepB-Hib 1 + Polio 1',  'ageRecommande': '6 semaines'},
      {'nom': 'DTC-HepB-Hib 2 + Polio 2',  'ageRecommande': '10 semaines'},
      {'nom': 'DTC-HepB-Hib 3 + Polio 3',  'ageRecommande': '14 semaines'},
      {'nom': 'Vaccin Rougeole-Rubéole',    'ageRecommande': '9 mois'},
      {'nom': 'Méningite A',                'ageRecommande': '15 mois'},
      {'nom': 'DTC Rappel',                 'ageRecommande': '18 mois'},
    ];
  }
}