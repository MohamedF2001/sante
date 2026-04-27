import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/widgets/custom_button.dart';

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
      appBar: AppBar(title: const Text('Mesure de taille AR')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.straighten_rounded, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Prenez une photo de votre enfant à côté d\'un objet de référence pour mesurer sa taille.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            if (_isAnalyzing) ...[
              const Text('Calcul de la taille...', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.border,
                color: AppColors.primary,
                minHeight: 10,
              ),
              const SizedBox(height: 8),
              Text('${(_progress * 100).toInt()}%'),
            ] else if (_result != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  children: [
                    const Text('Taille estimée', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '${_result!.toStringAsFixed(1)} cm',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Nouvelle mesure',
                onPressed: _startAnalysis,
              ),
            ] else ...[
              CustomButton(
                label: 'Prendre une photo',
                icon: Icons.camera_alt,
                onPressed: _startAnalysis,
              ),
            ],
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cette fonctionnalité utilise une simulation de réalité augmentée.',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
