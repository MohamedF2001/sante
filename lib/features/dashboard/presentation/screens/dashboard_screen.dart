import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/constants/app_routes.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour, ${userProfile?.prenom ?? "Parent"} 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Suivez la santé de ${userProfile?.nomEnfant ?? "votre enfant"} en toute sérénité.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _DashboardCard(
                  title: 'Carnet de santé',
                  icon: Icons.menu_book_rounded,
                  color: Colors.blue.shade100,
                  iconColor: Colors.blue.shade700,
                  onTap: () => context.push(AppRoutes.carnet),
                ),
                _DashboardCard(
                  title: 'Analyse Pleurs',
                  icon: Icons.mic_rounded,
                  color: Colors.purple.shade100,
                  iconColor: Colors.purple.shade700,
                  onTap: () => context.push(AppRoutes.pleurs),
                ),
                _DashboardCard(
                  title: 'Mesure Taille',
                  icon: Icons.straighten_rounded,
                  color: Colors.orange.shade100,
                  iconColor: Colors.orange.shade700,
                  onTap: () => context.push(AppRoutes.toise),
                ),
                _DashboardCard(
                  title: 'Hôpitaux',
                  icon: Icons.local_hospital_rounded,
                  color: Colors.red.shade100,
                  iconColor: Colors.red.shade700,
                  onTap: () => context.push(AppRoutes.hopitaux),
                ),
                _DashboardCard(
                  title: 'Encyclopédie',
                  icon: Icons.library_books_rounded,
                  color: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  onTap: () => context.push(AppRoutes.encyclopedie),
                ),
                _DashboardCard(
                  title: 'Nutrition',
                  icon: Icons.restaurant_rounded,
                  color: Colors.teal.shade100,
                  iconColor: Colors.teal.shade700,
                  onTap: () => context.push(AppRoutes.nutrition),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Conseils du jour',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _TipCard(
                    text: 'Sommeil : Comment aider bébé à faire ses nuits ?',
                    color: Colors.indigo.shade50,
                  ),
                  _TipCard(
                    text: 'Diversification : Les premiers légumes à introduire.',
                    color: Colors.green.shade50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String text;
  final Color color;

  const _TipCard({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
