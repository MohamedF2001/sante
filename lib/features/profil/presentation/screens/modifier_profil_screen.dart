// ============================================================
// lib/features/profil/presentation/screens/modifier_profil_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ModifierProfilScreen extends ConsumerStatefulWidget {
  const ModifierProfilScreen({super.key});

  @override
  ConsumerState<ModifierProfilScreen> createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends ConsumerState<ModifierProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _passCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider).valueOrNull;
    _nomCtrl = TextEditingController(text: user?.nom);
    _prenomCtrl = TextEditingController(text: user?.prenom);
    _emailCtrl = TextEditingController(text: user?.email);
    _phoneCtrl = TextEditingController(text: user?.telephone);
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v?.isEmpty == true ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (v) => v?.isEmpty == true ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v?.contains('@') != true ? 'Email invalide' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Nouveau mot de passe (optionnel)'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final user = ref.read(userProfileProvider).valueOrNull;
                            if (user == null) return;

                            await ref.read(authNotifierProvider.notifier).updateProfile(
                                  uid: user.uid,
                                  nom: _nomCtrl.text,
                                  prenom: _prenomCtrl.text,
                                  email: _emailCtrl.text,
                                  telephone: _phoneCtrl.text,
                                  password: _passCtrl.text.isEmpty ? null : _passCtrl.text,
                                );

                            if (mounted) {
                              if (ref.read(authNotifierProvider).status == AuthStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Profil mis à jour'), backgroundColor: AppColors.success),
                                );
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
