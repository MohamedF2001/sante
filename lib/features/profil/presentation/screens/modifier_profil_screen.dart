// ============================================================
// lib/features/profil/presentation/screens/modifier_profil_screen.dart
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  // Champs Enfant
  late TextEditingController _nomEnfantCtrl;
  DateTime? _dateNaissanceEnfant;
  late String _genreEnfant;
  String? _photoBase64Enfant;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider).valueOrNull;
    _nomCtrl = TextEditingController(text: user?.nom);
    _prenomCtrl = TextEditingController(text: user?.prenom);
    _emailCtrl = TextEditingController(text: user?.email);
    _phoneCtrl = TextEditingController(text: user?.telephone);
    _passCtrl = TextEditingController();

    final enfant = user?.activeEnfant;
    _nomEnfantCtrl = TextEditingController(text: enfant?.nom);
    _dateNaissanceEnfant = enfant?.dateNaissance;
    _genreEnfant = enfant?.genre ?? 'M';
    _photoBase64Enfant = enfant?.photoUrl;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _nomEnfantCtrl.dispose();
    super.dispose();
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
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text('INFORMATIONS DE L\'ENFANT ACTIF',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nomEnfantCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'enfant'),
                validator: (v) => v?.isEmpty == true ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),

              const Text('Genre', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
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

              const Text('Date de naissance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dateNaissanceEnfant ?? DateTime.now(),
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Photo de l\'enfant', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
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
                                  nomEnfant: _nomEnfantCtrl.text,
                                  dateNaissanceEnfant: _dateNaissanceEnfant,
                                  genreEnfant: _genreEnfant,
                                  photoBase64Enfant: _photoBase64Enfant,
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
