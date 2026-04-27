// ============================================================
// lib/features/auth/presentation/screens/login_screen.dart
// Écran de connexion — correspond à l'Écran 6 du design
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.success) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Erreur'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ─── Header vert ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.health_and_safety,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Santé Famille',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'BON RETOUR PARMI NOUS',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Formulaire ───────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Email / Téléphone
                      const Text('TÉLÉPHONE OU EMAIL',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Champ requis'
                            : null,
                        decoration: const InputDecoration(
                          hintText: '+229 97 00 00 00',
                          prefixIcon:
                          Icon(Icons.phone_outlined, size: 18, color: AppColors.textLight),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Mot de passe
                      _PasswordField(controller: _passwordCtrl),
                      const SizedBox(height: 8),

                      // Mot de passe oublié
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: implémenter la réinitialisation
                          },
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bouton connexion
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authState.status == AuthStatus.loading
                              ? null
                              : _submit,
                          child: authState.status == AuthStatus.loading
                              ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                              : const Text('Se connecter →'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Séparateur "ou"
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: AppColors.border)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ou',
                                style: TextStyle(
                                    color: AppColors.textLight, fontSize: 13)),
                          ),
                          const Expanded(
                              child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Google Sign-In (bouton outline)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Google Sign-In (optionnel pour MVP)
                          },
                          icon: const Icon(Icons.g_mobiledata,
                              color: AppColors.textSecondary),
                          label: const Text('Continuer avec Google',
                              style: TextStyle(color: AppColors.textSecondary)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lien inscription
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/register'),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Pas encore de compte ? ',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'S\'inscrire',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
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
}

// Widget séparé pour le champ mot de passe (toggle visibility)
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MOT DE PASSE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: !_visible,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Champ requis';
            if (v.length < 6) return 'Minimum 6 caractères';
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon:
            const Icon(Icons.lock_outline, size: 18, color: AppColors.textLight),
            suffixIcon: IconButton(
              icon: Icon(_visible ? Icons.visibility : Icons.visibility_off,
                  size: 18, color: AppColors.textLight),
              onPressed: () => setState(() => _visible = !_visible),
            ),
          ),
        ),
      ],
    );
  }
}