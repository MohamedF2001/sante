// ============================================================
// lib/features/profil/presentation/screens/ajouter_enfant_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/enfant_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AjouterEnfantScreen extends ConsumerStatefulWidget {
  const AjouterEnfantScreen({super.key});

  @override
  ConsumerState<AjouterEnfantScreen> createState() => _AjouterEnfantScreenState();
}

class _AjouterEnfantScreenState extends ConsumerState<AjouterEnfantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  DateTime? _dateNaissance;
  String _genre = 'M';

  @override
  void dispose() {
    _nomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un enfant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'enfant'),
                validator: (v) => v?.isEmpty == true ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_dateNaissance == null
                    ? 'Date de naissance'
                    : 'Né le : ${_dateNaissance!.day}/${_dateNaissance!.month}/${_dateNaissance!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _dateNaissance = picked);
                },
              ),
              const SizedBox(height: 16),
              const Text('Genre', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: 'M',
                    groupValue: _genre,
                    onChanged: (v) => setState(() => _genre = v!),
                  ),
                  const Text('Masculin'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'F',
                    groupValue: _genre,
                    onChanged: (v) => setState(() => _genre = v!),
                  ),
                  const Text('Féminin'),
                ],
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

                            final enfant = EnfantModel(
                              id: const Uuid().v4(),
                              nom: _nomCtrl.text,
                              genre: _genre,
                              dateNaissance: _dateNaissance,
                            );

                            await ref.read(authNotifierProvider.notifier).addEnfant(user.uid, enfant);

                            if (mounted) {
                              if (ref.read(authNotifierProvider).status == AuthStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enfant ajouté'), backgroundColor: AppColors.success),
                                );
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Ajouter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
