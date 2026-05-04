// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Vitajte v $productName!';
  }

  @override
  String get descriptionMessage =>
      'Nikdy nezabudnite na očné kvapky. Sledujte použitie, spravujte dátumy expirácie a dostávajte pripomienky v správnom čase.';

  @override
  String get mainIntroductionScreen => 'Vaše oči si zaslúžia starostlivosť';

  @override
  String get mainIntroductionContent =>
      'Nastavte pripomienky pre očné kvapky, sledujte dátumy expirácie po otvorení a spravujte viac fľaštičiek.';

  @override
  String get serviceBeginScreen => 'Začnite svoju cestu';

  @override
  String get serviceBeginContent => 'Začnite sa starať o oči!';

  @override
  String get signUp => 'Registrovať sa';

  @override
  String get close => 'Zavrieť';

  @override
  String get skip => 'Preskočiť';

  @override
  String get next => 'Ďalej';

  @override
  String get setting => 'Nastavenie';

  @override
  String get languageSetting => 'Nastavenia jazyka';

  @override
  String get themeSetting => 'Nastavenia témy';

  @override
  String get themeLight => 'Svetlá';

  @override
  String get themeDark => 'Tmavá';

  @override
  String get themeSystem => 'Systémové predvolené';

  @override
  String get pushNotification => 'Push notifikácie';

  @override
  String get ratingSent => 'Hodnotenie odoslané';

  @override
  String get recommendApp => 'Odporúčané aplikácie';

  @override
  String get contact => 'Kontaktujte nás';

  @override
  String get legal => 'Právne';

  @override
  String get privacyPolicy => 'Zásady ochrany osobných údajov';

  @override
  String get license => 'Licencie';

  @override
  String get error => 'Vyskytla sa chyba';

  @override
  String get networkError => 'Chyba siete';

  @override
  String review(Object productName) {
    return 'Recenzia $productName';
  }

  @override
  String share(Object productName) {
    return 'Zdieľať $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Zdieľajte $productName so všetkými! $appLink';
  }

  @override
  String get writeReview => 'Napísať recenziu';

  @override
  String get rate => 'Ohodnotiť';

  @override
  String get notRate => 'Preskočiť hodnotenie';

  @override
  String get unexpectedError => 'Vyskytla sa neočakávaná chyba';

  @override
  String get planInformationFetchFailed =>
      'Nepodarilo sa načítať informácie o pláne.';

  @override
  String get subscriptionSettingTitle => 'Prémiový plán';

  @override
  String get currentPlanPremium => 'Aktuálny plán: Premium';

  @override
  String get currentPlanFree => 'Aktuálny plán: Bezplatná verzia';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Bez reklám';

  @override
  String get selectPlan => 'Vybrať plán';

  @override
  String get continueWithFreePlan => 'Pokračovať s bezplatným plánom';

  @override
  String get subscriptionCancellationNote =>
      'Predplatné môžete kedykoľvek zrušiť';

  @override
  String get purchaseCompleted => 'Nákup dokončený';

  @override
  String get revenueCatNotConfigured => 'RevenueCat nie je nakonfigurovaný';

  @override
  String get revenueCatInvalidApiKey => 'Neplatný API kľúč RevenueCat';

  @override
  String get planInfoUnavailable => 'Informácie o pláne nie sú k dispozícii';

  @override
  String get purchaseFailed => 'Nákup zlyhal';

  @override
  String get limitedTimeOffer => 'Ponuka s obmedzeným časom: ';

  @override
  String get homeTab => 'Domov';

  @override
  String get exploreTab => 'Preskúmať';

  @override
  String get settingsTab => 'Nastavenia';

  @override
  String get favoriteTab => 'Obľúbené';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'K dispozícii je aktualizácia';

  @override
  String get updateAvailableContent =>
      'Je k dispozícii nová verzia aplikácie.\nAktualizujte prosím, aby ste mohli pokračovať.';

  @override
  String get updateButton => 'Aktualizovať';

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
  String get annualPlan => 'Ročný plán';

  @override
  String get monthlyPlan => 'Mesačný plán';

  @override
  String get recommended => 'Odporúčané';

  @override
  String discountPercent(int percent) {
    return '$percent% ZĽAVA';
  }

  @override
  String get trial => 'Skúšobný';

  @override
  String get perMonth => '/mes';

  @override
  String get perYear => '/rok';

  @override
  String get restorePurchase => 'Obnoviť nákup';

  @override
  String get manageSubscription => 'Spravovať predplatné';

  @override
  String startPremium(String price) {
    return 'Začať Premium (od $price/mes)';
  }

  @override
  String get restoreSuccess => 'Nákup bol úspešne obnovený';

  @override
  String get restoreFailed => 'Obnova nákupu zlyhala';

  @override
  String get noPurchaseToRestore => 'Žiadny nákup na obnovenie';

  @override
  String get ratingDialogTitle => 'Ako sa vám aplikácia páči?';

  @override
  String get ratingDialogDescription =>
      'Klepnutím na hviezdičky ohodnoťte aplikáciu.';

  @override
  String get rateApp => 'Ohodnoťte';

  @override
  String get skipRating => 'Teraz nie';

  @override
  String aiTimeoutError(int seconds) {
    return 'Spracovanie AI vypršalo ($seconds sekúnd)';
  }

  @override
  String get aiNetworkError => 'Sieťové pripojenie zlyhalo';

  @override
  String get aiConfigurationError => 'Služba AI nie je správne nakonfigurovaná';

  @override
  String get aiRateLimitError => 'Dosiahnutý limit API požiadaviek';

  @override
  String get aiUnknownError => 'Vyskytla sa neočakávaná chyba';

  @override
  String get fcmNotification => 'FCM notifikácia';

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
  String get aiConsentScreen => 'Údaje AI a ochrana súkromia';

  @override
  String get aiConsentContent =>
      'Táto aplikácia používa Google Gemini AI (cez Firebase) pre funkcie AI. Pokračovaním súhlasíte so zdieľaním relevantných údajov so službou AI spoločnosti Google.';

  @override
  String get aiConsentPrivacyLink => 'Zobraziť zásady ochrany osobných údajov';

  @override
  String get appName => 'MangaTrack';
}
