// ============================================================
// lib/features/carnet/presentation/screens/add_vaccin_screen.dart
// Formulaire d'ajout d'un vaccin
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/vaccin_model.dart';
import '../../data/carnet_service.dart';
import '../provider/carnet_provider.dart';

class AddVaccinScreen extends ConsumerStatefulWidget {
  const AddVaccinScreen({super.key});
  @override
  ConsumerState<AddVaccinScreen> createState() => _AddVaccinScreenState();
}

class _AddVaccinScreenState extends ConsumerState<AddVaccinScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _nomCtrl      = TextEditingController();
  final _centreCtrl   = TextEditingController();
  final _notesCtrl    = TextEditingController();
  DateTime _datePrevu = DateTime.now().add(const Duration(days: 7));
  bool _isLoading     = false;
  String? _selectedVaccinPEV;

  // Vaccins du programme PEV pour la liste déroulante
  final List<Map<String, dynamic>> _vaccinsPEV =
  CarnetService.vaccinsPEVBenin();

  @override
  void dispose() {
    _nomCtrl.dispose();
    _centreCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _datePrevu,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _datePrevu = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final vaccin = VaccinModel(
      id: const Uuid().v4(),
      userId: uid,
      nom: _nomCtrl.text.trim(),
      datePrevu: _datePrevu,
      statut: VaccinStatut.planifie,
      centre: _centreCtrl.text.trim().isEmpty ? null : _centreCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      ageRecommande: _selectedVaccinPEV != null
          ? _vaccinsPEV.firstWhere(
              (v) => v['nom'] == _selectedVaccinPEV)['ageRecommande']
          : 'Personnalisé',
    );

    await ref.read(carnetNotifierProvider.notifier).addVaccin(vaccin);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vaccin ajouté avec succès ✓'),
          backgroundColor: AppColors.success,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un vaccin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sélectionner depuis PEV ──────────────────
              _label('CHOISIR UN VACCIN PEV BÉNIN'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedVaccinPEV,
                hint: const Text('Sélectionner un vaccin standard'),
                decoration: const InputDecoration(),
                onChanged: (value) {
                  setState(() {
                    _selectedVaccinPEV = value;
                    if (value != null) _nomCtrl.text = value;
                  });
                },
                items: _vaccinsPEV
                    .map((v) => DropdownMenuItem<String>(
                  value: v['nom'],
                  child: Text('${v['nom']} (${v['ageRecommande']})',
                      overflow: TextOverflow.ellipsis),
                ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('— ou saisir manuellement —',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textLight)),
              ),
              const SizedBox(height: 16),

              // ── Nom du vaccin ────────────────────────────
              _label('NOM DU VACCIN'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nomCtrl,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Champ requis' : null,
                decoration: const InputDecoration(
                  hintText: 'Ex: BCG, DTC, Polio...',
                  prefixIcon: Icon(Icons.vaccines_outlined,
                      size: 18, color: AppColors.textLight),
                ),
              ),
              const SizedBox(height: 16),

              // ── Date prévue ──────────────────────────────
              _label('DATE PRÉVUE'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: AppColors.textLight),
                    const SizedBox(width: 10),
                    Text(
                      '${_datePrevu.day}/${_datePrevu.month}/${_datePrevu.year}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textLight),
                  ]),
                ),
              ),
              const SizedBox(height: 16),

              // ── Centre de santé ──────────────────────────
              _label('CENTRE DE SANTÉ (optionnel)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _centreCtrl,
                decoration: const InputDecoration(
                  hintText: 'Ex: CS Gbégamey',
                  prefixIcon: Icon(Icons.local_hospital_outlined,
                      size: 18, color: AppColors.textLight),
                ),
              ),
              const SizedBox(height: 16),

              // ── Notes ────────────────────────────────────
              _label('NOTES (optionnel)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Remarques, réactions...',
                ),
              ),
              const SizedBox(height: 32),

              // ── Bouton soumettre ─────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Enregistrer le vaccin',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppColors.textSecondary));
}