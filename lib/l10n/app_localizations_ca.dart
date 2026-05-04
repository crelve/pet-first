// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Benvingut a $productName!';
  }

  @override
  String get descriptionMessage =>
      'No oblidis mai les teves gotes oculars. Segueix l\'ús, gestiona les dates de caducitat i rep recordatoris en el moment adequat.';

  @override
  String get mainIntroductionScreen => 'Els teus ulls mereixen cura';

  @override
  String get mainIntroductionContent =>
      'Configura recordatoris per a les teves gotes, segueix les dates de caducitat i gestiona múltiples ampolles.';

  @override
  String get serviceBeginScreen => 'Comença el teu viatge';

  @override
  String get serviceBeginContent => 'Comença a cuidar els teus ulls!';

  @override
  String get signUp => 'Registrar-se';

  @override
  String get close => 'Tancar';

  @override
  String get skip => 'Saltar';

  @override
  String get next => 'Següent';

  @override
  String get setting => 'Configuració';

  @override
  String get languageSetting => 'Configuració d\'idioma';

  @override
  String get themeSetting => 'Configuració del tema';

  @override
  String get themeLight => 'Llum';

  @override
  String get themeDark => 'Fosc';

  @override
  String get themeSystem => 'Sistema per defecte';

  @override
  String get pushNotification => 'Notificacions push';

  @override
  String get ratingSent => 'Valoració enviada';

  @override
  String get recommendApp => 'Aplicacions recomanades';

  @override
  String get contact => 'Contacta amb nosaltres';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get license => 'Llicència';

  @override
  String get error => 'S\'ha produït un error';

  @override
  String get networkError => 'Error de xarxa';

  @override
  String review(Object productName) {
    return 'Valoració';
  }

  @override
  String share(Object productName) {
    return 'Compartir';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Mira aquesta aplicació increïble!';
  }

  @override
  String get writeReview => 'Escriu una ressenya';

  @override
  String get rate => 'Valorar';

  @override
  String get notRate => 'No ara';

  @override
  String get unexpectedError => 'S\'ha produït un error inesperat';

  @override
  String get planInformationFetchFailed =>
      'Error en obtenir la informació del pla';

  @override
  String get subscriptionSettingTitle => 'Configuració de subscripcions';

  @override
  String get currentPlanPremium => 'Pla Premium';

  @override
  String get currentPlanFree => 'Pla gratuït';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Sense anuncis';

  @override
  String get selectPlan => 'Seleccionar pla';

  @override
  String get continueWithFreePlan => 'Continuar amb el pla gratuït';

  @override
  String get subscriptionCancellationNote =>
      'Pots cancel·lar la subscripció en qualsevol moment';

  @override
  String get purchaseCompleted => 'Compra completada';

  @override
  String get revenueCatNotConfigured => 'RevenueCat no està configurat';

  @override
  String get revenueCatInvalidApiKey => 'Clau API de RevenueCat no vàlida';

  @override
  String get planInfoUnavailable => 'Informació del pla no disponible';

  @override
  String get purchaseFailed => 'Ha fallat la compra';

  @override
  String get limitedTimeOffer => 'Oferta de temps limitat';

  @override
  String get homeTab => 'Inici';

  @override
  String get exploreTab => 'Explorar';

  @override
  String get settingsTab => 'Configuració';

  @override
  String get favoriteTab => 'Preferits';

  @override
  String get profileTab => 'Perfil';

  @override
  String get updateAvailableTitle => 'Actualització disponible';

  @override
  String get updateAvailableContent =>
      'Hi ha disponible una nova versió de l\'aplicació.\nActualitzeu per continuar.';

  @override
  String get updateButton => 'Actualització';

  @override
  String get aiChat => 'Xat d\'IA';

  @override
  String get premiumService => 'Servei Premium';

  @override
  String get benefitFullAccess => 'Full Eye Care Tracking';

  @override
  String get benefitFullAccessDesc =>
      'Log every eye drop usage and discover what keeps your eyes healthy ✨';

  @override
  String get benefitPremiumOnly => 'Multiple Bottle Management';

  @override
  String get benefitPremiumOnlyDesc =>
      'Manage all your eye drop bottles and never mix up schedules 👁️';

  @override
  String get benefitUnlimited => 'Unlimited Eye Drops';

  @override
  String get benefitUnlimitedDesc =>
      'Track as many eye drop bottles as you need without any limits 💧';

  @override
  String get benefitNoAds => 'No Ads';

  @override
  String get benefitNoAdsDesc =>
      'Enjoy a seamless eye care experience without any interruptions 🎯';

  @override
  String get annualPlan => 'Pla anual';

  @override
  String get monthlyPlan => 'Pla mensual';

  @override
  String get recommended => 'Recomanat';

  @override
  String discountPercent(int percent) {
    return '$percent% DESCOMPTE';
  }

  @override
  String get trial => 'Prova';

  @override
  String get perMonth => '/mes';

  @override
  String get perYear => '/any';

  @override
  String get restorePurchase => 'Restaurar compra';

  @override
  String get manageSubscription => 'Gestionar subscripció';

  @override
  String startPremium(String price) {
    return 'Inicia Premium (des de $price/mes)';
  }

  @override
  String get restoreSuccess => 'Compra restaurada correctament';

  @override
  String get restoreFailed => 'Error en restaurar la compra';

  @override
  String get noPurchaseToRestore => 'No hi ha compres per restaurar';

  @override
  String get ratingDialogTitle => 'Com t\'agrada l\'aplicació?';

  @override
  String get ratingDialogDescription =>
      'Toqueu les estrelles per valorar l\'aplicació.';

  @override
  String get rateApp => 'Taxa';

  @override
  String get skipRating => 'Ara no';

  @override
  String aiTimeoutError(int seconds) {
    return 'El processament d\'IA ha esgotat el temps ($seconds segons)';
  }

  @override
  String get aiNetworkError => 'Ha fallat la connexió de xarxa';

  @override
  String get aiConfigurationError =>
      'El servei d\'IA no està configurat correctament';

  @override
  String get aiRateLimitError =>
      'S\'ha assolit el límit de sol·licituds de l\'API';

  @override
  String get aiUnknownError => 'S\'ha produït un error inesperat';

  @override
  String get fcmNotification => 'Notificació FCM';

  @override
  String get screenshotHomeTitle => 'Instant Storage Times';

  @override
  String get screenshotHomeDescription =>
      'Search any food, get results immediately';

  @override
  String get screenshotExploreTitle => 'Fridge & Freezer Guide';

  @override
  String get screenshotExploreDescription =>
      'Compare storage options side by side';

  @override
  String get screenshotFavoritesTitle => 'Expiry Tracker';

  @override
  String get screenshotFavoritesDescription =>
      'Track what you have and when it expires';

  @override
  String get screenshotProfileTitle => 'Storage Tips';

  @override
  String get screenshotProfileDescription =>
      'Best practices for every food type';

  @override
  String get screenshotSettingsTitle => 'Settings';

  @override
  String get screenshotSettingsDescription =>
      'Customize your food tracking experience';

  @override
  String get aiConsentScreen => 'Dades d\'IA i privadesa';

  @override
  String get aiConsentContent =>
      'Aquesta aplicació utilitza Google Gemini AI (via Firebase) per potenciar les funcions d\'IA. En continuar, acceptes compartir dades rellevants amb el servei d\'IA de Google.';

  @override
  String get aiConsentPrivacyLink => 'Veure la política de privadesa';

  @override
  String get appName => 'MangaTrack';
}
