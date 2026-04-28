// ============================================================
// lib/features/carnet/presentation/screens/vaccins_screen.dart
// Liste des vaccins réalisés et à venir
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/vaccin_model.dart';
import '../provider/carnet_provider.dart';

class VaccinsScreen extends ConsumerWidget {
  const VaccinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinsAsync = ref.watch(vaccinsProvider);

    return vaccinsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (vaccins) {
        final faits   = vaccins.where((v) => v.isFait).toList();
        final avenir  = vaccins.where((v) => !v.isFait).toList();

        if (vaccins.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('💉', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text('Aucun vaccin enregistré',
                    style: TextStyle(
                        fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/carnet/add-vaccin'),
                  child: const Text('Ajouter un vaccin'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── Section RÉALISÉS ────────────────────────
            if (faits.isNotEmpty) ...[
              _SectionHeader(title: 'RÉALISÉS', icon: Icons.check_box, color: AppColors.vaccinFait),
              ...faits.map((v) => _VaccinTile(vaccin: v)),
              const SizedBox(height: 16),
            ],

            // ── Section À VENIR ─────────────────────────
            if (avenir.isNotEmpty) ...[
              _SectionHeader(title: 'À VENIR', icon: Icons.access_time, color: AppColors.vaccinAvenir),
              ...avenir.map((v) => _VaccinTile(vaccin: v)),
            ],
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: color)),
      ]),
    );
  }
}

class _VaccinTile extends ConsumerWidget {
  final VaccinModel vaccin;
  const _VaccinTile({required this.vaccin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final dateFormatted = DateFormat('dd/MM/yyyy').format(vaccin.datePrevu);
    //final dateFormatted = DateFormat('d MMM yyyy', 'fr_FR').format(vaccin.datePrevu);
    final daysLeft      = vaccin.daysUntil;

    Color statutColor;
    String statutLabel;
    switch (vaccin.statut) {
      case VaccinStatut.fait:
        statutColor = AppColors.vaccinFait;
        statutLabel = 'Fait';
      case VaccinStatut.urgent:
        statutColor = AppColors.vaccinUrgent;
        statutLabel = 'Urgent';
      case VaccinStatut.planifie:
        statutColor = AppColors.vaccinPlanifie;
        statutLabel = 'Planifié';
      case VaccinStatut.avenir:
        statutColor = AppColors.vaccinAvenir;
        statutLabel = daysLeft <= 2 ? 'J-$daysLeft' : 'À venir';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(children: [
        // Indicateur couleur
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: statutColor),
        ),

        // Infos vaccin
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vaccin.nom,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text('${vaccin.ageRecommande} · $dateFormatted',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),

        // Badge statut
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statutColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statutLabel,
              style: TextStyle(
                  color: statutColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ),

        // Menu contextuel
        if (!vaccin.isFait)
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'fait') {
                await ref
                    .read(carnetNotifierProvider.notifier)
                    .marquerFait(vaccin.id);
              } else if (value == 'delete') {
                await ref
                    .read(carnetNotifierProvider.notifier)
                    .deleteVaccin(vaccin.id);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'fait', child: Text('Marquer comme fait ✓')),
              const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
            ],
            child: const Icon(Icons.more_vert,
                size: 18, color: AppColors.textLight),
          ),
      ]),
    );
  }
}