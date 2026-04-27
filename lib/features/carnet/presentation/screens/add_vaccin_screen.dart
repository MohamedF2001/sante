import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/utils/validators.dart';
import 'package:sante_famille/core/widgets/custom_button.dart';
import 'package:sante_famille/core/widgets/custom_text_field.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';
import 'package:sante_famille/features/carnet/domain/vaccin_model.dart';
import '../providers/carnet_provider.dart';

class AddVaccinScreen extends ConsumerStatefulWidget {
  const AddVaccinScreen({super.key});

  @override
  ConsumerState<AddVaccinScreen> createState() => _AddVaccinScreenState();
}

class _AddVaccinScreenState extends ConsumerState<AddVaccinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = ref.read(authStateProvider).valueOrNull;
      if (user == null) return;

      final vaccin = VaccinModel(
        id: '',
        userId: user.uid,
        nom: _nomCtrl.text.trim(),
        date: _selectedDate,
      );

      await ref.read(carnetServiceProvider).addVaccin(vaccin);
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un vaccin')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nom du vaccin',
                controller: _nomCtrl,
                hint: 'Ex: BCG, DTC...',
                validator: (v) => Validators.validateRequired(v, 'Nom du vaccin'),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                label: 'Enregistrer',
                onPressed: _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
