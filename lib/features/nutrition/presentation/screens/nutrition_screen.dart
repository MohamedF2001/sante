// ============================================================
// lib/features/nutrition/presentation/screens/nutrition_screen.dart
// Écran 16 — Nutrition Locale
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

const _aliments = [
  {'nom': 'Bouillie de mil',    'emoji': '🌾', 'nutrients': 'Fer · Zinc · Énergie',    'couleur': 0xFFFFF8E1},
  {'nom': 'Soja enrichi',       'emoji': '🌱', 'nutrients': 'Protéines complètes',      'couleur': 0xFFE8F5E9},
  {'nom': 'Moringa',            'emoji': '🥬', 'nutrients': 'Vitamines A, C, K',        'couleur': 0xFFE8F5E9},
  {'nom': 'Banane plantain',    'emoji': '🍌', 'nutrients': 'Potassium · Glucides',     'couleur': 0xFFFFF8E1},
  {'nom': 'Arachide',           'emoji': '🥜', 'nutrients': 'Lipides · Protéines',     'couleur': 0xFFFCE4EC},
  {'nom': 'Poisson fumé',       'emoji': '🐟', 'nutrients': 'Oméga-3 · Calcium',       'couleur': 0xFFE3F2FD},
  {'nom': 'Patate douce',       'emoji': '🍠', 'nutrients': 'Vitamine A · Fibres',     'couleur': 0xFFFFF3E0},
  {'nom': 'Gari (manioc)',      'emoji': '🥣', 'nutrients': 'Glucides · Énergie',      'couleur': 0xFFFFF8E1},
];

const _conseils = [
  {
    'age': '0 — 6 mois',
    'titre': 'Allaitement exclusif',
    'conseil': 'Le lait maternel couvre tous les besoins nutritionnels du bébé. Aucun autre aliment n\'est nécessaire.',
    'emoji': '🤱',
    'couleur': 0xFFE8F5E9,
  },
  {
    'age': '6 — 9 mois',
    'titre': 'Diversification alimentaire',
    'conseil': 'Commencer la bouillie de mil enrichie au soja. Introduire purées de légumes (patate douce, carotte).',
    'emoji': '🥣',
    'couleur': 0xFFFFF8E1,
  },
  {
    'age': '9 — 12 mois',
    'titre': 'Aliments de la famille',
    'conseil': 'Poisson écrasé, légumes mixés, arachide pilée. Continuer l\'allaitement. 3 repas par jour.',
    'emoji': '🍽️',
    'couleur': 0xFFE3F2FD,
  },
  {
    'age': '12+ mois',
    'titre': 'Repas complets',
    'conseil': 'Céréales + légumineuses + légumes + poisson/viande. Moringa en poudre pour enrichir les plats.',
    'emoji': '🥗',
    'couleur': 0xFFFCE4EC,
  },
];

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nutrition Locale',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Alimentation béninoise pour bébé',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Conseil du jour ────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('💡', style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text('Conseil du jour · Ibrahim (4 mois)',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight)),
              ]),
              const SizedBox(height: 8),
              const Text(
                'L\'allaitement exclusif est recommandé jusqu\'à 6 mois. À 6 mois, commencez par la bouillie de mil enrichie au soja pour une bonne croissance.',
                style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Conseils par âge ────────────────────────────────
          const Text('PAR TRANCHE D\'ÂGE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          ..._conseils.map((c) => _ConseilCard(conseil: c)),
          const SizedBox(height: 20),

          // ── Aliments recommandés ─────────────────────────────
          const Text('ALIMENTS RECOMMANDÉS (6+ MOIS)',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: _aliments.map((a) => _AlimentCard(aliment: a)).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ConseilCard extends StatelessWidget {
  final Map<String, dynamic> conseil;
  const _ConseilCard({required this.conseil});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(conseil['couleur'] as int),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(children: [
        Text(conseil['emoji'] as String,
            style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(conseil['age'] as String,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3)),
            const SizedBox(height: 2),
            Text(conseil['titre'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 4),
            Text(conseil['conseil'] as String,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

class _AlimentCard extends StatelessWidget {
  final Map<String, dynamic> aliment;
  const _AlimentCard({required this.aliment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(aliment['couleur'] as int),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(aliment['emoji'] as String,
              style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(aliment['nom'] as String,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13)),
          Text(aliment['nutrients'] as String,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}