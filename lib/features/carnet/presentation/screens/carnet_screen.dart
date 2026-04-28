// ============================================================
// lib/features/carnet/presentation/screens/carnet_screen.dart
// Écran 8 — Carnet de santé avec onglets Vaccins / Scans
// ============================================================

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import 'vaccins_screen.dart';
import 'scans_screen.dart';

class CarnetScreen extends StatelessWidget {
  const CarnetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Carnet Vaccinal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text('Ibrahim · Programme PEV Bénin',
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'VACCINS'),
              Tab(text: 'SCANS'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VaccinsScreen(),
            ScansScreen(),
          ],
        ),
        // FAB pour ajouter un vaccin (visible dans l'onglet Vaccins)
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.addVaccin),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}