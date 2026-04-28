// ============================================================
// lib/features/dashboard/presentation/screens/dashboard_screen.dart
// Écran 7 — Dashboard principal avec Bottom Navigation
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../carnet/presentation/screens/carnet_screen.dart';
import '../../../forum/presentation/screens/forum_screen.dart';
import '../../../profil/presentation/screens/profil_screen.dart';

// Provider pour l'index de l'onglet sélectionné
final bottomNavIndexProvider = StateProvider<int>((_) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // Pages associées aux onglets de la bottom navigation
  static const List<Widget> _pages = [
    _HomeTab(),
     CarnetScreen(),
    // Carte (placeholder)
    _CarteTab(),
    ForumScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Accueil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book),
                label: 'Carnet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'Carte'),
            BottomNavigationBarItem(
                icon: Icon(Icons.forum_outlined),
                activeIcon: Icon(Icons.forum),
                label: 'Forum'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

// ── Onglet Accueil (Home) ────────────────────────────────────
class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar verte avec profil enfant ─────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                child: userAsync.when(
                  data: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('BONJOUR 👋',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                              Text(
                                user?.fullName ?? 'Utilisateur',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          // Cloche notifications
                          Stack(children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 22),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: AppColors.warning,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Carte enfant
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text('👶',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user?.nomEnfant ?? 'Enfant',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const Text('4 mois · 5.2 kg · 58 cm',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text('ACTIF',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5)),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
            actions: const [],
          ),

          // ── Corps de l'accueil ───────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Alerte du jour
                _AlerteWidget(),
                const SizedBox(height: 20),

                // Titre modules
                const Text('MES MODULES',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 12),

                // Grille des 6 modules
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: const [
                    _ModuleCard(
                      icon: '📒',
                      title: 'Carnet Santé',
                      subtitle: 'Vaccins & docs',
                      route: AppRoutes.carnet,
                      color: Color(0xFFE8F5E9),
                    ),
                    _ModuleCard(
                      icon: '🎤',
                      title: 'Pleurs IA',
                      subtitle: 'Analyser',
                      route: AppRoutes.pleurs,
                      color: Color(0xFFFFF8E1),
                    ),
                    _ModuleCard(
                      icon: '📏',
                      title: 'Toise AR',
                      subtitle: 'Mesurer',
                      route: AppRoutes.toise,
                      color: Color(0xFFE3F2FD),
                    ),
                    _ModuleCard(
                      icon: '🗺️',
                      title: 'Géo-Santé',
                      subtitle: 'Centres proches',
                      route: AppRoutes.hopitaux,
                      color: Color(0xFFF3E5F5),
                    ),
                    _ModuleCard(
                      icon: '📚',
                      title: 'Encyclopédie',
                      subtitle: 'Maladies & conseils',
                      route: AppRoutes.encyclopedie,
                      color: Color(0xFFE0F7FA),
                    ),
                    _ModuleCard(
                      icon: '🥗',
                      title: 'Nutrition',
                      subtitle: 'Alimentation locale',
                      route: AppRoutes.nutrition,
                      color: Color(0xFFFCE4EC),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget alerte du jour
class _AlerteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.warning_amber_rounded,
                color: AppColors.warning, size: 16),
            SizedBox(width: 6),
            Text('ALERTE DU JOUR',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.warning)),
          ]),
          const SizedBox(height: 8),
          const Text('Vaccin DTC dans 2 jours',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.warning)),
          const SizedBox(height: 2),
          const Text('Centre de santé Gbégamey · 09h00',
              style:
              TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// Carte de module
class _ModuleCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const Spacer(),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// Placeholder onglet Carte
class _CarteTab extends StatelessWidget {
  const _CarteTab();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🗺️', style: TextStyle(fontSize: 60)),
            SizedBox(height: 12),
            Text('Carte des centres de santé',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}