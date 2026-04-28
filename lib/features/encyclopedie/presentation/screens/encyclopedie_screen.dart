// ============================================================
// lib/features/encyclopedie/presentation/screens/encyclopedie_screen.dart
// Écran 15 — Encyclopédie Santé
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

const _articles = [
  {
    'titre': 'Paludisme (Malaria)',
    'desc': 'Fièvre, frissons, maux de tête. Cause principale de mortalité infantile au Bénin. Traitement à débuter dans les 24h.',
    'emoji': '🦟',
    'tag': 'Urgence',
    'tagColor': 0xFFE53935,
    'frequence': 'Fréquent',
    'categorie': 'Maladies',
  },
  {
    'titre': 'Diarrhée aiguë',
    'desc': 'Première cause de déshydratation chez le nourrisson. Solution de réhydratation orale (SRO) à préparer immédiatement.',
    'emoji': '💧',
    'tag': 'Fréquent',
    'tagColor': 0xFFF9A825,
    'frequence': 'Fréquent',
    'categorie': 'Maladies',
  },
  {
    'titre': 'Infections respiratoires',
    'desc': 'Toux, difficultés à respirer, sifflement. Deuxième cause de mortalité des enfants de moins de 5 ans.',
    'emoji': '🫁',
    'tag': 'Commun',
    'tagColor': 0xFF1565C0,
    'frequence': 'Commun',
    'categorie': 'Maladies',
  },
  {
    'titre': 'Malnutrition',
    'desc': 'Insuffisance pondérale, retard de croissance. Détectable par la courbe OMS intégrée dans l\'application.',
    'emoji': '⚖️',
    'tag': 'Prévention',
    'tagColor': 0xFF2E7D32,
    'frequence': 'Commun',
    'categorie': 'Prévention',
  },
  {
    'titre': 'Fièvre chez le nourrisson',
    'desc': 'Température > 38°C chez un bébé de moins de 3 mois = consultation immédiate. Au-delà, surveiller 24h.',
    'emoji': '🌡️',
    'tag': 'Urgence',
    'tagColor': 0xFFE53935,
    'frequence': 'Fréquent',
    'categorie': 'Premiers soins',
  },
  {
    'titre': 'Vaccination — Calendrier PEV',
    'desc': 'Le programme élargi de vaccination protège contre 12 maladies. Respecter le calendrier est essentiel pour la protection.',
    'emoji': '💉',
    'tag': 'Prévention',
    'tagColor': 0xFF2E7D32,
    'frequence': 'Important',
    'categorie': 'Prévention',
  },
];

class EncyclopedieScreen extends StatefulWidget {
  const EncyclopedieScreen({super.key});
  @override
  State<EncyclopedieScreen> createState() => _EncyclopedieScreenState();
}

class _EncyclopedieScreenState extends State<EncyclopedieScreen> {
  String _search    = '';
  String _categorie = 'Toutes';
  final _categories = ['Toutes', 'Maladies', 'Prévention', 'Premiers soins'];

  List<Map<String, dynamic>> get _filtered => _articles.where((a) {
    final matchSearch = a['titre'].toString().toLowerCase().contains(_search.toLowerCase()) ||
        a['desc'].toString().toLowerCase().contains(_search.toLowerCase());
    final matchCat = _categorie == 'Toutes' || a['categorie'] == _categorie;
    return matchSearch && matchCat;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Encyclopédie Santé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Maladies & conseils',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Barre de recherche ─────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Rechercher une maladie...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // ── Filtres catégories ─────────────────────────────
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _categories.map((cat) {
              final selected = _categorie == cat;
              return GestureDetector(
                onTap: () => setState(() => _categorie = cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(
                    child: Text(cat,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textSecondary)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // ── Liste des articles ─────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filtered.length,
            itemBuilder: (_, i) => _ArticleCard(article: _filtered[i]),
          ),
        ),
      ]),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final tagColor = Color(article['tagColor'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(article['emoji'] as String,
              style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(article['titre'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: tagColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20)),
            child: Text(article['tag'] as String,
                style: TextStyle(
                    color: tagColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(article['desc'] as String,
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5)),
      ]),
    );
  }
}