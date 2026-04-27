import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/constants/app_routes.dart';
import 'package:sante_famille/core/widgets/custom_button.dart';
import 'package:sante_famille/core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _enfantCtrl = TextEditingController();

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _enfantCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      telephone: _phoneCtrl.text.trim(),
      nomEnfant: _enfantCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.success) {
        context.go(AppRoutes.dashboard);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Erreur'), backgroundColor: AppColors.terracotta),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.vertBg,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 36),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.vertForet,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -20,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white60, size: 16),
                          SizedBox(width: 4),
                          Text('Retour', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Rejoignez Santé Famille gratuitement',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.vertClair,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.vertForet.withOpacity(0.1),
                      blurRadius: 32,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Prénom',
                              controller: _prenomCtrl,
                              prefixIcon: Icons.person_outline,
                              hint: 'Aicha',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: 'Nom',
                              controller: _nomCtrl,
                              hint: 'Traoré',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Nom de l\'enfant',
                        controller: _enfantCtrl,
                        prefixIcon: Icons.child_care,
                        hint: 'Petit Ibrahim',
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Téléphone',
                        controller: _phoneCtrl,
                        prefixIcon: Icons.phone_android,
                        hint: '+229 97 00 00 00',
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Email',
                        controller: _emailCtrl,
                        prefixIcon: Icons.email_outlined,
                        hint: 'aicha@email.com',
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Mot de passe',
                        controller: _passCtrl,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        hint: '••••••••',
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        label: 'Créer mon compte →',
                        onPressed: _submit,
                        isLoading: authState.status == AuthStatus.loading,
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Déjà un compte ? ',
                              style: TextStyle(color: AppColors.grisTexte, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Se connecter',
                                  style: TextStyle(color: AppColors.vertForet, fontWeight: FontWeight.bold),
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
            ),
          ),
        ],
      ),
    );
  }
}
