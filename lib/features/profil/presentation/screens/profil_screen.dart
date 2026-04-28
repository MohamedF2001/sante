// ============================================================
// lib/features/profil/presentation/screens/profil_screen.dart
// Écran 13 — Profil utilisateur
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (user) => CustomScrollView(
          slivers: [
            // ── Header vert avec photo et nom ─────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      // Avatar
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white24,
                        child: Text(
                          user?.prenom.isNotEmpty == true
                              ? user!.prenom[0].toUpperCase()
                              : '👤',
                          style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(user?.fullName ?? 'Utilisateur',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      Text(
                        '${user?.email ?? ''} · ${user?.telephone ?? ''}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              actions: const [],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Enfants ─────────────────────────────────
                  _SectionTitle(title: 'MES ENFANTS'),
                  _ProfileCard(children: [
                    if (user != null)
                      ...user.enfants.map((e) => Column(
                            children: [
                              _ChildTile(nom: e.nom, age: 'Enfant'),
                              const Divider(height: 1, color: AppColors.border),
                            ],
                          )),
                    _ActionTile(
                      icon: Icons.add_circle_outline,
                      label: 'Ajouter un profil',
                      iconColor: AppColors.primary,
                      labelColor: AppColors.primary,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.ajouterEnfant),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // ── Mon compte ───────────────────────────────
                  _SectionTitle(title: 'MON COMPTE'),
                  _ProfileCard(children: [
                    _ActionTile(
                      icon: Icons.edit_outlined,
                      label: 'Modifier le profil',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.modifierProfil),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _ActionTile(
                      icon: Icons.folder_outlined,
                      label: 'Mes documents médicaux',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.scans),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _ActionTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Mes rendez-vous',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _ActionTile(
                      icon: Icons.bar_chart_outlined,
                      label: 'Courbe de croissance',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.growthCurve),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // ── Paramètres & Support ─────────────────────
                  _SectionTitle(title: 'PARAMÈTRES'),
                  _ProfileCard(children: [
                    _ActionTile(
                      icon: Icons.settings_outlined,
                      label: 'Paramètres',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.parametres),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _ActionTile(
                      icon: Icons.help_outline,
                      label: 'Aide & Support',
                      onTap: () async {
                        final url = Uri.parse('https://wa.me/22969726550');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _ActionTile(
                      icon: Icons.star_outline,
                      label: 'Évaluer l\'application',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // ── Déconnexion ──────────────────────────────
                  _ProfileCard(children: [
                    _ActionTile(
                      icon: Icons.logout,
                      label: 'Se déconnecter',
                      iconColor: AppColors.danger,
                      labelColor: AppColors.danger,
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Se déconnecter ?'),
                            content: const Text(
                                'Vous devrez vous reconnecter pour accéder à vos données.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Annuler')),
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Se déconnecter',
                                      style:
                                      TextStyle(color: AppColors.danger))),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.login, (_) => false);
                          }
                        }
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Version
                  const Center(
                    child: Text('Santé Famille · Version 1.0.0 · E-Carnet Bénin',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textLight)),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets helpers ──────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
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

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileCard({required this.children});
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color labelColor;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor = AppColors.textSecondary,
    this.labelColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: iconColor, size: 22),
    title: Text(label,
        style: TextStyle(fontSize: 14, color: labelColor)),
    trailing: const Icon(Icons.chevron_right,
        color: AppColors.textLight, size: 20),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    dense: true,
  );
}

class _ChildTile extends StatelessWidget {
  final String nom;
  final String age;
  const _ChildTile({required this.nom, required this.age});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Text('👶', style: TextStyle(fontSize: 24)),
    title: Text(nom,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600)),
    subtitle: Text(age,
        style: const TextStyle(
            fontSize: 12, color: AppColors.textSecondary)),
    trailing: const Icon(Icons.chevron_right,
        color: AppColors.textLight, size: 20),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: true,
  );
}