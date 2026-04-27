import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conseils = [
      {
        'age': '0-6 mois',
        'titre': 'Allaitement exclusif',
        'conseil': 'Le lait maternel apporte tout ce dont bébé a besoin : eau, vitamines et anticorps. Pas besoin d\'eau ni de tisanes.',
        'icon': Icons.child_care
      },
      {
        'age': '6-9 mois',
        'titre': 'Début de la diversification',
        'conseil': 'Introduisez les purées de légumes (carottes, courges) puis de fruits. Continuez l\'allaitement à la demande.',
        'icon': Icons.restaurant
      },
      {
        'age': '9-12 mois',
        'titre': 'Textures plus épaisses',
        'conseil': 'Proposez des aliments écrasés ou en petits morceaux tendres. Introduisez les protéines (œuf, poisson, viande hachée).',
        'icon': Icons.set_meal
      },
      {
        'age': '1-3 ans',
        'titre': 'Comme les grands',
        'conseil': 'L\'enfant peut manger de tout, mais attention au sel et au sucre ajouté. Favorisez les produits locaux et frais.',
        'icon': Icons.family_restroom
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Conseils Nutrition')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alimentation par âge',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            ...conseils.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primarySurface,
                      child: Icon(c['icon'] as IconData, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['age'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                          ),
                          Text(
                            c['titre'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(c['conseil'] as String, style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 20),
            const Card(
              color: AppColors.primary,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Le saviez-vous ?',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'La bouillie enrichie à base de farines locales (mil, soja, arachide) est un excellent complément après 6 mois.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
