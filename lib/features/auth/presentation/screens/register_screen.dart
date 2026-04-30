// ============================================================
// lib/features/auth/presentation/screens/register_screen.dart
// Écran 5 — Inscription
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _prenomCtrl  = TextEditingController();
  final _nomCtrl     = TextEditingController();
  final _telCtrl     = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _enfantCtrl  = TextEditingController();
  bool _passVisible  = false;

  DateTime? _dateNaissanceEnfant;
  String _genreEnfant = 'M';
  String? _photoBase64Enfant;

  @override
  void dispose() {
    for (final c in [_prenomCtrl, _nomCtrl, _telCtrl, _emailCtrl, _passCtrl, _enfantCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      nomEnfant: _enfantCtrl.text.trim(),
      dateNaissanceEnfant: _dateNaissanceEnfant,
      genreEnfant: _genreEnfant,
      photoBase64Enfant: _photoBase64Enfant,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      setState(() {
        _photoBase64Enfant = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next.status == AuthStatus.success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.errorMessage ?? 'Erreur'),
          backgroundColor: AppColors.danger,
        ));
        ref.read(authNotifierProvider.notifier).resetError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 4),
                          Text('Retour',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Créer un compte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Rejoignez Santé Famille gratuitement',
                        style:
                        TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),

              // ── Formulaire ──────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prénom + Nom
                      Row(children: [
                        Expanded(
                          child: _field(
                            label: 'PRÉNOM',
                            ctrl: _prenomCtrl,
                            hint: 'Aicha',
                            icon: Icons.person_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            label: 'NOM',
                            ctrl: _nomCtrl,
                            hint: 'Traoré',
                            icon: Icons.person_outline,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),

                      _field(
                        label: 'TÉLÉPHONE',
                        ctrl: _telCtrl,
                        hint: '+229 97 00 00 00',
                        icon: Icons.phone_outlined,
                        type: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _field(
                        label: 'EMAIL',
                        ctrl: _emailCtrl,
                        hint: 'aicha@email.com',
                        icon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Champ requis';
                          if (!v.contains('@')) return 'Email invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mot de passe
                      _label('MOT DE PASSE'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: !_passVisible,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Champ requis';
                          if (v.length < 6) return 'Min. 6 caractères';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline,
                              size: 18, color: AppColors.textLight),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _passVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 18,
                                color: AppColors.textLight),
                            onPressed: () =>
                                setState(() => _passVisible = !_passVisible),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _field(
                        label: 'NOM DE L\'ENFANT',
                        ctrl: _enfantCtrl,
                        hint: 'Ibrahim',
                        icon: Icons.child_care,
                      ),
                      const SizedBox(height: 16),

                      _label('GENRE DE L\'ENFANT'),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'M',
                            groupValue: _genreEnfant,
                            onChanged: (v) => setState(() => _genreEnfant = v!),
                          ),
                          const Text('Garçon'),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'F',
                            groupValue: _genreEnfant,
                            onChanged: (v) => setState(() => _genreEnfant = v!),
                          ),
                          const Text('Fille'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _label('DATE DE NAISSANCE DE L\'ENFANT'),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _dateNaissanceEnfant = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: AppColors.textLight),
                              const SizedBox(width: 10),
                              Text(
                                _dateNaissanceEnfant == null
                                    ? 'Choisir une date'
                                    : DateFormat('dd/MM/yyyy').format(_dateNaissanceEnfant!),
                                style: TextStyle(
                                  color: _dateNaissanceEnfant == null ? AppColors.textLight : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _label('PHOTO DE L\'ENFANT'),
                      const SizedBox(height: 6),
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.border),
                              image: _photoBase64Enfant != null
                                  ? DecorationImage(
                                      image: MemoryImage(base64Decode(_photoBase64Enfant!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _photoBase64Enfant == null
                                ? const Icon(Icons.add_a_photo, color: AppColors.textLight)
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Bouton
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: state.status == AuthStatus.loading
                              ? null
                              : _submit,
                          child: state.status == AuthStatus.loading
                              ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                              : const Text('Créer mon compte →',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.login),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Déjà un compte ? ',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Se connecter',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    String? hint,
    IconData? icon,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator:
          validator ?? (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: AppColors.textLight)
                : null,
          ),
        ),
      ],
    );
  }
}