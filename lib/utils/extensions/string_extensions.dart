extension StringExtensions on String {
  // Vérifie si une chaîne est un email valide
  bool isValidEmail() {
    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(this);
  }

  // Vérifie si une chaîne ne contient que des chiffres
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  // Convertit une chaîne en majuscules la première lettre de chaque mot
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Tronque la chaîne si elle dépasse une certaine longueur, et ajoute '...'
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Retire les espaces au début et à la fin, et remplace plusieurs espaces internes par un seul espace
  String removeExtraSpaces() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Convertit une chaîne en booléen (ex: 'true' -> true, 'false' -> false)
  bool toBoolean() {
    return toLowerCase() == 'true';
  }

  // Convertit la chaîne en majuscule pour chaque première lettre du mot
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  // Vérifie si une chaîne est un mot de passe valide (au moins 8 caractères avec chiffres, lettres)
  bool isValidPassword() {
    final RegExp passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  // Convertit une chaîne au format camelCase (première lettre minuscule, autres mots avec majuscule initiale)
  String toCamelCase() {
    return split(' ').map((word) {
      String lowerWord = word.toLowerCase();
      if (lowerWord.isEmpty) return '';
      if (lowerWord == split(' ')[0]) {
        return lowerWord;
      } else {
        return lowerWord[0].toUpperCase() + lowerWord.substring(1);
      }
    }).join('');
  }
}
