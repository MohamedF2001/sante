import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class HopitauxScreen extends StatelessWidget {
  const HopitauxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hopitaux = [
      {'nom': 'Centre National Hospitalier HKM', 'adresse': 'Cotonou, Bénin', 'distance': '2.5 km', 'tel': '+229 21 30 01 55'},
      {'nom': 'Hôpital de la Mère et de l\'Enfant (HOMEL)', 'adresse': 'Cotonou, Bénin', 'distance': '1.8 km', 'tel': '+229 21 32 17 40'},
      {'nom': 'Clinique Boni', 'adresse': 'Cadjehoun, Cotonou', 'distance': '3.2 km', 'tel': '+229 21 30 14 31'},
      {'nom': 'Hôpital de Zone d\'Abomey-Calavi', 'adresse': 'Abomey-Calavi', 'distance': '12.0 km', 'tel': '+229 21 36 00 01'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Hôpitaux proches')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hopitaux.length,
        itemBuilder: (context, index) {
          final h = hopitaux[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          h['nom']!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          h['distance']!,
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(h['adresse']!, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(h['tel']!, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: const Text('Y aller'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call),
                          label: const Text('Appeler'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
