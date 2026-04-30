// ============================================================
// lib/features/carnet/presentation/providers/carnet_provider.dart
// ============================================================

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/carnet_service.dart';
import '../../domain/scan_model.dart';
import '../../domain/vaccin_model.dart';
import '../../domain/mesure_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Provider du service
final carnetServiceProvider = Provider<CarnetService>((_) => CarnetService());

// Provider du userId courant
final _currentUidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

// Stream des vaccins (temps réel)
final vaccinsProvider = StreamProvider<List<VaccinModel>>((ref) {
  final uid = ref.watch(_currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(carnetServiceProvider).watchVaccins(uid);
});

// Vaccins réalisés seulement
final vaccinsRealisesProvider = Provider<List<VaccinModel>>((ref) {
  return ref.watch(vaccinsProvider).valueOrNull
      ?.where((v) => v.isFait)
      .toList() ?? [];
});

// Vaccins à venir seulement
final vaccinsAVenirProvider = Provider<List<VaccinModel>>((ref) {
  return ref.watch(vaccinsProvider).valueOrNull
      ?.where((v) => !v.isFait)
      .toList() ?? [];
});

// Stream des scans (temps réel)
final scansProvider = StreamProvider<List<ScanModel>>((ref) {
  final uid = ref.watch(_currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(carnetServiceProvider).watchScans(uid);
});

// Stream des mesures (croissance)
final mesuresProvider = StreamProvider<List<MesureModel>>((ref) {
  final uid = ref.watch(_currentUidProvider);
  final user = ref.watch(userProfileProvider).valueOrNull;
  final enfantId = user?.activeEnfant?.id;

  if (uid == null || enfantId == null) return Stream.value([]);
  return ref.watch(carnetServiceProvider).watchMesures(uid, enfantId);
});

// ─── Notifier pour les actions ───────────────────────────────

class CarnetNotifier extends StateNotifier<AsyncValue<void>> {
  final CarnetService _service;
  final String? _uid;

  CarnetNotifier(this._service, this._uid) : super(const AsyncData(null));

  Future<void> addVaccin(VaccinModel vaccin) async {
    state = const AsyncLoading();
    try {
      await _service.addVaccin(vaccin);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> marquerFait(String vaccinId) async {
    await _service.marquerFait(vaccinId, DateTime.now());
  }

  Future<void> deleteVaccin(String vaccinId) async {
    await _service.deleteVaccin(vaccinId);
  }

  Future<void> uploadScan(File imageFile, {String? titre}) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    try {
      await _service.saveScan(
          userId: uid, imageFile: imageFile, titre: titre);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteScan(ScanModel scan) async {
    await _service.deleteScan(scan.id);
  }

  Future<void> addMesure(MesureModel mesure) async {
    state = const AsyncLoading();
    try {
      await _service.addMesure(mesure);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final carnetNotifierProvider =
StateNotifierProvider<CarnetNotifier, AsyncValue<void>>((ref) {
  return CarnetNotifier(
    ref.read(carnetServiceProvider),
    FirebaseAuth.instance.currentUser?.uid,
  );
});