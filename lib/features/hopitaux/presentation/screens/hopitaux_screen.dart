import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class HopitauxScreen extends StatelessWidget {
  const HopitauxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Géo-Santé'),
            Text('Centres de soins près de vous', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Map Placeholder
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
              ),
            ),
            child: Stack(
              children: [
                _buildMapGrid(),
                _buildPin(30, 40, '🏥'),
                _buildPin(50, 65, '🏥'),
                _buildPin(20, 70, '💉'),
                _buildPin(60, 48, '📍', isUser: true),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                    child: const Text('📍 Cotonou, Bénin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.noirDoux)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Text('CENTRES LES PLUS PROCHES', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.grisTexte)),
                const SizedBox(height: 12),
                _buildGeoItem('CS Gbégamey', 'Vaccinations · Urgences pédiatriques', '🏥', '1.2 km'),
                _buildGeoItem('Centre PEV Akpakpa', 'Spécialiste vaccination enfants', '💉', '2.8 km'),
                _buildGeoItem('Hôpital de la Mère et de l\'Enfant', 'Pédiatrie · Maternité', '🏥', '4.1 km'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapGrid() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: CustomPaint(painter: GridPainter()),
      ),
    );
  }

  Widget _buildPin(double top, double left, String icon, {bool isUser = false}) {
    return Positioned(
      top: top * 3, // simplified scaling
      left: left * 3,
      child: Text(icon, style: TextStyle(fontSize: isUser ? 24 : 28)),
    );
  }

  Widget _buildGeoItem(String title, String sub, String icon, String dist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.vertPastel, borderRadius: BorderRadius.circular(11)),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.noirDoux)),
                Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grisTexte), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(dist, style: const TextStyle(color: AppColors.vertForet, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.vertForet..strokeWidth = 1;
    for (double i = 0; i <= size.width; i += 32) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i <= size.height; i += 32) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
