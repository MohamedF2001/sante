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
      body: vaccinsAsync.when(
        data: (vaccins) {
          if (vaccins.isEmpty) {
            return const Center(child: Text('Aucun vaccin enregistré.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vaccins.length,
            itemBuilder: (context, index) {
              final vaccin = vaccins[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: vaccin.estFait ? AppColors.success : AppColors.warning,
                    child: Icon(
                      vaccin.estFait ? Icons.check : Icons.access_time,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    vaccin.nom,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: vaccin.estFait ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text('Date: ${DateFormatter.formatDate(vaccin.date)}'),
                  trailing: Checkbox(
                    value: vaccin.estFait,
                    onChanged: (val) {
                      ref.read(carnetServiceProvider).toggleVaccinStatus(vaccin.id, vaccin.estFait);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addVaccin),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
