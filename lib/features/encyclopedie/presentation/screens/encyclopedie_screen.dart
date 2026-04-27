import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class EncyclopedieScreen extends StatelessWidget {
  const EncyclopedieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      {
        'titre': 'La fièvre chez l\'enfant : quand s\'inquiéter ?',
        'categorie': 'Maladies',
        'resume': 'La fièvre est une réaction normale du corps. Apprenez à reconnaître les signes qui nécessitent une consultation.',
        'image': '🌡️'
      },
      {
        'titre': 'Le calendrier vaccinal au Bénin',
        'categorie': 'Prévention',
        'resume': 'Quels vaccins sont obligatoires et à quel âge ? Voici le guide complet mis à jour.',
        'image': '💉'
      },
      {
        'titre': 'Les bienfaits de l\'allaitement maternel',
        'categorie': 'Nouveau-nés',
        'resume': 'L\'allaitement exclusif jusqu\'à 6 mois offre la meilleure protection à votre bébé.',
        'image': '👶'
      },
      {
        'titre': 'Prévenir le paludisme chez les tout-petits',
        'categorie': 'Prévention',
        'resume': 'Moustiquaires, hygiène et premiers gestes en cas de symptômes.',
        'image': '🦟'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Encyclopédie Santé')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un article...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final a = articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(a['image']!, style: const TextStyle(fontSize: 24)),
                    ),
                    title: Text(
                      a['titre']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            a['categorie']!,
                            style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(a['resume']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
