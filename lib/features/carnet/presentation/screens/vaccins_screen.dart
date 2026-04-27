import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/constants/app_routes.dart';
import 'package:sante_famille/core/utils/date_formatter.dart';
import '../providers/carnet_provider.dart';

class VaccinsScreen extends ConsumerWidget {
  const VaccinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinsAsync = ref.watch(vaccinsProvider);

    return Scaffold(
      backgroundColor: AppColors.vertBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                '✅ RÉALISÉS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.grisTexte),
              ),
            ),
          ),
          vaccinsAsync.when(
            data: (vaccins) {
              final faits = vaccins.where((v) => v.estFait).toList();
              final aVenir = vaccins.where((v) => !v.estFait).toList();

              return SliverList(
                delegate: SliverChildListDelegate([
                  if (faits.isEmpty)
                    const Padding(padding: EdgeInsets.all(16), child: Text('Aucun vaccin réalisé')),
                  ...faits.map((v) => _buildVaccinItem(context, v, true, ref)),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      '⏳ À VENIR',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.grisTexte),
                    ),
                  ),

                  if (aVenir.isEmpty)
                    const Padding(padding: EdgeInsets.all(16), child: Text('Tous les vaccins sont à jour !')),
                  ...aVenir.map((v) => _buildVaccinItem(context, v, false, ref)),
                ]),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverFillRemaining(child: Center(child: Text('Erreur: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addVaccin),
        backgroundColor: AppColors.vertForet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVaccinItem(BuildContext context, dynamic vaccin, bool isDone, WidgetRef ref) {
    final bool isSoon = !isDone && vaccin.date.difference(DateTime.now()).inDays <= 2;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isSoon ? Border.all(color: AppColors.ocre, width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isDone ? AppColors.vertNature : (isSoon ? AppColors.ocre : AppColors.grisDoux),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccin.nom,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.noirDoux),
                ),
                Text(
                  'Date: ${DateFormatter.formatDate(vaccin.date)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.grisTexte),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDone ? AppColors.vertPastel : (isSoon ? AppColors.ocreClair : AppColors.grisDoux),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isDone ? 'Fait' : (isSoon ? 'J-2' : 'Planifié'),
              style: TextStyle(
                color: isDone ? AppColors.vertForet : (isSoon ? AppColors.terracotta : AppColors.grisTexte),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Checkbox(
            value: isDone,
            onChanged: (val) {
              ref.read(carnetServiceProvider).toggleVaccinStatus(vaccin.id, vaccin.estFait);
            },
            activeColor: AppColors.vertForet,
          ),
        ],
      ),
    );
  }
}
