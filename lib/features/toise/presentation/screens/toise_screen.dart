import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

class ToiseScreen extends StatefulWidget {
  const ToiseScreen({super.key});

  @override
  State<ToiseScreen> createState() => _ToiseScreenState();
}

class _ToiseScreenState extends State<ToiseScreen> {
  bool _isAnalyzing = false;
  double _progress = 0.0;
  double? _result;
  Timer? _timer;

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = true;
      _progress = 0.0;
      _result = null;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.03;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer?.cancel();
          _showResult();
        }
      });
    });
  }

  void _showResult() {
    final random = Random();
    setState(() {
      _isAnalyzing = false;
      _result = 50 + random.nextDouble() * 20; // 50 to 70 cm
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A10),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.04),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toise Augmentée', style: TextStyle(color: AppColors.vertClair)),
            Text('Réalité Augmentée · IA', style: TextStyle(fontSize: 10, color: Colors.white30)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera Grid
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(),
                  ),
                ),
                // Camera View Placeholder
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0A1A10), Color(0xFF0D2217)],
                    ),
                  ),
                ),
                // Notch/Info
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                    child: const Text('📸 Caméra active', style: TextStyle(color: AppColors.vertDoux, fontSize: 9)),
                  ),
                ),
                // Toise Frame
                Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.vertDoux, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      _buildCorner(Alignment.topLeft),
                      _buildCorner(Alignment.topRight),
                      _buildCorner(Alignment.bottomLeft),
                      _buildCorner(Alignment.bottomRight),
                      const Center(child: Opacity(opacity: 0.3, child: Text('👶', style: TextStyle(fontSize: 60)))),
                    ],
                  ),
                ),
                // Ticks
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [80, 60, 40, 20].map((v) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Container(width: 10, height: 1, color: AppColors.vertDoux.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text('${v}cm', style: TextStyle(color: AppColors.vertDoux.withOpacity(0.7), fontSize: 9)),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                const Positioned(
                  bottom: 14,
                  child: Text('Alignez le bébé sur le pagne étalonné', style: TextStyle(color: Colors.white30, fontSize: 10)),
                ),
                if (_isAnalyzing)
                  Container(
                    color: Colors.black45,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: AppColors.vertDoux),
                          const SizedBox(height: 16),
                          Text('Calcul en cours... ${(_progress * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              border: const Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              children: [
                if (_result != null) ...[
                  Text(
                    '${_result!.toStringAsFixed(1)} cm',
                    style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 32, color: AppColors.vertDoux, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Taille estimée · Normal pour 4 mois (OMS)',
                    style: TextStyle(color: Colors.white30, fontSize: 11),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startAnalysis,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.vertForet),
                    child: const Text('💾 Enregistrer dans le carnet'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: _startAnalysis,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.vertForet),
                    child: const Text('Prendre une photo'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          border: Border(
            top: alignment == Alignment.topLeft || alignment == Alignment.topRight ? const BorderSide(color: AppColors.ocre, width: 3) : BorderSide.none,
            bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight ? const BorderSide(color: AppColors.ocre, width: 3) : BorderSide.none,
            left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? const BorderSide(color: AppColors.ocre, width: 3) : BorderSide.none,
            right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? const BorderSide(color: AppColors.ocre, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.vertDoux.withOpacity(0.08)
      ..strokeWidth = 1;

    for (double i = 0; i <= size.width; i += 24) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += 24) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
