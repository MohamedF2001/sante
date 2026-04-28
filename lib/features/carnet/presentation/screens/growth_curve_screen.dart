// ============================================================
// lib/features/carnet/presentation/screens/growth_curve_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../provider/carnet_provider.dart';
import '../../domain/mesure_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class GrowthCurveScreen extends ConsumerWidget {
  const GrowthCurveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesuresAsync = ref.watch(mesuresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courbe de croissance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMesureDialog(context, ref),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: mesuresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (mesures) {
          if (mesures.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: AppColors.textLight),
                  SizedBox(height: 16),
                  Text('Aucune mesure enregistrée'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ChartSection(
                  title: 'Poids (kg)',
                  color: Colors.blue,
                  spots: mesures
                      .where((m) => m.poids != null)
                      .map((m) => FlSpot(
                            m.date.millisecondsSinceEpoch.toDouble(),
                            m.poids!,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32),
                _ChartSection(
                  title: 'Taille (cm)',
                  color: Colors.green,
                  spots: mesures
                      .where((m) => m.taille != null)
                      .map((m) => FlSpot(
                            m.date.millisecondsSinceEpoch.toDouble(),
                            m.taille!,
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddMesureDialog(BuildContext context, WidgetRef ref) {
    final poidsCtrl = TextEditingController();
    final tailleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une mesure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: poidsCtrl,
              decoration: const InputDecoration(labelText: 'Poids (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tailleCtrl,
              decoration: const InputDecoration(labelText: 'Taille (cm)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = ref.read(userProfileProvider).valueOrNull;
              if (user == null || user.activeEnfant == null) return;

              final mesure = MesureModel(
                id: '',
                userId: user.uid,
                enfantId: user.activeEnfant!.id,
                poids: double.tryParse(poidsCtrl.text),
                taille: double.tryParse(tailleCtrl.text),
                date: DateTime.now(),
              );

              await ref.read(carnetNotifierProvider.notifier).addMesure(mesure);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<FlSpot> spots;

  const _ChartSection({
    required this.title,
    required this.color,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(DateFormat('dd/MM').format(date), style: const TextStyle(fontSize: 10)),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
