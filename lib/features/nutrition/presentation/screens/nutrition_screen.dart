import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nutrition Locale'),
            Text('Alimentation béninoise pour bébé', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.vertPastel, AppColors.vertBg]),
                borderRadius: BorderRadius.circular(13),
                border: const Border(left: BorderSide(color: AppColors.vertDoux, width: 3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Conseil du jour · Ibrahim (4 mois)', style: TextStyle(color: AppColors.vertForet, fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
                  Text(
                    'L\'allaitement exclusif est recommandé jusqu\'à 6 mois. À 6 mois, commencez par la bouillie de mil enrichie au soja pour une bonne croissance.',
                    style: TextStyle(color: AppColors.grisTexte, fontSize: 11, height: 1.7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('ALIMENTS RECOMMANDÉS (6+ MOIS)', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.grisTexte)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
              children: [
                _buildNutriCard('🌾', 'Bouillie de mil', 'Fer · Zinc · Énergie'),
                _buildNutriCard('🫘', 'Soja enrichi', 'Protéines complètes'),
                _buildNutriCard('🌿', 'Moringa', 'Vitamines A, C, K'),
                _buildNutriCard('🍌', 'Banane plantain', 'Potassium · Glucides'),
                _buildNutriCard('🥜', 'Arachide', 'Lipides · Protéines'),
                _buildNutriCard('🐟', 'Poisson fumé', 'Oméga-3 · Calcium'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutriCard(String icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.noirDoux)),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grisTexte)),
        ],
      ),
    );
  }
}
