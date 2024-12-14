class AppStrings {
  // Titres des pages
  static const String appTitle = 'Citizen Eye';
  static const String homeScreenTitle = 'Projets';
  static const String projectDetailScreenTitle = 'Détail du projet';
  static const String alertScreenTitle = 'Alertes';

  // Messages d'accueil
  static const String welcomeMessage = 'Bienvenue dans Citizen Eye';
  static const String introMessage =
      'Suivez les projets publics de votre ville et participez au développement en signalant des problèmes.';

  // Boutons
  static const String buttonSubmit = 'Soumettre';
  static const String buttonCancel = 'Annuler';
  static const String buttonLike = 'Applaudir';
  static const String buttonAlert = 'Signaler un problème';
  static const String buttonViewDetails = 'Voir les détails';
  static const String buttonRetry = 'Réessayer';

  // Étiquettes de formulaire
  static const String labelName = 'Nom';
  static const String labelEmail = 'Email';
  static const String labelPassword = 'Mot de passe';
  static const String labelConfirmPassword = 'Confirmer le mot de passe';
  static const String labelComment = 'Commentaire';
  static const String labelLocation = 'Localisation';

  // Messages d'erreur
  static const String errorRequiredField = 'Ce champ est obligatoire';
  static const String errorInvalidEmail = 'Email invalide';
  static const String errorPasswordTooShort =
      'Le mot de passe doit contenir au moins 6 caractères';
  static const String errorPasswordsDoNotMatch =
      'Les mots de passe ne correspondent pas';
  static const String errorNetwork =
      'Erreur réseau. Veuillez vérifier votre connexion.';
  static const String errorSomethingWentWrong =
      'Une erreur est survenue. Veuillez réessayer plus tard.';

  // Messages de succès
  static const String successFormSubmission = 'Formulaire soumis avec succès';
  static const String successProjectReported = 'Projet signalé avec succès';
  static const String successCommentSubmitted =
      'Commentaire envoyé avec succès';

  // Placeholders
  static const String placeholderSearch = 'Rechercher des projets...';
  static const String placeholderEnterName = 'Entrez votre nom';
  static const String placeholderEnterEmail = 'Entrez votre email';
  static const String placeholderEnterPassword = 'Entrez votre mot de passe';

  // Divers
  static const String noProjectsFound = 'Aucun projet trouvé';
  static const String loading = 'Chargement...';
  static const String unknownError = 'Erreur inconnue';
}
