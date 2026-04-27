import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: AppColors.vertForet,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('NOTIFICATIONS', [
              _buildToggleItem('💉', 'Rappels vaccins', '48h avant chaque vaccin', true),
              _buildToggleItem('📅', 'Rappels rendez-vous', '24h avant le RDV', true),
              _buildToggleItem('📈', 'Alertes croissance', 'Courbe OMS hors norme', true),
              _buildToggleItem('💬', 'Réponses Ask a Pro', 'Nouvelles réponses', false),
            ]),
            _buildSection('ACCESSIBILITÉ', [
              _buildToggleItem('📱', 'Mode USSD / SMS', 'Recevoir les rappels sans internet', true),
              _buildToggleItem('📶', 'Mode hors-ligne', 'Synchronisation auto', true),
              _buildNavItem('🌐', 'Langue', 'Français', () {}),
            ]),
            _buildSection('CONFIDENTIALITÉ & DONNÉES', [
              _buildToggleItem('🔒', 'Verrouillage par code PIN', 'Sécuriser l\'accès', false),
              _buildToggleItem('☁️', 'Sauvegarde cloud', 'Données chiffrées', true),
              _buildNavItem('📤', 'Exporter mes données', 'PDF ou partage', () {}),
            ]),
            _buildSection('À PROPOS', [
              _buildInfoItem('ℹ️', 'Version 1.0.0', 'Santé Famille · E-Carnet Bénin'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
          child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.grisTexte)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildToggleItem(String icon, String title, String sub, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.grisPerle))),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.noirDoux)),
                Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grisTexte)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (v) {},
            activeColor: AppColors.vertDoux,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String title, String sub, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.grisPerle))),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.noirDoux)),
                  Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grisTexte)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.grisTexte),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.noirDoux)),
              Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grisTexte)),
            ],
          ),
        ],
      ),
    );
  }
}
