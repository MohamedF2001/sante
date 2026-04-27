import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/widgets/custom_button.dart';

class PleursScreen extends StatefulWidget {
  const PleursScreen({super.key});

  @override
  State<PleursScreen> createState() => _PleursScreenState();
}

class _PleursScreenState extends State<PleursScreen> {
  bool _isAnalyzing = false;
  double _progress = 0.0;
  String? _result;
  int? _confidence;
  Timer? _timer;

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = true;
      _progress = 0.0;
      _result = null;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer?.cancel();
          _showResult();
        }
      });
    });
  }

  void _showResult() {
    final results = ['Faim', 'Fatigue', 'Douleur', 'Besoin de change'];
    final random = Random();
    setState(() {
      _isAnalyzing = false;
      _result = results[random.nextInt(results.length)];
      _confidence = 75 + random.nextInt(20);
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
      appBar: AppBar(title: const Text('Analyse des pleurs')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_rounded, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Enregistrez les pleurs de bébé pour comprendre ses besoins.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            if (_isAnalyzing) ...[
              const Text('Analyse en cours...', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text('Résultat de l\'analyse', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      _result!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text('Confiance : $_confidence%', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Recommencer',
                onPressed: _startAnalysis,
              ),
            ] else ...[
              CustomButton(
                label: 'Démarrer l\'enregistrement',
                icon: Icons.play_arrow,
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
                        'Cette fonctionnalité utilise une IA simulée pour la démonstration.',
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
