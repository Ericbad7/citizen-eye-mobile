import 'package:intl/intl.dart';

class DateHelper {
  // Méthode pour formater une date en 'dd/MM/yyyy'
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Méthode pour formater une date en 'yyyy-MM-dd' (format ISO)
  static String formatDateIso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Méthode pour formater une date en 'dd MMMM yyyy' (ex: 24 Octobre 2024)
  static String formatLongDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'fr_FR').format(date);
  }

  // Méthode pour vérifier si une date est passée par rapport à aujourd'hui
  static bool isInThePast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Méthode pour vérifier si une date est dans le futur
  static bool isInTheFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Méthode pour savoir si une date est aujourd'hui
  static bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  // Méthode pour ajouter des jours à une date donnée
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  // Méthode pour calculer la différence en jours entre deux dates
  static int differenceInDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  // Méthode pour obtenir le nom du jour (ex: Lundi, Mardi, etc.)
  static String getDayName(DateTime date) {
    return DateFormat('EEEE', 'fr_FR').format(date);
  }

  // Méthode pour obtenir le nom du mois (ex: Janvier, Février, etc.)
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM', 'fr_FR').format(date);
  }
}
