// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Selamat datang di $productName!';
  }

  @override
  String get descriptionMessage =>
      'Jangan pernah lupa tetes mata Anda. Lacak penggunaan, kelola tanggal kedaluwarsa setelah dibuka, dan dapatkan pengingat tepat waktu.';

  @override
  String get mainIntroductionScreen => 'Mata Anda layak mendapat perawatan';

  @override
  String get mainIntroductionContent =>
      'Setel pengingat untuk tetes mata, lacak tanggal kedaluwarsa setelah dibuka, dan kelola beberapa botol dengan mudah.';

  @override
  String get serviceBeginScreen => 'Mulai Perjalanan Anda';

  @override
  String get serviceBeginContent => 'Mulai merawat mata Anda!';

  @override
  String get signUp => 'Daftar';

  @override
  String get close => 'Tutup';

  @override
  String get skip => 'Lewati';

  @override
  String get next => 'Berikutnya';

  @override
  String get setting => 'Pengaturan';

  @override
  String get languageSetting => 'Pengaturan Bahasa';

  @override
  String get themeSetting => 'Pengaturan Tema';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Default Sistem';

  @override
  String get pushNotification => 'Notifikasi Push';

  @override
  String get ratingSent => 'Penilaian terkirim';

  @override
  String get recommendApp => 'Aplikasi Rekomendasi';

  @override
  String get contact => 'Hubungi Kami';

  @override
  String get legal => 'Hukum';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get license => 'Lisensi';

  @override
  String get error => 'Terjadi kesalahan';

  @override
  String get networkError => 'Kesalahan Jaringan';

  @override
  String review(Object productName) {
    return 'Ulasan $productName';
  }

  @override
  String share(Object productName) {
    return 'Bagikan $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Bagikan $productName dengan semua orang! $appLink';
  }

  @override
  String get writeReview => 'Tulis Ulasan';

  @override
  String get rate => 'Nilai';

  @override
  String get notRate => 'Lewati Penilaian';

  @override
  String get unexpectedError => 'Terjadi kesalahan yang tidak terduga';

  @override
  String get planInformationFetchFailed => 'Gagal mengambil informasi paket.';

  @override
  String get subscriptionSettingTitle => 'Paket Premium';

  @override
  String get currentPlanPremium => 'Paket Saat Ini: Premium';

  @override
  String get currentPlanFree => 'Paket Saat Ini: Versi Gratis';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Bebas Iklan';

  @override
  String get selectPlan => 'Pilih Paket';

  @override
  String get continueWithFreePlan => 'Lanjutkan dengan paket gratis';

  @override
  String get subscriptionCancellationNote =>
      'Anda dapat membatalkan langganan kapan saja';

  @override
  String get purchaseCompleted => 'Pembelian selesai';

  @override
  String get revenueCatNotConfigured => 'RevenueCat belum dikonfigurasi';

  @override
  String get revenueCatInvalidApiKey => 'Kunci API RevenueCat tidak valid';

  @override
  String get planInfoUnavailable => 'Informasi paket tidak tersedia';

  @override
  String get purchaseFailed => 'Pembelian gagal';

  @override
  String get limitedTimeOffer => 'Penawaran Terbatas: ';

  @override
  String get homeTab => 'Beranda';

  @override
  String get exploreTab => 'Jelajahi';

  @override
  String get settingsTab => 'Pengaturan';

  @override
  String get favoriteTab => 'Favorit';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Pembaruan Tersedia';

  @override
  String get updateAvailableContent =>
      'Versi baru aplikasi telah tersedia.\nSilakan perbarui untuk melanjutkan.';

  @override
  String get updateButton => 'Perbarui';

  @override
  String get aiChat => 'Obrolan AI';

  @override
  String get premiumService => 'Layanan Premium';

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
  String get annualPlan => 'Paket Tahunan';

  @override
  String get monthlyPlan => 'Paket Bulanan';

  @override
  String get recommended => 'Direkomendasikan';

  @override
  String discountPercent(int percent) {
    return 'DISKON $percent%';
  }

  @override
  String get trial => 'Uji Coba';

  @override
  String get perMonth => '/bln';

  @override
  String get perYear => '/thn';

  @override
  String get restorePurchase => 'Pulihkan Pembelian';

  @override
  String get manageSubscription => 'Kelola Langganan';

  @override
  String startPremium(String price) {
    return 'Mulai Premium (dari $price/bln)';
  }

  @override
  String get restoreSuccess => 'Pembelian berhasil dipulihkan';

  @override
  String get restoreFailed => 'Gagal memulihkan pembelian';

  @override
  String get noPurchaseToRestore => 'Tidak ada pembelian untuk dipulihkan';

  @override
  String get ratingDialogTitle =>
      'Bagaimana pendapat Anda tentang aplikasi ini?';

  @override
  String get ratingDialogDescription => 'Ketuk bintang untuk menilai aplikasi.';

  @override
  String get rateApp => 'Beri Nilai';

  @override
  String get skipRating => 'Nanti Saja';

  @override
  String aiTimeoutError(int seconds) {
    return 'Pemrosesan AI habis waktu ($seconds detik)';
  }

  @override
  String get aiNetworkError => 'Koneksi jaringan gagal';

  @override
  String get aiConfigurationError =>
      'Layanan AI tidak dikonfigurasi dengan benar';

  @override
  String get aiRateLimitError => 'Batas permintaan API tercapai';

  @override
  String get aiUnknownError => 'Terjadi kesalahan yang tidak terduga';

  @override
  String get fcmNotification => 'Notifikasi FCM';

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
      'Aplikasi ini menggunakan Google Gemini AI (melalui Firebase) untuk fitur AI. Dengan melanjutkan, Anda menyetujui berbagi data yang relevan dengan layanan AI Google.';

  @override
  String get aiConsentPrivacyLink => 'Lihat Kebijakan Privasi';

  @override
  String get appName => 'MangaTrack';
}
