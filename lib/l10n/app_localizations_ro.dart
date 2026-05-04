// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Bine ați venit la $productName!';
  }

  @override
  String get descriptionMessage =>
      'Nu uitați niciodată picăturile de ochi. Urmăriți utilizarea, gestionați datele de expirare și primiți mementouri la momentul potrivit.';

  @override
  String get mainIntroductionScreen => 'Ochii tăi merită îngrijire';

  @override
  String get mainIntroductionContent =>
      'Setați mementouri pentru picăturile de ochi, urmăriți datele de expirare după deschidere și gestionați mai multe flacoane.';

  @override
  String get serviceBeginScreen => 'Începeți călătoria';

  @override
  String get serviceBeginContent => 'Începeți să vă îngrijiți ochii!';

  @override
  String get signUp => 'Înregistrare';

  @override
  String get close => 'Închide';

  @override
  String get skip => 'Omite';

  @override
  String get next => 'Următorul';

  @override
  String get setting => 'Setare';

  @override
  String get languageSetting => 'Setări de limbă';

  @override
  String get themeSetting => 'Setări temă';

  @override
  String get themeLight => 'Luminos';

  @override
  String get themeDark => 'Întunecat';

  @override
  String get themeSystem => 'Implicit sistem';

  @override
  String get pushNotification => 'Notificări push';

  @override
  String get ratingSent => 'Evaluare trimisă';

  @override
  String get recommendApp => 'Aplicații recomandate';

  @override
  String get contact => 'Contactează-ne';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get license => 'Licențe';

  @override
  String get error => 'A apărut o eroare';

  @override
  String get networkError => 'Eroare de rețea';

  @override
  String review(Object productName) {
    return 'Recenzie $productName';
  }

  @override
  String share(Object productName) {
    return 'Distribuie $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Distribuiți $productName cu toată lumea! $appLink';
  }

  @override
  String get writeReview => 'Scrie o recenzie';

  @override
  String get rate => 'Evaluează';

  @override
  String get notRate => 'Omite evaluarea';

  @override
  String get unexpectedError => 'A apărut o eroare neașteptată';

  @override
  String get planInformationFetchFailed =>
      'Nu s-au putut obține informațiile despre plan.';

  @override
  String get subscriptionSettingTitle => 'Plan Premium';

  @override
  String get currentPlanPremium => 'Plan curent: Premium';

  @override
  String get currentPlanFree => 'Plan curent: Versiune gratuită';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Fără reclame';

  @override
  String get selectPlan => 'Selectează plan';

  @override
  String get continueWithFreePlan => 'Continuă cu planul gratuit';

  @override
  String get subscriptionCancellationNote => 'Puteți anula abonamentul oricând';

  @override
  String get purchaseCompleted => 'Achiziție finalizată';

  @override
  String get revenueCatNotConfigured => 'RevenueCat nu este configurat';

  @override
  String get revenueCatInvalidApiKey => 'Cheie API RevenueCat invalidă';

  @override
  String get planInfoUnavailable =>
      'Informațiile despre plan nu sunt disponibile';

  @override
  String get purchaseFailed => 'Achiziția a eșuat';

  @override
  String get limitedTimeOffer => 'Ofertă pe timp limitat: ';

  @override
  String get homeTab => 'Acasă';

  @override
  String get exploreTab => 'Explorează';

  @override
  String get settingsTab => 'Setări';

  @override
  String get favoriteTab => 'Favorite';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Actualizare disponibilă';

  @override
  String get updateAvailableContent =>
      'O nouă versiune a aplicației este disponibilă.\nTe rugăm să actualizezi pentru a continua.';

  @override
  String get updateButton => 'Actualizează';

  @override
  String get aiChat => 'Chat AI';

  @override
  String get premiumService => 'Serviciu Premium';

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
  String get annualPlan => 'Plan anual';

  @override
  String get monthlyPlan => 'Plan lunar';

  @override
  String get recommended => 'Recomandat';

  @override
  String discountPercent(int percent) {
    return '$percent% REDUCERE';
  }

  @override
  String get trial => 'Încercare';

  @override
  String get perMonth => '/lună';

  @override
  String get perYear => '/an';

  @override
  String get restorePurchase => 'Restabilește achiziția';

  @override
  String get manageSubscription => 'Gestionează abonamentul';

  @override
  String startPremium(String price) {
    return 'Începe Premium (de la $price/lună)';
  }

  @override
  String get restoreSuccess => 'Achiziția a fost restabilită cu succes';

  @override
  String get restoreFailed => 'Restabilirea achiziției a eșuat';

  @override
  String get noPurchaseToRestore => 'Nicio achiziție de restabilit';

  @override
  String get ratingDialogTitle => 'Îți place aplicația?';

  @override
  String get ratingDialogDescription =>
      'Atinge stelele pentru a evalua aplicația.';

  @override
  String get rateApp => 'Evaluează';

  @override
  String get skipRating => 'Mai târziu';

  @override
  String aiTimeoutError(int seconds) {
    return 'Procesarea AI a expirat ($seconds secunde)';
  }

  @override
  String get aiNetworkError => 'Conexiunea la rețea a eșuat';

  @override
  String get aiConfigurationError => 'Serviciul AI nu este configurat corect';

  @override
  String get aiRateLimitError => 'Limita de cereri API atinsă';

  @override
  String get aiUnknownError => 'A apărut o eroare neașteptată';

  @override
  String get fcmNotification => 'Notificare FCM';

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
  String get aiConsentScreen => 'Date AI și confidențialitate';

  @override
  String get aiConsentContent =>
      'Această aplicație folosește Google Gemini AI (prin Firebase) pentru funcții AI. Continuând, ești de acord cu partajarea datelor relevante cu serviciul AI Google.';

  @override
  String get aiConsentPrivacyLink =>
      'Vizualizați politica de confidențialitate';

  @override
  String get appName => 'MangaTrack';
}
