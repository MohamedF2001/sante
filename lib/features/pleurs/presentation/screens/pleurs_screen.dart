// ============================================================
// lib/features/pleurs/presentation/screens/pleurs_screen.dart
// Écran 9 — Analyseur de Pleurs (IA simulée)
// ============================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// Résultats possibles de l'analyse simulée
const _resultats = [
  {'label': 'Faim',     'emoji': '🍼', 'score': 87, 'conseil': 'Votre bébé a probablement faim. Essayez de le nourrir.'},
  {'label': 'Fatigue',  'emoji': '😴', 'score': 74, 'conseil': 'Ibrahim semble fatigué. Créez un environnement calme.'},
  {'label': 'Douleur',  'emoji': '😣', 'score': 62, 'conseil': 'Des coliques possibles. Massez délicatement le ventre.'},
  {'label': 'Inconfort','emoji': '🌡️', 'score': 71, 'conseil': 'Vérifiez la température et les couches.'},
];

enum _AnalyseState { idle, recording, analyzing, result }

class PleursScreen extends StatefulWidget {
  const PleursScreen({super.key});
  @override
  State<PleursScreen> createState() => _PleursScreenState();
}

class _PleursScreenState extends State<PleursScreen>
    with SingleTickerProviderStateMixin {
  _AnalyseState _state = _AnalyseState.idle;
  Map<String, dynamic>? _resultat;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  Timer? _timer;
  int _recordSeconds = 0;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _state = _AnalyseState.recording;
      _recordSeconds = 0;
    });
    // Timer qui compte les secondes d'enregistrement
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _recordSeconds++);
      if (_recordSeconds >= 5) {
        t.cancel();
        _analyser();
      }
    });
  }

  void _analyser() async {
    setState(() => _state = _AnalyseState.analyzing);
    // Simulation d'une analyse IA (2 secondes)
    await Future.delayed(const Duration(seconds: 2));
    final random = Random();
    setState(() {
      _resultat = _resultats[random.nextInt(_resultats.length)];
      _state = _AnalyseState.result;
    });
  }

  void _reset() {
    setState(() {
      _state = _AnalyseState.idle;
      _resultat = null;
      _recordSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analyseur de Pleurs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('IA · Identification des besoins',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Résultat de la dernière analyse ─────────────
            if (_state == _AnalyseState.result && _resultat != null)
              _ResultCard(resultat: _resultat!)
            else
              _PlaceholderCard(state: _state, seconds: _recordSeconds),

            const Spacer(),

            // ── Bouton principal ──────────────────────────────
            if (_state == _AnalyseState.idle || _state == _AnalyseState.result)
              Column(children: [
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _state == _AnalyseState.idle ? _pulseAnim.value : 1.0,
                    child: child,
                  ),
                  child: GestureDetector(
                    onTap: _startRecording,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2),
                      ),
                      child: const Icon(Icons.mic,
                          size: 44, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _state == _AnalyseState.result
                      ? 'Nouvel enregistrement'
                      : 'Appuyez pour enregistrer les pleurs',
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ]),

            // ── Enregistrement en cours ───────────────────────
            if (_state == _AnalyseState.recording)
              Column(children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.danger,
                  ),
                  child: const Icon(Icons.stop,
                      size: 44, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('Enregistrement... ${_recordSeconds}s / 5s',
                    style: const TextStyle(
                        color: AppColors.danger, fontWeight: FontWeight.w600)),
              ]),

            // ── Analyse en cours ─────────────────────────────
            if (_state == _AnalyseState.analyzing)
              const Column(children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Analyse IA en cours...',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final _AnalyseState state;
  final int seconds;
  const _PlaceholderCard({required this.state, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: const Column(
        children: [
          Text('Résultat de la dernière analyse',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3)),
          SizedBox(height: 20),
          Text('🎤', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text('Aucune analyse récente',
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> resultat;
  const _ResultCard({required this.resultat});

  @override
  Widget build(BuildContext context) {
    final score = resultat['score'] as int;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          const Text('Résultat de la dernière analyse',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3)),
          const SizedBox(height: 20),
          Text(resultat['emoji'] as String,
              style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Ibrahim a probablement ${resultat['label']}',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Confiance : $score% · il y a 2 minutes',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          // Barre de confiance
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                  score > 80 ? AppColors.success : AppColors.warning),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(resultat['conseil'] as String,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.primaryLight),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          Text('⚠️ Résultat simulé — Non médical',
              style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}