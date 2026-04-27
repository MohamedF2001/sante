import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/constants/app_routes.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.parametres),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primarySurface,
                    child: Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${userProfile?.prenom ?? ""} ${userProfile?.nom ?? ""}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              userProfile?.email ?? "",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(userProfile),
            const SizedBox(height: 24),
            _buildActionList(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.child_care, 'Enfant', user?.nomEnfant ?? "-"),
          const Divider(),
          _infoRow(Icons.phone, 'Téléphone', user?.telephone ?? "-"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionList(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _actionTile(Icons.show_chart, 'Courbe de croissance', () {}),
        _actionTile(Icons.calendar_today, 'Mes rendez-vous', () {}),
        _actionTile(Icons.people_outline, 'Ajouter un profil enfant', () {}),
        _actionTile(Icons.help_outline, 'Support & Aide', () {}),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.danger),
          title: const Text('Déconnexion', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          onTap: () => ref.read(authNotifierProvider.notifier).logout(),
        ),
      ],
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
