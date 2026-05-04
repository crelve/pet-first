// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Selamat datang ke $productName!';
  }

  @override
  String get descriptionMessage =>
      'Jangan lupa titisan mata anda. Jejak penggunaan, urus tarikh luput selepas dibuka dan terima peringatan pada masa yang tepat.';

  @override
  String get mainIntroductionScreen => 'Mata anda layak mendapat penjagaan';

  @override
  String get mainIntroductionContent =>
      'Tetapkan peringatan untuk titisan mata, jejak tarikh luput selepas dibuka dan urus beberapa botol.';

  @override
  String get serviceBeginScreen => 'Mulakan Perjalanan Anda';

  @override
  String get serviceBeginContent => 'Mulakan penjagaan mata anda!';

  @override
  String get signUp => 'Daftar';

  @override
  String get close => 'Tutup';

  @override
  String get skip => 'Langkau';

  @override
  String get next => 'Seterusnya';

  @override
  String get setting => 'Tetapan';

  @override
  String get languageSetting => 'Tetapan Bahasa';

  @override
  String get themeSetting => 'Tetapan Tema';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Lalai Sistem';

  @override
  String get pushNotification => 'Notifikasi Tolak';

  @override
  String get ratingSent => 'Penilaian dihantar';

  @override
  String get recommendApp => 'Aplikasi Disyorkan';

  @override
  String get contact => 'Hubungi Kami';

  @override
  String get legal => 'Undang-undang';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get license => 'Lesen';

  @override
  String get error => 'Ralat telah berlaku';

  @override
  String get networkError => 'Ralat Rangkaian';

  @override
  String review(Object productName) {
    return 'Ulasan $productName';
  }

  @override
  String share(Object productName) {
    return 'Kongsi $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Kongsikan $productName dengan semua orang! $appLink';
  }

  @override
  String get writeReview => 'Tulis Ulasan';

  @override
  String get rate => 'Nilai';

  @override
  String get notRate => 'Langkau Penilaian';

  @override
  String get unexpectedError => 'Ralat tidak dijangka berlaku';

  @override
  String get planInformationFetchFailed => 'Gagal mendapatkan maklumat pelan.';

  @override
  String get subscriptionSettingTitle => 'Pelan Premium';

  @override
  String get currentPlanPremium => 'Pelan Semasa: Premium';

  @override
  String get currentPlanFree => 'Pelan Semasa: Versi Percuma';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Bebas Iklan';

  @override
  String get selectPlan => 'Pilih Pelan';

  @override
  String get continueWithFreePlan => 'Teruskan dengan pelan percuma';

  @override
  String get subscriptionCancellationNote =>
      'Anda boleh batalkan langganan pada bila-bila masa';

  @override
  String get purchaseCompleted => 'Pembelian selesai';

  @override
  String get revenueCatNotConfigured => 'RevenueCat belum dikonfigurasikan';

  @override
  String get revenueCatInvalidApiKey => 'Kunci API RevenueCat tidak sah';

  @override
  String get planInfoUnavailable => 'Maklumat pelan tidak tersedia';

  @override
  String get purchaseFailed => 'Pembelian gagal';

  @override
  String get limitedTimeOffer => 'Tawaran Masa Terhad: ';

  @override
  String get homeTab => 'Laman Utama';

  @override
  String get exploreTab => 'Terokai';

  @override
  String get settingsTab => 'Tetapan';

  @override
  String get favoriteTab => 'Kegemaran';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Kemas Kini Tersedia';

  @override
  String get updateAvailableContent =>
      'Versi baharu aplikasi tersedia.\nSila kemas kini untuk meneruskan.';

  @override
  String get updateButton => 'Kemas Kini';

  @override
  String get aiChat => 'Sembang AI';

  @override
  String get premiumService => 'Perkhidmatan Premium';

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
  String get annualPlan => 'Pelan Tahunan';

  @override
  String get monthlyPlan => 'Pelan Bulanan';

  @override
  String get recommended => 'Disyorkan';

  @override
  String discountPercent(int percent) {
    return 'DISKAUN $percent%';
  }

  @override
  String get trial => 'Percubaan';

  @override
  String get perMonth => '/bln';

  @override
  String get perYear => '/thn';

  @override
  String get restorePurchase => 'Pulihkan Pembelian';

  @override
  String get manageSubscription => 'Urus Langganan';

  @override
  String startPremium(String price) {
    return 'Mula Premium (dari $price/bln)';
  }

  @override
  String get restoreSuccess => 'Pembelian berjaya dipulihkan';

  @override
  String get restoreFailed => 'Gagal memulihkan pembelian';

  @override
  String get noPurchaseToRestore => 'Tiada pembelian untuk dipulihkan';

  @override
  String get ratingDialogTitle =>
      'Bagaimana pendapat anda tentang aplikasi ini?';

  @override
  String get ratingDialogDescription => 'Ketik bintang untuk menilai aplikasi.';

  @override
  String get rateApp => 'Nilai';

  @override
  String get skipRating => 'Tidak Sekarang';

  @override
  String aiTimeoutError(int seconds) {
    return 'Pemprosesan AI tamat masa ($seconds saat)';
  }

  @override
  String get aiNetworkError => 'Sambungan rangkaian gagal';

  @override
  String get aiConfigurationError =>
      'Perkhidmatan AI tidak dikonfigurasikan dengan betul';

  @override
  String get aiRateLimitError => 'Had permintaan API tercapai';

  @override
  String get aiUnknownError => 'Ralat tidak dijangka berlaku';

  @override
  String get fcmNotification => 'Pemberitahuan FCM';

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
  String get aiConsentScreen => 'Data AI & Privasi';

  @override
  String get aiConsentContent =>
      'Aplikasi ini menggunakan Google Gemini AI (melalui Firebase) untuk ciri AI. Dengan meneruskan, anda bersetuju untuk berkongsi data yang berkaitan dengan perkhidmatan AI Google.';

  @override
  String get aiConsentPrivacyLink => 'Lihat Dasar Privasi';

  @override
  String get appName => 'MangaTrack';
}
