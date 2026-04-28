// ============================================================
// lib/features/auth/presentation/screens/register_screen.dart
// Écran 5 — Inscription
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    );
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