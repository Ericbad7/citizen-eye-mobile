class StringHelper {
  // Vérifie si une chaîne est un email valide
  static bool isValidEmail(String email) {
    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }

  // Vérifie si une chaîne contient uniquement des chiffres
  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  // Convertit la première lettre de chaque mot en majuscule
  static String capitalizeWords(String str) {
    if (str.isEmpty) return str;
    return str.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Tronque une chaîne si elle dépasse une certaine longueur et ajoute "..."
  static String truncate(String str, int maxLength) {
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}...';
  }

  // Supprime les espaces en trop au début, à la fin, et entre les mots
  static String removeExtraSpaces(String str) {
    return str.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Vérifie si une chaîne est un mot de passe valide (au moins 8 caractères avec chiffres et lettres)
  static bool isValidPassword(String password) {
    final RegExp passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Convertit une chaîne de caractères en camelCase
  static String toCamelCase(String str) {
    List<String> words = str.toLowerCase().split(' ');
    if (words.isEmpty) return str;
    return words[0] +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join('');
  }

  // Inverse une chaîne de caractères
  static String reverse(String str) {
    return str.split('').reversed.join();
  }

  // Convertit une chaîne en booléen ('true' -> true, 'false' -> false)
  static bool toBoolean(String str) {
    return str.toLowerCase() == 'true';
  }
}
