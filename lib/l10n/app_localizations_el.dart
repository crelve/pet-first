// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Καλώς ήρθατε στο $productName!';
  }

  @override
  String get descriptionMessage =>
      'Μην ξεχάσετε ποτέ τις κολλύριές σας. Παρακολουθήστε τη χρήση, διαχειριστείτε ημερομηνίες λήξης και λάβετε υπενθυμίσεις.';

  @override
  String get mainIntroductionScreen => 'Τα μάτια σας αξίζουν φροντίδα';

  @override
  String get mainIntroductionContent =>
      'Ορίστε υπενθυμίσεις για τα κολλύριά σας, παρακολουθήστε ημερομηνίες λήξης μετά το άνοιγμα.';

  @override
  String get serviceBeginScreen => 'Ξεκινήστε το ταξίδι σας';

  @override
  String get serviceBeginContent => 'Ξεκινήστε τη φροντίδα των ματιών!';

  @override
  String get signUp => 'Εγγραφή';

  @override
  String get close => 'Κοντά';

  @override
  String get skip => 'Παραλείπω';

  @override
  String get next => 'Επόμενο';

  @override
  String get setting => 'Ρύθμιση';

  @override
  String get languageSetting => 'Ρυθμίσεις γλώσσας';

  @override
  String get themeSetting => 'Ρυθμίσεις θέματος';

  @override
  String get themeLight => 'Φως';

  @override
  String get themeDark => 'Σκοτάδι';

  @override
  String get themeSystem => 'Προεπιλογή συστήματος';

  @override
  String get pushNotification => 'Push Notifications';

  @override
  String get ratingSent => 'Η βαθμολογία εστάλη';

  @override
  String get recommendApp => 'Προτεινόμενες εφαρμογές';

  @override
  String get contact => 'Επικοινωνήστε μαζί μας';

  @override
  String get legal => 'Νομικά';

  @override
  String get privacyPolicy => 'Πολιτική απορρήτου';

  @override
  String get license => 'Άδειες';

  @override
  String get error => 'Παρουσιάστηκε σφάλμα';

  @override
  String get networkError => 'Σφάλμα δικτύου';

  @override
  String review(Object productName) {
    return 'Αξιολόγηση $productName';
  }

  @override
  String share(Object productName) {
    return 'Κοινοποίηση $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Μοιραστείτε το $productName με όλους! $appLink';
  }

  @override
  String get writeReview => 'Γράψτε μια Αξιολόγηση';

  @override
  String get rate => 'Αξιολόγηση';

  @override
  String get notRate => 'Παράλειψη αξιολόγησης';

  @override
  String get unexpectedError => 'Παρουσιάστηκε μη αναμενόμενο σφάλμα';

  @override
  String get planInformationFetchFailed =>
      'Αποτυχία λήψης πληροφοριών προγράμματος.';

  @override
  String get subscriptionSettingTitle => 'Πρόγραμμα Premium';

  @override
  String get currentPlanPremium => 'Τρέχον πρόγραμμα: Premium';

  @override
  String get currentPlanFree => 'Τρέχον πρόγραμμα: Δωρεάν έκδοση';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Χωρίς διαφημίσεις';

  @override
  String get selectPlan => 'Επιλογή προγράμματος';

  @override
  String get continueWithFreePlan => 'Συνέχεια με δωρεάν πρόγραμμα';

  @override
  String get subscriptionCancellationNote =>
      'Μπορείτε να ακυρώσετε τη συνδρομή σας ανά πάσα στιγμή';

  @override
  String get purchaseCompleted => 'Η αγορά ολοκληρώθηκε';

  @override
  String get revenueCatNotConfigured => 'Το RevenueCat δεν έχει ρυθμιστεί';

  @override
  String get revenueCatInvalidApiKey => 'Μη έγκυρο κλειδί API RevenueCat';

  @override
  String get planInfoUnavailable =>
      'Οι πληροφορίες του προγράμματος δεν είναι διαθέσιμες';

  @override
  String get purchaseFailed => 'Η αγορά απέτυχε';

  @override
  String get limitedTimeOffer => 'Προσφορά περιορισμένου χρόνου: ';

  @override
  String get homeTab => 'Αρχική';

  @override
  String get exploreTab => 'Εξερεύνηση';

  @override
  String get settingsTab => 'Ρυθμίσεις';

  @override
  String get favoriteTab => 'Αγαπημένα';

  @override
  String get profileTab => 'Προφίλ';

  @override
  String get updateAvailableTitle => 'Διαθέσιμη ενημέρωση';

  @override
  String get updateAvailableContent =>
      'Μια νέα έκδοση της εφαρμογής είναι διαθέσιμη.\nΕνημερώστε για να συνεχίσετε.';

  @override
  String get updateButton => 'Εκσυγχρονίζω';

  @override
  String get aiChat => 'AI Chat';

  @override
  String get premiumService => 'Υπηρεσία Premium';

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
  String get annualPlan => 'Ετήσιο πρόγραμμα';

  @override
  String get monthlyPlan => 'Μηνιαίο πρόγραμμα';

  @override
  String get recommended => 'Συνιστάται';

  @override
  String discountPercent(int percent) {
    return '$percent% ΕΚΠΤΩΣΗ';
  }

  @override
  String get trial => 'Δοκιμαστική';

  @override
  String get perMonth => '/μήνα';

  @override
  String get perYear => '/έτος';

  @override
  String get restorePurchase => 'Επαναφορά αγοράς';

  @override
  String get manageSubscription => 'Διαχείριση συνδρομής';

  @override
  String startPremium(String price) {
    return 'Ξεκινήστε Premium (από $price/μήνα)';
  }

  @override
  String get restoreSuccess => 'Η αγορά επαν αφέρθηκε επιτυχώς';

  @override
  String get restoreFailed => 'Αποτυχία επαναφοράς αγοράς';

  @override
  String get noPurchaseToRestore => 'Δεν υπάρχει αγορά για επαναφορά';

  @override
  String get ratingDialogTitle => 'Πώς σας φαίνεται η εφαρμογή;';

  @override
  String get ratingDialogDescription =>
      'Πατήστε τα αστέρια για να βαθμολογήσετε την εφαρμογή.';

  @override
  String get rateApp => 'Τιμή';

  @override
  String get skipRating => 'Όχι τώρα';

  @override
  String aiTimeoutError(int seconds) {
    return 'Η επεξεργασία AI έληξε ($seconds δευτερόλεπτα)';
  }

  @override
  String get aiNetworkError => 'Η σύνδεση δικτύου απέτυχε';

  @override
  String get aiConfigurationError => 'Η υπηρεσία AI δεν έχει ρυθμιστεί σωστά';

  @override
  String get aiRateLimitError => 'Επιτεύχθηκε το όριο αιτημάτων API';

  @override
  String get aiUnknownError => 'Παρουσιάστηκε μη αναμενόμενο σφάλμα';

  @override
  String get fcmNotification => 'Ειδοποίηση FCM';

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
  String get aiConsentScreen => 'Δεδομένα ΤΝ & Απόρρητο';

  @override
  String get aiConsentContent =>
      'Αυτή η εφαρμογή χρησιμοποιεί Google Gemini AI (μέσω Firebase) για λειτουργίες ΤΝ. Συνεχίζοντας, συναινείτε στην κοινή χρήση σχετικών δεδομένων με την υπηρεσία AI της Google.';

  @override
  String get aiConsentPrivacyLink => 'Προβολή Πολιτικής Απορρήτου';

  @override
  String get appName => 'MangaTrack';
}
