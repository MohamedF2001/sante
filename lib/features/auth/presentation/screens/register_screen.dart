// ============================================================
// lib/features/auth/presentation/screens/register_screen.dart
// Écran d'inscription — correspond à l'Écran 5 du design
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour chaque champ
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nomEnfantCtrl = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    // Libérer la mémoire des contrôleurs
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _telephoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nomEnfantCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Valider le formulaire avant de soumettre
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).register(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      telephone: _telephoneCtrl.text.trim(),
      nomEnfant: _nomEnfantCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Écouter les changements d'état
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.success) {
        // Rediriger vers le dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (next.status == AuthStatus.error) {
        // Afficher l'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Erreur inconnue'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header vert ──────────────────────────────
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
                    // Bouton retour
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white70, size: 18),
                          SizedBox(width: 4),
                          Text('Retour',
                              style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Rejoignez Santé Famille gratuitement',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
                      // Prénom + Nom (côte à côte)
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: 'PRÉNOM',
                              controller: _prenomCtrl,
                              hint: 'Aicha',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              label: 'NOM',
                              controller: _nomCtrl,
                              hint: 'Traoré',
                              icon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Téléphone
                      _buildField(
                        label: 'TÉLÉPHONE',
                        controller: _telephoneCtrl,
                        hint: '+229 97 00 00 00',
                        icon: Icons.phone_outlined,
                        type: TextInputType.phone,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Champ requis'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildField(
                        label: 'EMAIL',
                        controller: _emailCtrl,
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
                      _PasswordField(controller: _passwordCtrl),
                      const SizedBox(height: 16),

                      // Nom de l'enfant
                      _buildField(
                        label: 'NOM DE L\'ENFANT',
                        controller: _nomEnfantCtrl,
                        hint: 'Ibrahim',
                        icon: Icons.child_care,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Champ requis'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      // Bouton inscription
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
                              : const Text('Créer mon compte →'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lien vers connexion
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/login'),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Déjà un compte ? ',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Se connecter',
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

  // Widget helper pour créer un champ de formulaire
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: type,
          validator: validator ?? (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
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


