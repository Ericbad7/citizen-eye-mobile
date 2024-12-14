extension DateTimeExtensions on DateTime {
  // Méthode pour formater la date en 'dd/MM/yyyy'
  String toFormattedDate() {
    return "${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}";
  }

  // Méthode pour formater la date en 'yyyy-MM-dd'
  String toIsoFormattedDate() {
    return "${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }

  // Méthode pour retourner la date sous forme 'Month dd, yyyy' (par exemple : Janvier 01, 2024)
  String toLongFormattedDate() {
    List<String> months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return "${months[this.month - 1]} ${this.day}, ${this.year}";
  }

  // Méthode pour savoir si la date correspond à aujourd'hui
  bool isToday() {
    final now = DateTime.now();
    return this.year == now.year &&
        this.month == now.month &&
        this.day == now.day;
  }

  // Méthode pour savoir si la date est passée (comparaison avec aujourd'hui)
  bool isInThePast() {
    return this.isBefore(DateTime.now());
  }

  // Méthode pour savoir si la date est dans le futur
  bool isInTheFuture() {
    return this.isAfter(DateTime.now());
  }

  // Méthode pour ajouter des jours à la date actuelle
  DateTime addDays(int days) {
    return this.add(Duration(days: days));
  }

  // Méthode pour calculer la différence en jours entre deux dates
  int differenceInDays(DateTime otherDate) {
    return this.difference(otherDate).inDays;
  }
}
