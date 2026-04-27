import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Général'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            trailing: const Text('Français', style: TextStyle(color: AppColors.primary)),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            subtitle: const Text('Rappels de vaccins et rendez-vous'),
            value: true,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
          const _SectionHeader(title: 'Sécurité'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Changer le mot de passe'),
            onTap: () {},
          ),
          const _SectionHeader(title: 'À propos'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version de l\'application'),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Conditions d\'utilisation'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
