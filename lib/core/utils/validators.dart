// ============================================================
// lib/core/utils/validators.dart
// ============================================================

class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ce champ est requis.';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ce champ est requis.';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value)) {
      return 'Adresse email invalide.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est requis.';
    if (value.length < 6) return 'Minimum 6 caractères.';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ce champ est requis.';
    if (value.replaceAll(RegExp(r'[\s+]'), '').length < 8) {
      return 'Numéro invalide.';
    }
    return null;
  }

  Validators._();
}


