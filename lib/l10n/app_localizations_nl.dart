// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Welkom bij $productName!';
  }

  @override
  String get descriptionMessage =>
      'Vergeet nooit meer je oogdruppels. Volg gebruik, beheer vervaldatums na opening en ontvang herinneringen op het juiste moment.';

  @override
  String get mainIntroductionScreen => 'Jouw ogen verdienen zorg';

  @override
  String get mainIntroductionContent =>
      'Stel herinneringen in voor je oogdruppels, volg vervaldatums na openen en beheer meerdere flesjes.';

  @override
  String get serviceBeginScreen => 'Begin je reis';

  @override
  String get serviceBeginContent => 'Begin met het verzorgen van je ogen!';

  @override
  String get signUp => 'Aanmelden';

  @override
  String get close => 'Sluiten';

  @override
  String get skip => 'Overslaan';

  @override
  String get next => 'Volgende';

  @override
  String get setting => 'Instelling';

  @override
  String get languageSetting => 'Taalinstellingen';

  @override
  String get themeSetting => 'Thema-instellingen';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeSystem => 'Systeemstandaard';

  @override
  String get pushNotification => 'Pushmeldingen';

  @override
  String get ratingSent => 'Beoordeling verzonden';

  @override
  String get recommendApp => 'Aanbevolen apps';

  @override
  String get contact => 'Contact opnemen';

  @override
  String get legal => 'Juridisch';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get license => 'Licenties';

  @override
  String get error => 'Er is een fout opgetreden';

  @override
  String get networkError => 'Netwerkfout';

  @override
  String review(Object productName) {
    return 'Beoordeling $productName';
  }

  @override
  String share(Object productName) {
    return 'Deel $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Deel $productName met iedereen! $appLink';
  }

  @override
  String get writeReview => 'Schrijf een recensie';

  @override
  String get rate => 'Beoordelen';

  @override
  String get notRate => 'Beoordeling overslaan';

  @override
  String get unexpectedError => 'Er is een onverwachte fout opgetreden';

  @override
  String get planInformationFetchFailed =>
      'Kan abonnementsinformatie niet ophalen.';

  @override
  String get subscriptionSettingTitle => 'Premium-abonnement';

  @override
  String get currentPlanPremium => 'Huidig abonnement: Premium';

  @override
  String get currentPlanFree => 'Huidig abonnement: Gratis versie';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Advertentievrij';

  @override
  String get selectPlan => 'Selecteer abonnement';

  @override
  String get continueWithFreePlan => 'Doorgaan met gratis abonnement';

  @override
  String get subscriptionCancellationNote =>
      'Je kunt je abonnement op elk moment opzeggen';

  @override
  String get purchaseCompleted => 'Aankoop voltooid';

  @override
  String get revenueCatNotConfigured => 'RevenueCat is niet geconfigureerd';

  @override
  String get revenueCatInvalidApiKey => 'Ongeldige RevenueCat API-sleutel';

  @override
  String get planInfoUnavailable => 'Abonnementsinformatie is niet beschikbaar';

  @override
  String get purchaseFailed => 'Aankoop mislukt';

  @override
  String get limitedTimeOffer => 'Tijdelijke aanbieding: ';

  @override
  String get homeTab => 'Home';

  @override
  String get exploreTab => 'Verkennen';

  @override
  String get settingsTab => 'Instellingen';

  @override
  String get favoriteTab => 'Favorieten';

  @override
  String get profileTab => 'Profiel';

  @override
  String get updateAvailableTitle => 'Update beschikbaar';

  @override
  String get updateAvailableContent =>
      'Er is een nieuwe versie van de app beschikbaar.\nUpdate om door te gaan.';

  @override
  String get updateButton => 'Updaten';

  @override
  String get aiChat => 'AI-chat';

  @override
  String get premiumService => 'Premium-service';

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
  String get annualPlan => 'Jaarabonnement';

  @override
  String get monthlyPlan => 'Maandelijks abonnement';

  @override
  String get recommended => 'Aanbevolen';

  @override
  String discountPercent(int percent) {
    return '$percent% KORTING';
  }

  @override
  String get trial => 'Proefperiode';

  @override
  String get perMonth => '/mnd';

  @override
  String get perYear => '/jr';

  @override
  String get restorePurchase => 'Aankoop herstellen';

  @override
  String get manageSubscription => 'Abonnement beheren';

  @override
  String startPremium(String price) {
    return 'Start Premium (vanaf $price/mnd)';
  }

  @override
  String get restoreSuccess => 'Aankoop succesvol hersteld';

  @override
  String get restoreFailed => 'Herstellen van aankoop mislukt';

  @override
  String get noPurchaseToRestore => 'Geen aankoop om te herstellen';

  @override
  String get ratingDialogTitle => 'Hoe vindt u de app?';

  @override
  String get ratingDialogDescription =>
      'Tik op de sterren om de app te beoordelen.';

  @override
  String get rateApp => 'Beoordelen';

  @override
  String get skipRating => 'Niet nu';

  @override
  String aiTimeoutError(int seconds) {
    return 'AI-verwerking time-out ($seconds seconden)';
  }

  @override
  String get aiNetworkError => 'Netwerkverbinding mislukt';

  @override
  String get aiConfigurationError =>
      'AI-service is niet correct geconfigureerd';

  @override
  String get aiRateLimitError => 'API-aanvraaglimiet bereikt';

  @override
  String get aiUnknownError => 'Er is een onverwachte fout opgetreden';

  @override
  String get fcmNotification => 'FCM-melding';

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
  String get aiConsentScreen => 'AI-gegevens en privacy';

  @override
  String get aiConsentContent =>
      'Deze app gebruikt Google Gemini AI (via Firebase) voor AI-functies. Door verder te gaan, stemt u in met het delen van relevante gegevens met de AI-service van Google.';

  @override
  String get aiConsentPrivacyLink => 'Privacybeleid bekijken';

  @override
  String get appName => 'MangaTrack';
}
