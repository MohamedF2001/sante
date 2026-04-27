import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'fr_FR').format(date);
  }

  static String timeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 7) {
      return formatDate(date);
    } else if (duration.inDays >= 1) {
      return 'Il y a ${duration.inDays} jour(s)';
    } else if (duration.inHours >= 1) {
      return 'Il y a ${duration.inHours} heure(s)';
    } else {
      return 'À l\'instant';
    }
  }

  DateFormatter._();
}
