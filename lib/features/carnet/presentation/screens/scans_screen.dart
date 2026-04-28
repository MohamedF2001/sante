// ============================================================
// lib/features/carnet/presentation/screens/scans_screen.dart
// Scanner / importer et afficher les scans du carnet
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/scan_model.dart';
import '../provider/carnet_provider.dart';

class ScansScreen extends ConsumerWidget {
  const ScansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scansAsync = ref.watch(scansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Boutons scanner / importer ───────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Scanner',
                  onTap: () => _pickImage(context, ref, ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.upload_file_outlined,
                  label: 'Importer',
                  onTap: () => _pickImage(context, ref, ImageSource.gallery),
                ),
              ),
            ]),
          ),

          // ── Liste des scans ──────────────────────────────
          Expanded(
            child: scansAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: AppColors.textLight),
                    const SizedBox(height: 12),
                    const Text('Impossible de charger les scans',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('$e',
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              data: (scans) {
                if (scans.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📄', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 12),
                        Text('Aucun scan enregistré',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary)),
                        SizedBox(height: 6),
                        Text('Scannez votre carnet de santé',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight)),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: scans.length,
                  itemBuilder: (_, i) => _ScanCard(scan: scans[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
      BuildContext context, WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    final file = File(picked.path);

    // Afficher un dialog pour le titre (optionnel)
    if (!context.mounted) return;
    final titre = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Nommer le scan'),
          content: TextField(
            controller: ctrl,
            decoration:
            const InputDecoration(hintText: 'Ex: Page vaccins page 1'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Ignorer')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, ctrl.text),
                child: const Text('Confirmer')),
          ],
        );
      },
    );

    // Upload
    await ref
        .read(carnetNotifierProvider.notifier)
        .uploadScan(file, titre: titre);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan enregistré ✓'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ScanCard extends ConsumerWidget {
  final ScanModel scan;
  const _ScanCard({required this.scan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('dd/MM/yyyy').format(scan.date);

    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: _buildBase64Image(scan.imageBase64),
            ),
            // Infos
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scan.titre ?? 'Scan',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                  Text(date,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce scan ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(carnetNotifierProvider.notifier).deleteScan(scan);
    }
  }

  Widget _buildBase64Image(String base64String) {
    try {
      // Supprimer le préfixe data:image/...;base64, si présent
      final cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      final bytes = base64Decode(cleanBase64);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: AppColors.textLight),
        ),
      );
    } catch (e) {
      return const Center(
        child: Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }
}