import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/carnet_service.dart';
import '../../domain/vaccin_model.dart';
import '../../domain/scan_model.dart';

final carnetServiceProvider = Provider<CarnetService>((ref) => CarnetService());

final vaccinsProvider = StreamProvider<List<VaccinModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.watch(carnetServiceProvider).getVaccins(user.uid);
});

final scansProvider = StreamProvider<List<ScanModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.watch(carnetServiceProvider).getScans(user.uid);
});
