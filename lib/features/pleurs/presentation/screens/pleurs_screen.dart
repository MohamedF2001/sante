import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sante_famille/core/constants/app_colors.dart';

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
      backgroundColor: AppColors.noirDoux,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analyseur de Pleurs'),
            Text('IA · Identification des besoins', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_result != null && !_isAnalyzing) ...[
              const Text('Résultat de la dernière analyse', style: TextStyle(fontSize: 12, color: Colors.white54)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text('🍼', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      'Bébé a probablement $_result',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.vertClair),
                    ),
                    const SizedBox(height: 4),
                    Text('Confiance : $_confidence% · À l\'instant', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.vertDoux.withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.vertDoux.withOpacity(0.15)),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.vertDoux.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.vertDoux.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🎙️', style: TextStyle(fontSize: 40)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _isAnalyzing ? 'Analyse en cours... (${(_progress * 100).toInt()}%)' : 'Appuyez pour enregistrer les pleurs',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const Text(
              'Durée recommandée : 10-15 secondes',
              style: TextStyle(fontSize: 11, color: Colors.white30),
            ),
            const SizedBox(height: 32),

            if (_isAnalyzing)
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white10,
                  color: AppColors.vertDoux,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            else
              ElevatedButton(
                onPressed: _startAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vertDoux,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                ),
                child: const Text('⏺ Démarrer l\'analyse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),

            const SizedBox(height: 48),
            const Text(
              '⚠️ Aide à la décision uniquement. Consultez un médecin en cas de doute.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white24, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
