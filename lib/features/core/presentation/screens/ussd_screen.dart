import 'package:flutter/material.dart';

class UssdScreen extends StatelessWidget {
  const UssdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1A0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2E1A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📱 MODE SANS INTERNET', style: TextStyle(color: Color(0xFF4ADE80), fontSize: 14)),
            Text('Passerelle USSD/SMS', style: TextStyle(color: Color(0xFF4A6A4A), fontSize: 10)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('══════════════════', style: TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace')),
                  const Text('  SANTE FAMILLE', style: TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace')),
                  const Text('  E-Carnet Bénin', style: TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace')),
                  const Text('══════════════════', style: TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace')),
                  const SizedBox(height: 12),
                  _ussdLine('1. Prochain vaccin'),
                  _ussdLine('2. Confirmer RDV'),
                  _ussdLine('3. Centre de santé'),
                  _ussdLine('4. Conseil du jour'),
                  _ussdLine('0. Quitter'),
                  const SizedBox(height: 12),
                  const Text('══════════════════', style: TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace')),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text('Votre choix : ', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 14, fontFamily: 'monospace')),
                      Text('1', style: TextStyle(color: Color(0xFF4ADE80), fontSize: 14, fontFamily: 'monospace')),
                      _Cursor(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('📨 Rappel SMS reçu :', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80).withOpacity(0.06),
                      border: Border.all(color: const Color(0xFF4ADE80).withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SANTE FAMILLE : Ibrahim a un vaccin DTC le 04/04/2026 à 09h00 au CS Gbégamey. Répondez OUI pour confirmer.',
                      style: TextStyle(color: Color(0xFF4ADE80), fontSize: 13, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Keypad
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A2E1A),
              border: Border(top: BorderSide(color: Color(0xFF2A4A2A))),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'].map((k) => Container(
                decoration: BoxDecoration(color: const Color(0xFF243824), borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(k, style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 18, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ussdLine(String text) {
    return Text(text, style: TextStyle(color: const Color(0xFF4ADE80).withOpacity(0.6), height: 2, fontFamily: 'monospace'));
  }
}

class _Cursor extends StatefulWidget {
  const _Cursor();

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 8, height: 16, color: const Color(0xFF4ADE80)),
    );
  }
}
