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
        backgroundColor: AppColors.vertBg,
        appBar: AppBar(
          backgroundColor: AppColors.vertForet,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Carnet Vaccinal',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ibrahim · Programme PEV Bénin',
                style: TextStyle(fontSize: 12, color: AppColors.vertClair, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Vaccins'),
              Tab(text: 'Scans / Docs'),
            ],
            indicatorColor: AppColors.ocre,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.vertClair,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
