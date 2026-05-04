// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Välkommen till $productName!';
  }

  @override
  String get descriptionMessage =>
      'Glöm aldrig dina ögondroppar. Spåra användning, hantera utgångsdatum efter öppning och få påminnelser i rätt tid.';

  @override
  String get mainIntroductionScreen => 'Dina ögon förtjänar omsorg';

  @override
  String get mainIntroductionContent =>
      'Ange påminnelser för ögondroppar, spåra utgångsdatum efter öppning och hantera flera flaskor.';

  @override
  String get serviceBeginScreen => 'Börja din resa';

  @override
  String get serviceBeginContent => 'Börja ta hand om dina ögon!';

  @override
  String get signUp => 'Registrera dig';

  @override
  String get close => 'Stäng';

  @override
  String get skip => 'Hoppa över';

  @override
  String get next => 'Nästa';

  @override
  String get setting => 'Inställning';

  @override
  String get languageSetting => 'Språkinställningar';

  @override
  String get themeSetting => 'Temainställningar';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeSystem => 'Systemstandard';

  @override
  String get pushNotification => 'Push-notiser';

  @override
  String get ratingSent => 'Betyg skickat';

  @override
  String get recommendApp => 'Rekommenderade appar';

  @override
  String get contact => 'Kontakta oss';

  @override
  String get legal => 'Juridiskt';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get license => 'Licenser';

  @override
  String get error => 'Ett fel uppstod';

  @override
  String get networkError => 'Nätverksfel';

  @override
  String review(Object productName) {
    return 'Recension $productName';
  }

  @override
  String share(Object productName) {
    return 'Dela $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Dela $productName med alla! $appLink';
  }

  @override
  String get writeReview => 'Skriv en recension';

  @override
  String get rate => 'Betygsätt';

  @override
  String get notRate => 'Hoppa över betyg';

  @override
  String get unexpectedError => 'Ett oväntat fel inträffade';

  @override
  String get planInformationFetchFailed =>
      'Kunde inte hämta abonnemangsinformation.';

  @override
  String get subscriptionSettingTitle => 'Premium-abonnemang';

  @override
  String get currentPlanPremium => 'Nuvarande abonnemang: Premium';

  @override
  String get currentPlanFree => 'Nuvarande abonnemang: Gratisversion';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Annonsfri';

  @override
  String get selectPlan => 'Välj abonnemang';

  @override
  String get continueWithFreePlan => 'Fortsätt med gratisabonnemang';

  @override
  String get subscriptionCancellationNote =>
      'Du kan avsluta abonnemanget när som helst';

  @override
  String get purchaseCompleted => 'Köp slutfört';

  @override
  String get revenueCatNotConfigured => 'RevenueCat är inte konfigurerad';

  @override
  String get revenueCatInvalidApiKey => 'Ogiltig RevenueCat API-nyckel';

  @override
  String get planInfoUnavailable => 'Abonnemangsinformation inte tillgänglig';

  @override
  String get purchaseFailed => 'Köpet misslyckades';

  @override
  String get limitedTimeOffer => 'Tidsbegränsat erbjudande: ';

  @override
  String get homeTab => 'Hem';

  @override
  String get exploreTab => 'Utforska';

  @override
  String get settingsTab => 'Inställningar';

  @override
  String get favoriteTab => 'Favoriter';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Uppdatering tillgänglig';

  @override
  String get updateAvailableContent =>
      'En ny version av appen är tillgänglig.\nUppdatera för att fortsätta.';

  @override
  String get updateButton => 'Uppdatera';

  @override
  String get aiChat => 'AI-chatt';

  @override
  String get premiumService => 'Premium-tjänst';

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
  String get annualPlan => 'Årsabonnemang';

  @override
  String get monthlyPlan => 'Månatligt abonnemang';

  @override
  String get recommended => 'Rekommenderas';

  @override
  String discountPercent(int percent) {
    return '$percent% RABATT';
  }

  @override
  String get trial => 'Prova';

  @override
  String get perMonth => '/mån';

  @override
  String get perYear => '/år';

  @override
  String get restorePurchase => 'Återställ köp';

  @override
  String get manageSubscription => 'Hantera abonnemang';

  @override
  String startPremium(String price) {
    return 'Starta Premium (från $price/mån)';
  }

  @override
  String get restoreSuccess => 'Köpet återställdes framgångsrikt';

  @override
  String get restoreFailed => 'Kunde inte återställa köp';

  @override
  String get noPurchaseToRestore => 'Inget köp att återställa';

  @override
  String get ratingDialogTitle => 'Hur gillar du appen?';

  @override
  String get ratingDialogDescription =>
      'Tryck på stjärnorna för att betygsätta appen.';

  @override
  String get rateApp => 'Betygsätt';

  @override
  String get skipRating => 'Inte nu';

  @override
  String aiTimeoutError(int seconds) {
    return 'AI-bearbetningen tog för lång tid ($seconds sekunder)';
  }

  @override
  String get aiNetworkError => 'Nätverksanslutningen misslyckades';

  @override
  String get aiConfigurationError => 'AI-tjänsten är inte korrekt konfigurerad';

  @override
  String get aiRateLimitError => 'API-begränsningen nådd';

  @override
  String get aiUnknownError => 'Ett oväntat fel inträffade';

  @override
  String get fcmNotification => 'FCM-avisering';

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
  String get aiConsentScreen => 'AI-data och integritet';

  @override
  String get aiConsentContent =>
      'Den här appen använder Google Gemini AI (via Firebase) för AI-funktioner. Genom att fortsätta godkänner du att dela relevant data med Googles AI-tjänst.';

  @override
  String get aiConsentPrivacyLink => 'Visa integritetspolicy';

  @override
  String get appName => 'MangaTrack';
}
