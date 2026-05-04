// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'ยินดีต้อนรับสู่ $productName!';
  }

  @override
  String get descriptionMessage =>
      'ไม่ลืมยาหยอดตาอีกต่อไป ติดตามการใช้งาน จัดการวันหมดอายุหลังเปิด และรับการแจ้งเตือนในเวลาที่เหมาะสม';

  @override
  String get mainIntroductionScreen => 'ดวงตาของคุณสมควรได้รับการดูแล';

  @override
  String get mainIntroductionContent =>
      'ตั้งการแจ้งเตือนสำหรับยาหยอดตา ติดตามวันหมดอายุหลังเปิดใช้งาน และจัดการหลายขวด';

  @override
  String get serviceBeginScreen => 'เริ่มต้นการเดินทางของคุณ';

  @override
  String get serviceBeginContent => 'เริ่มดูแลดวงตาของคุณ!';

  @override
  String get signUp => 'ลงทะเบียน';

  @override
  String get close => 'ปิด';

  @override
  String get skip => 'ข้าม';

  @override
  String get next => 'ถัดไป';

  @override
  String get setting => 'การตั้งค่า';

  @override
  String get languageSetting => 'การตั้งค่าภาษา';

  @override
  String get themeSetting => 'การตั้งค่าธีม';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeSystem => 'ค่าเริ่มต้นของระบบ';

  @override
  String get pushNotification => 'การแจ้งเตือนแบบพุช';

  @override
  String get ratingSent => 'ส่งคะแนนแล้ว';

  @override
  String get recommendApp => 'แอปแนะนำ';

  @override
  String get contact => 'ติดต่อเรา';

  @override
  String get legal => 'ทางกฎหมาย';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get license => 'ใบอนุญาต';

  @override
  String get error => 'เกิดข้อผิดพลาด';

  @override
  String get networkError => 'ข้อผิดพลาดของเครือข่าย';

  @override
  String review(Object productName) {
    return 'รีวิว $productName';
  }

  @override
  String share(Object productName) {
    return 'แชร์ $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'แชร์ $productName กับทุกคน! $appLink';
  }

  @override
  String get writeReview => 'เขียนรีวิว';

  @override
  String get rate => 'ให้คะแนน';

  @override
  String get notRate => 'ข้ามการให้คะแนน';

  @override
  String get unexpectedError => 'เกิดข้อผิดพลาดที่ไม่คาดคิด';

  @override
  String get planInformationFetchFailed => 'ไม่สามารถดึงข้อมูลแผนได้';

  @override
  String get subscriptionSettingTitle => 'แผน Premium';

  @override
  String get currentPlanPremium => 'แผนปัจจุบัน: Premium';

  @override
  String get currentPlanFree => 'แผนปัจจุบัน: เวอร์ชันฟรี';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'ไม่มีโฆษณา';

  @override
  String get selectPlan => 'เลือกแผน';

  @override
  String get continueWithFreePlan => 'ดำเนินการต่อด้วยแผนฟรี';

  @override
  String get subscriptionCancellationNote =>
      'คุณสามารถยกเลิกการสมัครสมาชิกได้ทุกเมื่อ';

  @override
  String get purchaseCompleted => 'การซื้อเสร็จสมบูรณ์';

  @override
  String get revenueCatNotConfigured => 'RevenueCat ยังไม่ได้รับการตั้งค่า';

  @override
  String get revenueCatInvalidApiKey => 'คีย์ API RevenueCat ไม่ถูกต้อง';

  @override
  String get planInfoUnavailable => 'ข้อมูลแผนไม่พร้อมใช้งาน';

  @override
  String get purchaseFailed => 'การซื้อล้มเหลว';

  @override
  String get limitedTimeOffer => 'ข้อเสนอจำกัดเวลา: ';

  @override
  String get homeTab => 'หน้าแรก';

  @override
  String get exploreTab => 'สำรวจ';

  @override
  String get settingsTab => 'การตั้งค่า';

  @override
  String get favoriteTab => 'รายการโปรด';

  @override
  String get profileTab => 'โปรไฟล์';

  @override
  String get updateAvailableTitle => 'มีอัปเดตใหม่';

  @override
  String get updateAvailableContent =>
      'มีเวอร์ชันใหม่ของแอป\nโปรดอัปเดตเพื่อใช้งานต่อ';

  @override
  String get updateButton => 'อัปเดต';

  @override
  String get aiChat => 'แชท AI';

  @override
  String get premiumService => 'บริการพรีเมียม';

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
  String get annualPlan => 'แผนรายปี';

  @override
  String get monthlyPlan => 'แผนรายเดือน';

  @override
  String get recommended => 'แนะนำ';

  @override
  String discountPercent(int percent) {
    return 'ส่วนลด $percent%';
  }

  @override
  String get trial => 'ทดลองใช้';

  @override
  String get perMonth => '/เดือน';

  @override
  String get perYear => '/ปี';

  @override
  String get restorePurchase => 'กู้คืนการซื้อ';

  @override
  String get manageSubscription => 'จัดการการสมัครสมาชิก';

  @override
  String startPremium(String price) {
    return 'เริ่มต้น Premium (เริ่มต้น $price/เดือน)';
  }

  @override
  String get restoreSuccess => 'การซื้อถูกกู้คืนสำเร็จ';

  @override
  String get restoreFailed => 'ไม่สามารถกู้คืนการซื้อได้';

  @override
  String get noPurchaseToRestore => 'ไม่มีการซื้อที่จะกู้คืน';

  @override
  String get ratingDialogTitle => 'คุณชอบแอปนี้หรือไม่?';

  @override
  String get ratingDialogDescription => 'แตะดาวเพื่อให้คะแนนแอป';

  @override
  String get rateApp => 'ให้คะแนน';

  @override
  String get skipRating => 'ไว้ทีหลัง';

  @override
  String aiTimeoutError(int seconds) {
    return 'การประมวลผล AI หมดเวลา ($seconds วินาที)';
  }

  @override
  String get aiNetworkError => 'การเชื่อมต่อเครือข่ายล้มเหลว';

  @override
  String get aiConfigurationError =>
      'บริการ AI ไม่ได้รับการตั้งค่าอย่างถูกต้อง';

  @override
  String get aiRateLimitError => 'ถึงขีดจำกัดคำขอ API แล้ว';

  @override
  String get aiUnknownError => 'เกิดข้อผิดพลาดที่ไม่คาดคิด';

  @override
  String get fcmNotification => 'การแจ้งเตือน FCM';

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
  String get aiConsentScreen => 'ข้อมูล AI และความเป็นส่วนตัว';

  @override
  String get aiConsentContent =>
      'แอปนี้ใช้ Google Gemini AI (ผ่าน Firebase) เพื่อขับเคลื่อนฟีเจอร์ AI โดยการดำเนินการต่อ แสดงว่าคุณยินยอมให้แบ่งปันข้อมูลที่เกี่ยวข้องกับบริการ AI ของ Google';

  @override
  String get aiConsentPrivacyLink => 'ดูนโยบายความเป็นส่วนตัว';

  @override
  String get appName => 'MangaTrack';
}
