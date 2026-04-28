// ============================================================
// lib/features/toise/presentation/screens/toise_screen.dart
// Écran 10 — Toise Augmentée (IA simulée)
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ToiseScreen extends StatefulWidget {
  const ToiseScreen({super.key});
  @override
  State<ToiseScreen> createState() => _ToiseScreenState();
}

class _ToiseScreenState extends State<ToiseScreen> {
  bool _cameraActive = false;
  bool _analyzing    = false;
  double? _tailleEstimee;

  Future<void> _prisePhoto() async {
    setState(() { _cameraActive = true; _analyzing = false; _tailleEstimee = null; });
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    // Simulation : taille entre 55 et 65 cm
    final taille = 55.0 + Random().nextDouble() * 10;
    setState(() {
      _tailleEstimee = double.parse(taille.toStringAsFixed(1));
      _analyzing = false;
      _cameraActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toise Augmentée',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Zone caméra simulée
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _cameraActive ? Colors.black87 : AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: _cameraActive ? AppColors.warning : AppColors.border, width: 2),
            ),
            child: Stack(alignment: Alignment.center, children: [
              if (_cameraActive) ...[
                // Grille de guidage
                CustomPaint(painter: _GridPainter(), size: const Size(300, 300)),
                // Emoji bébé
                const Text('👶', style: TextStyle(fontSize: 60)),
                // Label caméra active
                Positioned(
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Caméra active',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: Text('Alignez le bébé sur la page étalonnée',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ] else if (_analyzing) ...[
                const CircularProgressIndicator(color: AppColors.primary),
              ] else ...[
                const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.textLight),
                  SizedBox(height: 12),
                  Text('Appuyez pour activer la caméra',
                      style: TextStyle(color: AppColors.textSecondary)),
                ]),
              ],
            ]),
          ),

          const SizedBox(height: 24),

          // Résultat
          if (_tailleEstimee != null) ...[
            Text(
              '${_tailleEstimee} cm',
              style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryLight),
            ),
            const Text('Taille estimée · Normal pour 4 mois (OMS)',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('⚠️ Résultat simulé — Non médical',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryLight)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Enregistrer dans le carnet'),
              ),
            ),
          ],

          const Spacer(),

          // Bouton prendre photo
          if (_tailleEstimee == null)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _cameraActive || _analyzing ? null : _prisePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre une photo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

          if (_tailleEstimee != null)
            TextButton(
              onPressed: () => setState(() => _tailleEstimee = null),
              child: const Text('Nouvelle mesure'),
            ),
        ]),
      ),
    );
  }
}

// Peintre pour la grille de guidage caméra
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.warning.withOpacity(0.5)
      ..strokeWidth = 1;
    // Lignes horizontales et verticales
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, size.height * i / 5),
          Offset(size.width, size.height * i / 5), paint);
      canvas.drawLine(Offset(size.width * i / 5, 0),
          Offset(size.width * i / 5, size.height), paint);
    }
    // Rectangle de guidage
    final rect = Rect.fromLTWH(
        size.width * 0.1, size.height * 0.05,
        size.width * 0.8, size.height * 0.9);
    canvas.drawRect(
        rect,
        Paint()
          ..color = AppColors.warning
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}