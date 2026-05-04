// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get productName => 'Bird Log – يوميات الطيور';

  @override
  String welcomeMessage(Object productName) {
    return 'مرحباً بك في $productName!';
  }

  @override
  String get descriptionMessage =>
      'لا تنسَ قطرات عينك أبداً. تتبع الاستخدام وإدارة تواريخ الانتهاء بعد الفتح والحصول على تذكيرات في الوقت المناسب.';

  @override
  String get mainIntroductionScreen => 'عيناك تستحقان الرعاية';

  @override
  String get mainIntroductionContent =>
      'اضبط تذكيرات لقطرات عينك، وتتبع تواريخ الانتهاء بعد الفتح وادر زجاجات متعددة بسهولة.';

  @override
  String get serviceBeginScreen => 'بدء الخدمة';

  @override
  String get serviceBeginContent => 'ابدأ العناية بعينيك!';

  @override
  String get signUp => 'ابدأ';

  @override
  String get close => 'يغلق';

  @override
  String get skip => 'يتخطى';

  @override
  String get next => 'التالي';

  @override
  String get setting => 'الإعدادات';

  @override
  String get languageSetting => 'إعدادات اللغة';

  @override
  String get themeSetting => 'إعدادات الموضوع';

  @override
  String get themeLight => 'ضوء';

  @override
  String get themeDark => 'مظلم';

  @override
  String get themeSystem => 'النظام الافتراضي';

  @override
  String get pushNotification => 'دفع الإخطارات';

  @override
  String get ratingSent => 'تم إرسال التقييم';

  @override
  String get recommendApp => 'التطبيقات الموصى بها';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get legal => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get license => 'التراخيص';

  @override
  String get error => 'حدث خطأ';

  @override
  String get networkError => 'خطأ في الشبكة';

  @override
  String review(Object productName) {
    return 'تقييم $productName';
  }

  @override
  String share(Object productName) {
    return 'مشاركة $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'شارك $productName مع الجميع! $appLink';
  }

  @override
  String get writeReview => 'اكتب مراجعة';

  @override
  String get rate => 'تقييم';

  @override
  String get notRate => 'تخطي التقييم';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get planInformationFetchFailed => 'فشل في جلب معلومات الخطة.';

  @override
  String get subscriptionSettingTitle => 'الخطة المميزة';

  @override
  String get currentPlanPremium => 'الخطة الحالية: خطة ممتازة';

  @override
  String get currentPlanFree => 'الخطة الحالية: النسخة المجانية';

  @override
  String get premiumPlanBenefits => 'Keep Fresh بريميوم';

  @override
  String get adFree => 'بدون إعلانات';

  @override
  String get selectPlan => 'اختر الخطة';

  @override
  String get continueWithFreePlan => 'متابعة بالخطة المجانية';

  @override
  String get subscriptionCancellationNote =>
      '* الاشتراك قابل للإلغاء في أي وقت';

  @override
  String get purchaseCompleted => 'تم الشراء بنجاح!';

  @override
  String get revenueCatNotConfigured =>
      'لم يتم إعداد RevenueCat. الرجاء الاتصال بالمطور.';

  @override
  String get revenueCatInvalidApiKey =>
      'مفتاح API لـ RevenueCat غير صالح. يرجى التحقق من الإعدادات.';

  @override
  String get planInfoUnavailable =>
      'المعلومات غير متوفرة حاليًا.\nالرجاء المحاولة لاحقًا.';

  @override
  String get purchaseFailed => 'فشل الشراء';

  @override
  String get limitedTimeOffer => 'عرض لفترة محدودة: ';

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get exploreTab => 'استكشف';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get favoriteTab => 'المفضلة';

  @override
  String get profileTab => 'الملف الشخصي';

  @override
  String get updateAvailableTitle => 'التحديث متاح';

  @override
  String get updateAvailableContent =>
      'يتوفر إصدار جديد من التطبيق.\nيرجى التحديث للمتابعة.';

  @override
  String get updateButton => 'تحديث';

  @override
  String get aiChat => 'دردشة الذكاء الاصطناعي';

  @override
  String get premiumService => 'الخدمة المميزة';

  @override
  String get benefitFullAccess => 'رعاية عيون كاملة';

  @override
  String get benefitFullAccessDesc =>
      'سجل كل استخدام لقطرات العين للحفاظ على صحة عينيك ✨';

  @override
  String get benefitPremiumOnly => 'إدارة زجاجات متعددة';

  @override
  String get benefitPremiumOnlyDesc =>
      'أدر جميع زجاجات قطرات العين دون التشوش في الجداول 👁️';

  @override
  String get benefitUnlimited => 'قطرات بلا حدود';

  @override
  String get benefitUnlimitedDesc => 'تتبع أي عدد من الزجاجات دون قيود 💧';

  @override
  String get benefitNoAds => 'بدون إعلانات';

  @override
  String get benefitNoAdsDesc => 'استمتع بتجربة سلسة دون أي انقطاعات 🎯';

  @override
  String get annualPlan => 'الخطة السنوية';

  @override
  String get monthlyPlan => 'الخطة الشهرية';

  @override
  String get recommended => 'موصى به';

  @override
  String discountPercent(int percent) {
    return 'خصم $percent%';
  }

  @override
  String get trial => 'تجريبي';

  @override
  String get perMonth => '/شهر';

  @override
  String get perYear => '/سنة';

  @override
  String get restorePurchase => 'استعادة الشراء';

  @override
  String get manageSubscription => 'إدارة الاشتراك';

  @override
  String startPremium(String price) {
    return 'ابدأ المميز (من $price/شهر)';
  }

  @override
  String get restoreSuccess => 'تمت استعادة الشراء بنجاح';

  @override
  String get restoreFailed => 'فشل استعادة الشراء';

  @override
  String get noPurchaseToRestore => 'لا توجد مشتريات لاستعادتها';

  @override
  String get ratingDialogTitle => 'كيف تحب التطبيق؟';

  @override
  String get ratingDialogDescription => 'اضغط على النجوم لتقييم التطبيق.';

  @override
  String get rateApp => 'معدل';

  @override
  String get skipRating => 'ليس الآن';

  @override
  String aiTimeoutError(int seconds) {
    return 'انتهت مهلة معالجة الذكاء الاصطناعي ($seconds ثانية)';
  }

  @override
  String get aiNetworkError => 'فشل الاتصال بالشبكة';

  @override
  String get aiConfigurationError =>
      'خدمة الذكاء الاصطناعي غير مهيأة بشكل صحيح.';

  @override
  String get aiRateLimitError => 'تم الوصول للحد الأقصى لطلبات API';

  @override
  String get aiUnknownError => 'حدث خطأ غير متوقع';

  @override
  String get fcmNotification => 'إشعار FCM';

  @override
  String get screenshotHomeTitle => 'أوقات التخزين الفورية';

  @override
  String get screenshotHomeDescription =>
      'ابحث عن أي طعام، احصل على النتائج فوراً';

  @override
  String get screenshotExploreTitle => 'دليل الثلاجة والمجمد';

  @override
  String get screenshotExploreDescription =>
      'قارن خيارات التخزين جنباً إلى جنب';

  @override
  String get screenshotFavoritesTitle => 'متتبع انتهاء الصلاحية';

  @override
  String get screenshotFavoritesDescription => 'تتبع ما لديك ومتى ينتهي';

  @override
  String get screenshotProfileTitle => 'نصائح التخزين';

  @override
  String get screenshotProfileDescription => 'أفضل الممارسات لكل نوع من الطعام';

  @override
  String get screenshotSettingsTitle => 'الإعدادات';

  @override
  String get screenshotSettingsDescription => 'تخصيص تجربة تتبع الطعام';

  @override
  String get aiConsentScreen => 'بيانات الذكاء الاصطناعي والخصوصية';

  @override
  String get aiConsentContent =>
      'يستخدم هذا التطبيق Google Gemini AI (عبر Firebase) لتشغيل ميزات الذكاء الاصطناعي. بالمتابعة، فإنك توافق على مشاركة البيانات ذات الصلة مع خدمة Google AI.';

  @override
  String get aiConsentPrivacyLink => 'عرض سياسة الخصوصية';

  @override
  String get appName => 'MangaTrack';
}
