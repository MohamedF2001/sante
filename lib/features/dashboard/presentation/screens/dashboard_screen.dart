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
      backgroundColor: AppColors.vertBg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: AppColors.vertForet,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -20,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BONJOUR 👋',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.vertClair,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${userProfile?.prenom ?? "Parent"} ${userProfile?.nom ?? ""}',
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.ocre,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.vertForet, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Baby Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.ocreClair,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('👶', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfile?.nomEnfant ?? "Mon enfant",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const Text(
                                  '4 mois · 5.2 kg · 58 cm',
                                  style: TextStyle(color: AppColors.vertClair, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.ocre,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ACTIF',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚠️ ALERTE DU JOUR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.grisTexte,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.ocreClair, Color(0xFFFFF8EC)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: const Border(left: BorderSide(color: AppColors.ocre, width: 4)),
                    ),
                    child: const Row(
                      children: [
                        Text('💉', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vaccin DTC dans 2 jours',
                                style: TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                'Centre de santé Gbégamey · 09h00',
                                style: TextStyle(color: AppColors.grisTexte, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MES MODULES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.grisTexte,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.4,
                    children: [
                      _buildModule(
                        'Carnet Santé',
                        'Vaccins & docs',
                        '📋',
                        AppColors.vertPastel,
                        () => context.push(AppRoutes.carnet),
                      ),
                      _buildModule(
                        'Pleurs IA',
                        'Analyser',
                        '🔊',
                        AppColors.ocreClair,
                        () => context.push(AppRoutes.pleurs),
                      ),
                      _buildModule(
                        'Toise AR',
                        'Mesurer',
                        '📏',
                        AppColors.peche,
                        () => context.push(AppRoutes.toise),
                      ),
                      _buildModule(
                        'Géo-Santé',
                        'Centres proches',
                        '🗺️',
                        const Color(0xFFDCF0FF),
                        () => context.push(AppRoutes.hopitaux),
                      ),
                      _buildModule(
                        'Encyclopédie',
                        'Conseils',
                        '📚',
                        const Color(0xFFE8F5E9),
                        () => context.push(AppRoutes.encyclopedie),
                      ),
                      _buildModule(
                        'Nutrition',
                        'Alimentation',
                        '🍽️',
                        AppColors.peche,
                        () => context.push(AppRoutes.nutrition),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModule(String title, String sub, String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(sub, style: const TextStyle(color: AppColors.grisTexte, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
