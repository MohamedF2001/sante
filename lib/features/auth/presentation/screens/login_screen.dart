import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/constants/app_routes.dart';
import 'package:sante_famille/core/widgets/custom_button.dart';
import 'package:sante_famille/core/widgets/custom_text_field.dart';
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
          // Hero section
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.vertForet,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -70,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.vertClair.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.ocre.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('🌿', style: TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Santé Famille',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'BON RETOUR PARMI NOUS',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.vertClair,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.vertForet.withOpacity(0.1),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Téléphone ou Email',
                        controller: _emailCtrl,
                        prefixIcon: Icons.phone_android,
                        hint: '+229 97 00 00 00',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Mot de passe',
                        controller: _passwordCtrl,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        hint: '••••••••',
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: AppColors.vertForet, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Se connecter →',
                        onPressed: _submit,
                        isLoading: authState.status == AuthStatus.loading,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.grisDoux)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ou', style: TextStyle(color: AppColors.grisTexte, fontSize: 12)),
                          ),
                          const Expanded(child: Divider(color: AppColors.grisDoux)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Text('🇬'),
                        label: const Text('Continuer avec Google', style: TextStyle(color: AppColors.noirDoux)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          side: const BorderSide(color: AppColors.grisDoux),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.register),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Pas encore de compte ? ',
                              style: TextStyle(color: AppColors.grisTexte, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'S\'inscrire',
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
