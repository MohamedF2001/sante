// ============================================================
// lib/features/hopitaux/presentation/screens/hopitaux_screen.dart
// Écran 11 — Géo-Santé : centres de soins proches (mock data)
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// Mock data des centres de santé au Bénin
const _centres = [
  {
    'nom': 'CS Gbégamey',
    'type': 'Vaccinations · Urgences pédiatriques',
    'distance': '1.2 km',
    'icon': '🏥',
    'horaires': 'Lun-Ven 8h-17h · Sam 8h-13h',
    'telephone': '+229 21 30 00 00',
  },
  {
    'nom': 'Centre PEV Akpakpa',
    'type': 'Spécialiste vaccination enfants',
    'distance': '2.8 km',
    'icon': '💉',
    'horaires': 'Lun-Ven 8h-16h',
    'telephone': '+229 21 33 12 34',
  },
  {
    'nom': 'Hôpital de la Mère et de l\'Enfant',
    'type': 'Pédiatrie · Maternité',
    'distance': '4.1 km',
    'icon': '👶',
    'horaires': '24h/24 · 7j/7',
    'telephone': '+229 21 30 05 05',
  },
  {
    'nom': 'CHU-MEL',
    'type': 'Centre hospitalier universitaire',
    'distance': '5.3 km',
    'icon': '🏨',
    'horaires': '24h/24',
    'telephone': '+229 21 30 01 55',
  },
  {
    'nom': 'Clinique Atinkanmey',
    'type': 'Pédiatrie · Médecine générale',
    'distance': '6.7 km',
    'icon': '🩺',
    'horaires': 'Lun-Sam 7h30-20h',
    'telephone': '+229 97 00 11 22',
  },
];

class HopitauxScreen extends StatefulWidget {
  const HopitauxScreen({super.key});
  @override
  State<HopitauxScreen> createState() => _HopitauxScreenState();
}

class _HopitauxScreenState extends State<HopitauxScreen> {
  String _filtre = 'Tous';
  final _filtres = ['Tous', 'Vaccination', 'Urgences', 'Pédiatrie'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Géo-Santé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Centres de soins près de vous',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Carte simulée ──────────────────────────────────
        Container(
          height: 180,
          width: double.infinity,
          color: const Color(0xFFD7EDD4),
          child: Stack(children: [
            // Grille de carte
            CustomPaint(painter: _MapPainter(), size: Size.infinite),
            // Icônes hospitals
            const Positioned(
                left: 180, top: 60,
                child: Text('🏥', style: TextStyle(fontSize: 28))),
            const Positioned(
                left: 80, top: 90,
                child: Text('💉', style: TextStyle(fontSize: 22))),
            const Positioned(
                left: 260, top: 100,
                child: Text('🏥', style: TextStyle(fontSize: 24))),
            // Badge position
            Positioned(
              bottom: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.danger),
                  SizedBox(width: 4),
                  Text('Cotonou, Bénin',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
        ),

        // ── Filtres ────────────────────────────────────────
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filtres.length,
            itemBuilder: (_, i) {
              final f = _filtres[i];
              final selected = _filtre == f;
              return GestureDetector(
                onTap: () => setState(() => _filtre = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(
                    child: Text(f,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textSecondary)),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Titre liste ────────────────────────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('CENTRES LES PLUS PROCHES',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary)),
          ),
        ),

        // ── Liste ──────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _centres.length,
            itemBuilder: (_, i) => _CentreCard(centre: _centres[i]),
          ),
        ),
      ]),
    );
  }
}

class _CentreCard extends StatelessWidget {
  final Map<String, dynamic> centre;
  const _CentreCard({required this.centre});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(children: [
        // Icône
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(centre['icon'] as String,
                  style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),

        // Infos
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(centre['nom'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(centre['type'] as String,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(centre['horaires'] as String,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight)),
            ],
          ),
        ),

        // Distance
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(centre['distance'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 13)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.phone_outlined,
                  size: 18, color: AppColors.textLight),
            ),
          ],
        ),
      ]),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8DDB8).withOpacity(0.5)
      ..strokeWidth = 1;
    // Rues horizontales
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Rues verticales
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}