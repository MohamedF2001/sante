// ============================================================
// lib/features/profil/presentation/screens/parametres_screen.dart
// Écran 14 — Paramètres
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});
  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  // États des toggles
  bool _rappelsVaccins     = true;
  bool _rappelsRdv         = true;
  bool _alertesCroissance  = true;
  bool _reponsesAskAPro    = false;
  bool _verrouillagePin    = false;
  bool _sauvegardeCloud    = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── NOTIFICATIONS ────────────────────────────────
          _SectionTitle('NOTIFICATIONS'),
          _SettingsCard(children: [
            _ToggleTile(
              icon: Icons.vaccines_outlined,
              iconColor: AppColors.primary,
              title: 'Rappels vaccins',
              subtitle: '48h avant chaque vaccin',
              value: _rappelsVaccins,
              onChanged: (v) => setState(() => _rappelsVaccins = v),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ToggleTile(
              icon: Icons.calendar_today_outlined,
              iconColor: AppColors.primaryLight,
              title: 'Rappels rendez-vous',
              subtitle: '24h avant le RDV',
              value: _rappelsRdv,
              onChanged: (v) => setState(() => _rappelsRdv = v),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ToggleTile(
              icon: Icons.bar_chart_outlined,
              iconColor: AppColors.warning,
              title: 'Alertes croissance',
              subtitle: 'Courbe OMS hors norme',
              value: _alertesCroissance,
              onChanged: (v) => setState(() => _alertesCroissance = v),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ToggleTile(
              icon: Icons.chat_bubble_outline,
              iconColor: AppColors.textSecondary,
              title: 'Réponses Ask a Pro',
              subtitle: 'Nouvelles réponses à vos questions',
              value: _reponsesAskAPro,
              onChanged: (v) => setState(() => _reponsesAskAPro = v),
            ),
          ]),
          const SizedBox(height: 16),

          // ── ACCESSIBILITÉ ────────────────────────────────
          _SectionTitle('ACCESSIBILITÉ'),
          _SettingsCard(children: [
            _ActionTile(
              icon: Icons.language_outlined,
              title: 'Changer de langue',
              subtitle: 'Français · Fon · Yoruba',
              onTap: () => _showLanguageDialog(context),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ActionTile(
              icon: Icons.phone_outlined,
              title: 'Mode USSD / Hors-ligne',
              subtitle: 'Accès sans internet',
              onTap: () => _showUssdDialog(context),
            ),
          ]),
          const SizedBox(height: 16),

          // ── CONFIDENTIALITÉ & DONNÉES ────────────────────
          _SectionTitle('CONFIDENTIALITÉ & DONNÉES'),
          _SettingsCard(children: [
            _ToggleTile(
              icon: Icons.lock_outline,
              iconColor: AppColors.warning,
              title: 'Verrouillage par code PIN',
              subtitle: 'Sécuriser l\'accès à vos données',
              value: _verrouillagePin,
              onChanged: (v) => setState(() => _verrouillagePin = v),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ToggleTile(
              icon: Icons.cloud_outlined,
              iconColor: AppColors.primary,
              title: 'Sauvegarde cloud',
              subtitle: 'Données chiffrées et sécurisées',
              value: _sauvegardeCloud,
              onChanged: (v) => setState(() => _sauvegardeCloud = v),
            ),
            const Divider(height: 1, color: AppColors.border),
            _ActionTile(
              icon: Icons.download_outlined,
              title: 'Exporter mes données',
              subtitle: 'PDF ou partage avec un médecin',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          // ── À PROPOS ─────────────────────────────────────
          _SectionTitle('À PROPOS'),
          _SettingsCard(children: [
            _ActionTile(
              icon: Icons.info_outline,
              title: 'Version 1.0.0',
              subtitle: 'Santé Famille · E-Carnet Bénin',
              onTap: () {},
            ),
            const Divider(height: 1, color: AppColors.border),
            _ActionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Politique de confidentialité',
              onTap: () {},
            ),
            const Divider(height: 1, color: AppColors.border),
            _ActionTile(
              icon: Icons.description_outlined,
              title: 'Conditions d\'utilisation',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choisir une langue'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final lang in ['🇫🇷 Français', '🇧🇯 Fon', '🇧🇯 Yoruba'])
            ListTile(
              title: Text(lang),
              onTap: () => Navigator.pop(context),
            ),
        ]),
      ),
    );
  }

  void _showUssdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mode USSD'),
        content: const Text(
            'Composez *123# pour accéder à Santé Famille sans internet.\n\nDisponible sur tous les réseaux Bénin.'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compris')),
        ],
      ),
    );
  }
}

// ── Widgets helpers ──────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary)),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border, width: 0.5),
    ),
    child: Column(children: children),
  );
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: iconColor, size: 22),
    title: Text(title, style: const TextStyle(fontSize: 14)),
    subtitle: Text(subtitle,
        style: const TextStyle(
            fontSize: 12, color: AppColors.textSecondary)),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    ),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    dense: true,
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: AppColors.textSecondary, size: 22),
    title: Text(title, style: const TextStyle(fontSize: 14)),
    subtitle: subtitle != null
        ? Text(subtitle!,
        style: const TextStyle(
            fontSize: 12, color: AppColors.textSecondary))
        : null,
    trailing: const Icon(Icons.chevron_right,
        color: AppColors.textLight, size: 20),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    dense: true,
  );
}