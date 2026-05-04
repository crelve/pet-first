// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return '$productName uygulamasına hoş geldiniz!';
  }

  @override
  String get descriptionMessage =>
      'Göz damlalarınızı asla unutmayın. Kullanımı takip edin, açılış sonrası son kullanma tarihlerini yönetin ve doğru zamanda hatırlatıcı alın.';

  @override
  String get mainIntroductionScreen => 'Gözleriniz özen hak ediyor';

  @override
  String get mainIntroductionContent =>
      'Göz damlaları için hatırlatıcı ayarlayın, açılış sonrası son kullanma tarihlerini takip edin.';

  @override
  String get serviceBeginScreen => 'Yolculuğunuzu Başlatın';

  @override
  String get serviceBeginContent => 'Göz sağlığınıza başlayın!';

  @override
  String get signUp => 'Kayıt ol';

  @override
  String get close => 'Kapat';

  @override
  String get skip => 'Atla';

  @override
  String get next => 'İleri';

  @override
  String get setting => 'Ayar';

  @override
  String get languageSetting => 'Dil Ayarları';

  @override
  String get themeSetting => 'Tema Ayarları';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem Varsayılanı';

  @override
  String get pushNotification => 'Bildirimler';

  @override
  String get ratingSent => 'Değerlendirme gönderildi';

  @override
  String get recommendApp => 'Önerilen Uygulamalar';

  @override
  String get contact => 'Bize Ulaşın';

  @override
  String get legal => 'Yasal';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get license => 'Lisanslar';

  @override
  String get error => 'Bir hata oluştu';

  @override
  String get networkError => 'Ağ Hatası';

  @override
  String review(Object productName) {
    return '$productName İnceleme';
  }

  @override
  String share(Object productName) {
    return '$productName Paylaş';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return '$productName uygulamasını herkesle paylaşın! $appLink';
  }

  @override
  String get writeReview => 'Yorum Yaz';

  @override
  String get rate => 'Puanla';

  @override
  String get notRate => 'Puanlamayı Atla';

  @override
  String get unexpectedError => 'Beklenmeyen bir hata oluştu';

  @override
  String get planInformationFetchFailed => 'Plan bilgileri alınamadı.';

  @override
  String get subscriptionSettingTitle => 'Premium Planı';

  @override
  String get currentPlanPremium => 'Mevcut Plan: Premium';

  @override
  String get currentPlanFree => 'Mevcut Plan: Ücretsiz Sürüm';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Reklamsız';

  @override
  String get selectPlan => 'Plan Seç';

  @override
  String get continueWithFreePlan => 'Ücretsiz planla devam et';

  @override
  String get subscriptionCancellationNote =>
      'Aboneliğinizi istediğiniz zaman iptal edebilirsiniz';

  @override
  String get purchaseCompleted => 'Satın alma tamamlandı';

  @override
  String get revenueCatNotConfigured => 'RevenueCat yapılandırılmamış';

  @override
  String get revenueCatInvalidApiKey => 'Geçersiz RevenueCat API anahtarı';

  @override
  String get planInfoUnavailable => 'Plan bilgileri mevcut değil';

  @override
  String get purchaseFailed => 'Satın alma başarısız oldu';

  @override
  String get limitedTimeOffer => 'Sınırlı Süreli Teklif: ';

  @override
  String get homeTab => 'Ana Sayfa';

  @override
  String get exploreTab => 'Keşfet';

  @override
  String get settingsTab => 'Ayarlar';

  @override
  String get favoriteTab => 'Favoriler';

  @override
  String get profileTab => 'Profil';

  @override
  String get updateAvailableTitle => 'Güncelleme Mevcut';

  @override
  String get updateAvailableContent =>
      'Uygulamanın yeni bir sürümü mevcut.\nDevam etmek için lütfen güncelleyin.';

  @override
  String get updateButton => 'Güncelle';

  @override
  String get aiChat => 'AI Sohbet';

  @override
  String get premiumService => 'Premium Hizmet';

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
  String get annualPlan => 'Yıllık Plan';

  @override
  String get monthlyPlan => 'Aylık Plan';

  @override
  String get recommended => 'Önerilen';

  @override
  String discountPercent(int percent) {
    return '$percent% İNDİRİM';
  }

  @override
  String get trial => 'Deneme';

  @override
  String get perMonth => '/ay';

  @override
  String get perYear => '/yıl';

  @override
  String get restorePurchase => 'Satın Almayı Geri Yükle';

  @override
  String get manageSubscription => 'Aboneliği Yönet';

  @override
  String startPremium(String price) {
    return 'Premium\'a Başla ($price/ay\'dan başlayan)';
  }

  @override
  String get restoreSuccess => 'Satın alma başarıyla geri yüklendi';

  @override
  String get restoreFailed => 'Satın alma geri yüklenemedi';

  @override
  String get noPurchaseToRestore => 'Geri yüklenecek satın alma yok';

  @override
  String get ratingDialogTitle => 'Uygulamayı nasıl buldunuz?';

  @override
  String get ratingDialogDescription =>
      'Uygulamayı değerlendirmek için yıldızlara dokunun.';

  @override
  String get rateApp => 'Değerlendir';

  @override
  String get skipRating => 'Şimdi Değil';

  @override
  String aiTimeoutError(int seconds) {
    return 'AI işleme zaman aşımına uğradı ($seconds saniye)';
  }

  @override
  String get aiNetworkError => 'Ağ bağlantısı başarısız oldu';

  @override
  String get aiConfigurationError => 'AI hizmeti düzgün yapılandırılmamış';

  @override
  String get aiRateLimitError => 'API istek sınırına ulaşıldı';

  @override
  String get aiUnknownError => 'Beklenmeyen bir hata oluştu';

  @override
  String get fcmNotification => 'FCM Bildirimi';

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
  String get aiConsentScreen => 'Yapay Zeka Verisi ve Gizlilik';

  @override
  String get aiConsentContent =>
      'Bu uygulama, AI özellikleri için Google Gemini AI\'yı (Firebase aracılığıyla) kullanır. Devam ederek ilgili verileri Google\'ın AI hizmetiyle paylaşmayı kabul etmiş olursunuz.';

  @override
  String get aiConsentPrivacyLink => 'Gizlilik Politikasını Görüntüle';

  @override
  String get appName => 'MangaTrack';
}
