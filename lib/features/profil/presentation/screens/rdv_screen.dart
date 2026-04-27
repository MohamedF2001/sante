import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class RdvScreen extends StatelessWidget {
  const RdvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rendez-vous'),
            Text('Calendrier médical · Avril 2026', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Calendar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: AppColors.vertForet.withOpacity(0.08), blurRadius: 20),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.chevron_left, color: AppColors.grisTexte),
                      Text('Avril 2026', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const Icon(Icons.chevron_right, color: AppColors.grisTexte),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'PROCHAINS RENDEZ-VOUS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.grisTexte),
            ),
            const SizedBox(height: 8),
            _buildRdvItem('Vaccin DTC-HepB-Hib 3', 'Ven. 04 Avril · 09h00 · CS Gbégamey', '💉', 'Dans 2j'),
            _buildRdvItem('Pesée mensuelle', 'Sam. 12 Avril · 10h30 · CS Gbégamey', '🩺', 'Dans 10j'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Prendre un nouveau rendez-vous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vertForet,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((d) => Text(d, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.grisTexte))).toList(),
        ),
        const SizedBox(height: 8),
        // Simplification pour la maquette
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: 31,
          itemBuilder: (context, index) {
            int day = index + 1;
            bool isToday = day == 2;
            bool isEvent = day == 4;
            bool isSel = day == 12;

            return Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isToday ? AppColors.vertForet : (isEvent ? AppColors.ocreClair : (isSel ? AppColors.vertPastel : null)),
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: (isToday || isEvent || isSel) ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.white : (isEvent ? AppColors.terracotta : (isSel ? AppColors.vertForet : AppColors.grisTexte)),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRdvItem(String title, String sub, String icon, String chip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.vertPastel, borderRadius: BorderRadius.circular(11)),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.noirDoux)),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.grisTexte)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.vertPastel, borderRadius: BorderRadius.circular(20)),
            child: Text(chip, style: const TextStyle(color: AppColors.vertForet, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
