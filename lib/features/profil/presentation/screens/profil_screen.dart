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
      backgroundColor: AppColors.vertBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 50),
              decoration: const BoxDecoration(
                color: AppColors.vertForet,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                    ),
                  ),
                  Column(
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const Text('👩', style: TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${userProfile?.prenom ?? "Aicha"} ${userProfile?.nom ?? "Traoré"}',
                        style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${userProfile?.email ?? "aicha@email.com"} · ${userProfile?.telephone ?? "+229 97 00 00 00"}',
                        style: const TextStyle(fontSize: 10, color: AppColors.vertClair),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Container(
              margin: const EdgeInsets.only(top: -24),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  _buildSectionCard([
                    _buildItem('👶', '${userProfile?.nomEnfant ?? "Ibrahim"} · 4 mois', () {}),
                    _buildItem('➕', 'Ajouter un profil', () {}, isAction: true),
                  ]),

                  _buildSectionCard([
                    _buildItem('✏️', 'Modifier le profil', () {}),
                    _buildItem('📋', 'Mes documents médicaux', () => context.push(AppRoutes.scans)),
                    _buildItem('📅', 'Mes rendez-vous', () => context.push(AppRoutes.rdv)),
                    _buildItem('📊', 'Courbe de croissance', () => context.push(AppRoutes.courbe)),
                  ]),

                  _buildSectionCard([
                    _buildItem('⚙️', 'Paramètres', () => context.push(AppRoutes.parametres)),
                    _buildItem('❓', 'Aide & Support', () {}),
                    _buildItem('⭐', 'Évaluer l\'application', () {}),
                  ]),

                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => ref.read(authNotifierProvider.notifier).logout(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: AppColors.terracotta.withOpacity(0.15)),
                        boxShadow: [BoxShadow(color: AppColors.terracotta.withOpacity(0.1), blurRadius: 8)],
                      ),
                      child: const Row(
                        children: [
                          Text('🚪', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 12),
                          Text('Se déconnecter', style: TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.vertForet.withOpacity(0.1), blurRadius: 32)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildItem(String icon, String label, VoidCallback onTap, {bool isAction = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.grisPerle)),
        ),
        child: Row(
          children: [
            SizedBox(width: 24, child: Text(icon, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isAction ? FontWeight.w600 : FontWeight.w500,
                  color: isAction ? AppColors.vertForet : AppColors.noirDoux,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.grisTexte),
          ],
        ),
      ),
    );
  }
}
