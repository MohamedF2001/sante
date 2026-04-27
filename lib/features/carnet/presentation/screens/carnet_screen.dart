import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/features/carnet/presentation/screens/vaccins_screen.dart';
import 'package:sante_famille/features/carnet/presentation/screens/scans_screen.dart';

class CarnetScreen extends StatelessWidget {
  const CarnetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Carnet de santé'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Vaccins', icon: Icon(Icons.vaccines)),
              Tab(text: 'Scans / Docs', icon: Icon(Icons.document_scanner)),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const TabBarView(
          children: [
            VaccinsScreen(),
            ScansScreen(),
          ],
        ),
      ),
    );
  }
}
