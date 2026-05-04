// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Chào mừng đến với $productName!';
  }

  @override
  String get descriptionMessage =>
      'Không bao giờ quên thuốc nhỏ mắt. Theo dõi việc sử dụng, quản lý ngày hết hạn sau khi mở và nhận nhắc nhở đúng lúc.';

  @override
  String get mainIntroductionScreen => 'Đôi mắt bạn xứng đáng được chăm sóc';

  @override
  String get mainIntroductionContent =>
      'Đặt nhắc nhở cho thuốc nhỏ mắt, theo dõi ngày hết hạn sau khi mở và quản lý nhiều lọ thuốc.';

  @override
  String get serviceBeginScreen => 'Bắt đầu hành trình của bạn';

  @override
  String get serviceBeginContent => 'Bắt đầu chăm sóc mắt của bạn!';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get close => 'Đóng';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get next => 'Tiếp theo';

  @override
  String get setting => 'Cài đặt';

  @override
  String get languageSetting => 'Cài đặt ngôn ngữ';

  @override
  String get themeSetting => 'Cài đặt chủ đề';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeSystem => 'Mặc định hệ thống';

  @override
  String get pushNotification => 'Thông báo đẩy';

  @override
  String get ratingSent => 'Đã gửi đánh giá';

  @override
  String get recommendApp => 'Ứng dụng đề xuất';

  @override
  String get contact => 'Liên hệ';

  @override
  String get legal => 'Pháp lý';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get license => 'Giấy phép';

  @override
  String get error => 'Đã xảy ra lỗi';

  @override
  String get networkError => 'Lỗi mạng';

  @override
  String review(Object productName) {
    return 'Đánh giá $productName';
  }

  @override
  String share(Object productName) {
    return 'Chia sẻ $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Chia sẻ $productName với mọi người! $appLink';
  }

  @override
  String get writeReview => 'Viết đánh giá';

  @override
  String get rate => 'Đánh giá';

  @override
  String get notRate => 'Bỏ qua đánh giá';

  @override
  String get unexpectedError => 'Đã xảy ra lỗi không mong đợi';

  @override
  String get planInformationFetchFailed => 'Không thể lấy thông tin gói.';

  @override
  String get subscriptionSettingTitle => 'Gói Premium';

  @override
  String get currentPlanPremium => 'Gói hiện tại: Premium';

  @override
  String get currentPlanFree => 'Gói hiện tại: Phiên bản miễn phí';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Không quảng cáo';

  @override
  String get selectPlan => 'Chọn gói';

  @override
  String get continueWithFreePlan => 'Tiếp tục với gói miễn phí';

  @override
  String get subscriptionCancellationNote =>
      'Bạn có thể hủy đăng ký bất kỳ lúc nào';

  @override
  String get purchaseCompleted => 'Hoàn tất mua hàng';

  @override
  String get revenueCatNotConfigured => 'RevenueCat chưa được cấu hình';

  @override
  String get revenueCatInvalidApiKey => 'Khóa API RevenueCat không hợp lệ';

  @override
  String get planInfoUnavailable => 'Thông tin gói không khả dụng';

  @override
  String get purchaseFailed => 'Mua hàng thất bại';

  @override
  String get limitedTimeOffer => 'Ưu đãi có thời hạn: ';

  @override
  String get homeTab => 'Trang chủ';

  @override
  String get exploreTab => 'Khám phá';

  @override
  String get settingsTab => 'Cài đặt';

  @override
  String get favoriteTab => 'Yêu thích';

  @override
  String get profileTab => 'Hồ sơ';

  @override
  String get updateAvailableTitle => 'Có bản cập nhật';

  @override
  String get updateAvailableContent =>
      'Đã có phiên bản mới của ứng dụng.\nVui lòng cập nhật để tiếp tục.';

  @override
  String get updateButton => 'Cập nhật';

  @override
  String get aiChat => 'Trò chuyện AI';

  @override
  String get premiumService => 'Dịch vụ Premium';

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
  String get annualPlan => 'Gói năm';

  @override
  String get monthlyPlan => 'Gói tháng';

  @override
  String get recommended => 'Đề xuất';

  @override
  String discountPercent(int percent) {
    return 'GIẢM $percent%';
  }

  @override
  String get trial => 'Dùng thử';

  @override
  String get perMonth => '/tháng';

  @override
  String get perYear => '/năm';

  @override
  String get restorePurchase => 'Khôi phục mua hàng';

  @override
  String get manageSubscription => 'Quản lý đăng ký';

  @override
  String startPremium(String price) {
    return 'Bắt đầu Premium (từ $price/tháng)';
  }

  @override
  String get restoreSuccess => 'Đã khôi phục mua hàng thành công';

  @override
  String get restoreFailed => 'Không thể khôi phục mua hàng';

  @override
  String get noPurchaseToRestore => 'Không có mua hàng để khôi phục';

  @override
  String get ratingDialogTitle => 'Bạn thích ứng dụng này như thế nào?';

  @override
  String get ratingDialogDescription =>
      'Nhấn vào các ngôi sao để đánh giá ứng dụng.';

  @override
  String get rateApp => 'Đánh giá';

  @override
  String get skipRating => 'Không phải bây giờ';

  @override
  String aiTimeoutError(int seconds) {
    return 'Xử lý AI đã hết thời gian ($seconds giây)';
  }

  @override
  String get aiNetworkError => 'Kết nối mạng thất bại';

  @override
  String get aiConfigurationError => 'Dịch vụ AI chưa được cấu hình đúng';

  @override
  String get aiRateLimitError => 'Đã đạt giới hạn yêu cầu API';

  @override
  String get aiUnknownError => 'Đã xảy ra lỗi không mong đợi';

  @override
  String get fcmNotification => 'Thông báo FCM';

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
  String get aiConsentScreen => 'Dữ liệu AI và quyền riêng tư';

  @override
  String get aiConsentContent =>
      'Ứng dụng này sử dụng Google Gemini AI (qua Firebase) cho các tính năng AI. Bằng cách tiếp tục, bạn đồng ý chia sẻ dữ liệu liên quan với dịch vụ AI của Google.';

  @override
  String get aiConsentPrivacyLink => 'Xem Chính sách Quyền riêng tư';

  @override
  String get appName => 'MangaTrack';
}
