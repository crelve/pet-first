// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Vítejte v $productName!';
  }

  @override
  String get descriptionMessage =>
      'Nikdy nezapomeňte na oční kapky. Sledujte použití, spravujte data expirace a dostávejte připomenutí ve správný čas.';

  @override
  String get mainIntroductionScreen => 'Vaše oči si zaslouží péči';

  @override
  String get mainIntroductionContent =>
      'Nastavte si připomenutí pro oční kapky, sledujte data expirace a spravujte více lahviček.';

  @override
  String get serviceBeginScreen => 'Začněte svou cestu';

  @override
  String get serviceBeginContent => 'Začněte pečovat o své oči!';

  @override
  String get signUp => 'Zaregistrovat se';

  @override
  String get close => 'Blízko';

  @override
  String get skip => 'Přeskočit';

  @override
  String get next => 'Další';

  @override
  String get setting => 'Nastavení';

  @override
  String get languageSetting => 'Nastavení jazyka';

  @override
  String get themeSetting => 'Nastavení motivu';

  @override
  String get themeLight => 'Světlo';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get themeSystem => 'Výchozí nastavení systému';

  @override
  String get pushNotification => 'Push oznámení';

  @override
  String get ratingSent => 'Hodnocení odesláno';

  @override
  String get recommendApp => 'Doporučené aplikace';

  @override
  String get contact => 'Kontaktujte nás';

  @override
  String get legal => 'Právní';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get license => 'Licence';

  @override
  String get error => 'Došlo k chybě';

  @override
  String get networkError => 'Chyba sítě';

  @override
  String review(Object productName) {
    return 'Recenze $productName';
  }

  @override
  String share(Object productName) {
    return 'Sdílet $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Sdílejte $productName se všemi! $appLink';
  }

  @override
  String get writeReview => 'Napsat recenzi';

  @override
  String get rate => 'Ohodnotit';

  @override
  String get notRate => 'Přeskočit hodnocení';

  @override
  String get unexpectedError => 'Došlo k neočekávané chybě';

  @override
  String get planInformationFetchFailed =>
      'Nepodařilo se získat informace o plánu.';

  @override
  String get subscriptionSettingTitle => 'Prémiový plán';

  @override
  String get currentPlanPremium => 'Aktuální plán: Premium';

  @override
  String get currentPlanFree => 'Aktuální plán: Bezplatná verze';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Bez reklam';

  @override
  String get selectPlan => 'Vybrat plán';

  @override
  String get continueWithFreePlan => 'Pokračovat s bezplatným plánem';

  @override
  String get subscriptionCancellationNote => 'Předplatné můžete kdykoli zrušit';

  @override
  String get purchaseCompleted => 'Nákup dokončen';

  @override
  String get revenueCatNotConfigured => 'RevenueCat není nakonfigurován';

  @override
  String get revenueCatInvalidApiKey => 'Neplatný API klíč RevenueCat';

  @override
  String get planInfoUnavailable => 'Informace o plánu nejsou k dispozici';

  @override
  String get purchaseFailed => 'Nákup se nezdařil';

  @override
  String get limitedTimeOffer => 'Nabídka na omezenou dobu: ';

  @override
  String get homeTab => 'Domů';

  @override
  String get exploreTab => 'Prozkoumat';

  @override
  String get settingsTab => 'Nastavení';

  @override
  String get favoriteTab => 'Oblíbené';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Aktualizace k dispozici';

  @override
  String get updateAvailableContent =>
      'K dispozici je nová verze aplikace.\nChcete-li pokračovat, aktualizujte.';

  @override
  String get updateButton => 'Aktualizovat';

  @override
  String get aiChat => 'AI chat';

  @override
  String get premiumService => 'Prémiová služba';

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
  String get annualPlan => 'Roční plán';

  @override
  String get monthlyPlan => 'Měsíční plán';

  @override
  String get recommended => 'Doporučeno';

  @override
  String discountPercent(int percent) {
    return '$percent% SLEVA';
  }

  @override
  String get trial => 'Zkušební';

  @override
  String get perMonth => '/měs';

  @override
  String get perYear => '/rok';

  @override
  String get restorePurchase => 'Obnovit nákup';

  @override
  String get manageSubscription => 'Spravovat předplatné';

  @override
  String startPremium(String price) {
    return 'Začít Premium (od $price/měs)';
  }

  @override
  String get restoreSuccess => 'Nákup byl úspěšně obnoven';

  @override
  String get restoreFailed => 'Nepodařilo se obnovit nákup';

  @override
  String get noPurchaseToRestore => 'Žádný nákup k obnovení';

  @override
  String get ratingDialogTitle => 'Jak se vám aplikace líbí?';

  @override
  String get ratingDialogDescription =>
      'Klepnutím na hvězdičky aplikaci ohodnotíte.';

  @override
  String get rateApp => 'Hodnotit';

  @override
  String get skipRating => 'Teď ne';

  @override
  String aiTimeoutError(int seconds) {
    return 'Zpracování AI vypršel časový limit ($seconds sekund)';
  }

  @override
  String get aiNetworkError => 'Připojení k síti se nezdařilo';

  @override
  String get aiConfigurationError => 'Služba AI není správně nakonfigurována';

  @override
  String get aiRateLimitError => 'Dosažen limit požadavků API';

  @override
  String get aiUnknownError => 'Došlo k neočekávané chybě';

  @override
  String get fcmNotification => 'FCM notifikace';

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
  String get aiConsentScreen => 'Data a soukromí AI';

  @override
  String get aiConsentContent =>
      'Tato aplikace používá Google Gemini AI (přes Firebase) k zajištění funkcí AI. Pokračováním souhlasíte se sdílením relevantních dat se službou Google AI.';

  @override
  String get aiConsentPrivacyLink => 'Zobrazit zásady ochrany osobních údajů';

  @override
  String get appName => 'MangaTrack';
}
