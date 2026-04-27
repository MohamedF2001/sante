import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    int getIndex() {
      if (location == '/') return 0;
      if (location == '/carnet') return 1;
      if (location == '/geo') return 2;
      if (location == '/forum') return 3;
      if (location == '/profil') return 4;
      return 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: getIndex(),
          onTap: (index) {
            switch (index) {
              case 0: context.go('/'); break;
              case 1: context.go('/carnet'); break;
              case 2: context.go('/hopitaux'); break;
              case 3: context.go('/forum'); break;
              case 4: context.go('/profil'); break;
            }
          },
          selectedItemColor: AppColors.vertForet,
          unselectedItemColor: AppColors.grisTexte,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            _buildNavItem(Icons.home, Icons.home_outlined, 'Accueil', getIndex() == 0),
            _buildNavItem(Icons.assignment, Icons.assignment_outlined, 'Carnet', getIndex() == 1),
            _buildNavItem(Icons.map, Icons.map_outlined, 'Carte', getIndex() == 2),
            _buildNavItem(Icons.forum, Icons.forum_outlined, 'Ask a Pro', getIndex() == 3),
            _buildNavItem(Icons.person, Icons.person_outline, 'Profil', getIndex() == 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData activeIcon, IconData icon, String label, bool isActive) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          children: [
            Icon(isActive ? activeIcon : icon),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.vertForet,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }
}
