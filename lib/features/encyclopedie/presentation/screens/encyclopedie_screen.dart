import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class EncyclopedieScreen extends StatelessWidget {
  const EncyclopedieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Encyclopédie Santé'),
            Text('Maladies & Conseils', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Row(
                children: [
                  Text('🔍', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text('Rechercher une maladie...', style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCat('Toutes', true),
                _buildCat('Maladies', false),
                _buildCat('Premiers secours', false),
                _buildCat('Prévention', false),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _buildEncCard('🦟 Paludisme (Malaria)', 'Fièvre, frissons, maux de tête. Cause principale de mortalité infantile au Bénin. Traitement à débuter dans les 24h.', const Color(0xFFE53935), ['Urgence', 'Fréquent']),
                _buildEncCard('💧 Diarrhée aiguë', 'Première cause de déshydratation chez le nourrisson. Solution de réhydratation orale (SRO) à préparer immédiatement.', AppColors.ocre, ['Fréquent']),
                _buildEncCard('🫁 Infections respiratoires', 'Toux, difficultés à respirer, sifflement. Deuxième cause de mortalité des enfants de moins de 5 ans.', const Color(0xFF1565C0), ['Commun']),
                _buildEncCard('🩺 Malnutrition', 'Insuffisance pondérale, retard de croissance. Détectable par la courbe OMS intégrée dans l\'application.', AppColors.vertDoux, ['Prévention']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCat(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.vertForet : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.vertForet : AppColors.grisDoux, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : AppColors.grisTexte, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEncCard(String title, String desc, Color stripe, List<String> tags) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 8)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 4, height: 100, color: stripe),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.noirDoux)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.grisTexte, height: 1.7)),
                  const SizedBox(height: 8),
                  Row(
                    children: tags.map((t) => Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.vertPastel, borderRadius: BorderRadius.circular(20)),
                      child: Text(t, style: const TextStyle(color: AppColors.vertForet, fontSize: 9, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
