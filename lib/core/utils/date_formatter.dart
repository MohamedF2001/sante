// ============================================================
// lib/core/utils/date_formatter.dart
// ============================================================

import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthYear = DateFormat('MMM yyyy', 'fr_FR');

  static String format(DateTime date) => _dateFormat.format(date);
  static String formatShort(DateTime date) => _shortFormat.format(date);
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  /// Retourne "Dans Xj", "J-X" ou "Passé"
  static String countdown(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    if (diff > 0) return 'Dans ${diff}j';
    if (diff == 0) return "Aujourd'hui";
    return 'Passé';
  }

  /// Âge de l'enfant en mois
  static String ageInMonths(DateTime birthDate) {
    final now = DateTime.now();
    final months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (months < 12) return '$months mois';
    final years = (months / 12).floor();
    return '$years an${years > 1 ? 's' : ''}';
  }

  DateFormatter._();
}