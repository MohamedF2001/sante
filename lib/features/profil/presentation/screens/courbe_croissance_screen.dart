import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class CourbeCroissanceScreen extends StatelessWidget {
  const CourbeCroissanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Courbe de Croissance'),
            Text('Ibrahim · Normes OMS', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildChartCard(
              context,
              '📈 Poids (kg) · 0 à 4 mois',
              [0.3, 0.42, 0.55, 0.68, 0.78],
              ['Nais.', '1m', '2m', '3m', '4m'],
              '✅ Courbe normale · Progression régulière',
            ),
            const SizedBox(height: 12),
            _buildChartCard(
              context,
              '📏 Taille (cm) · 0 à 4 mois',
              [0.35, 0.48, 0.60, 0.72, 0.83],
              ['Nais.', '1m', '2m', '3m', '4m'],
              null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatBox('5.2', 'kg · Poids actuel'),
                const SizedBox(width: 8),
                _buildStatBox('58', 'cm · Taille actuelle'),
                const SizedBox(width: 8),
                _buildStatBox('+0.8', 'kg · Ce mois'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, String title, List<double> values, List<String> labels, String? status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.vertForet.withOpacity(0.08), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.noirDoux)),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.map((val) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: val * 100,
                  decoration: BoxDecoration(
                    color: val > 0.6 ? AppColors.vertDoux : AppColors.vertPastel,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: labels.map((l) => Expanded(
              child: Text(l, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: AppColors.grisTexte)),
            )).toList(),
          ),
          if (status != null) ...[
            const SizedBox(height: 12),
            Text(status, style: const TextStyle(fontSize: 10, color: AppColors.vertForet, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.vertBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grisDoux),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                color: AppColors.vertForet,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: AppColors.grisTexte),
            ),
          ],
        ),
      ),
    );
  }
}
