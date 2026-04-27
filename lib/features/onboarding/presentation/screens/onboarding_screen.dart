import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Suivi vaccinal automatique',
      description: 'Recevez des rappels 48h avant chaque vaccin selon le calendrier PEV du Bénin. Ne ratez plus aucun rendez-vous.',
      emoji: '💉',
      color1: AppColors.vertPastel,
      color2: AppColors.vertClair,
    ),
    OnboardingPageData(
      title: 'Comprenez les pleurs de votre bébé',
      description: 'Notre IA analyse les pleurs de votre enfant et identifie s\'il a faim, sommeil ou des coliques pour vous guider immédiatement.',
      emoji: '🔊',
      color1: AppColors.ocreClair,
      color2: AppColors.peche,
    ),
    OnboardingPageData(
      title: 'Trouvez les soins près de vous',
      description: 'Géolocalisez les hôpitaux et centres de vaccination les plus proches et prenez rendez-vous directement depuis l\'application.',
      emoji: '🗺️',
      color1: const Color(0xFFDCF0FF),
      color2: const Color(0xFFB8D8F8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [page.color1, page.color2],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(page.emoji, style: const TextStyle(fontSize: 80)),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _buildStepDot(index == _currentPage),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _pages[_currentPage].title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.vertForet,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pages[_currentPage].description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.vertForet,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Commencer 🎉' : 'Continuer →',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 4,
      width: active ? 24 : 8,
      decoration: BoxDecoration(
        color: active ? AppColors.vertForet : AppColors.grisDoux,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String emoji;
  final Color color1;
  final Color color2;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color1,
    required this.color2,
  });
}
