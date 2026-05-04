// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get productName => 'Bird Log';

  @override
  String welcomeMessage(Object productName) {
    return 'Добро пожаловать в $productName!';
  }

  @override
  String get descriptionMessage =>
      'Никогда не забывайте о глазных каплях. Отслеживайте использование, управляйте сроками годности и получайте напоминания.';

  @override
  String get mainIntroductionScreen => 'Ваши глаза заслуживают ухода';

  @override
  String get mainIntroductionContent =>
      'Установите напоминания для глазных капель, отслеживайте сроки годности после вскрытия и управляйте несколькими флаконами.';

  @override
  String get serviceBeginScreen => 'Начните свое путешествие';

  @override
  String get serviceBeginContent => 'Начните заботиться о глазах!';

  @override
  String get signUp => 'Регистрация';

  @override
  String get close => 'Закрыть';

  @override
  String get skip => 'Пропустить';

  @override
  String get next => 'Далее';

  @override
  String get setting => 'Настройка';

  @override
  String get languageSetting => 'Настройки языка';

  @override
  String get themeSetting => 'Настройки темы';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get pushNotification => 'Push-уведомления';

  @override
  String get ratingSent => 'Оценка отправлена';

  @override
  String get recommendApp => 'Рекомендуемые приложения';

  @override
  String get contact => 'Связаться с нами';

  @override
  String get legal => 'Юридическое';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get license => 'Лицензии';

  @override
  String get error => 'Произошла ошибка';

  @override
  String get networkError => 'Ошибка сети';

  @override
  String review(Object productName) {
    return 'Отзыв $productName';
  }

  @override
  String share(Object productName) {
    return 'Поделиться $productName';
  }

  @override
  String shareMessage(Object appLink, Object productName) {
    return 'Поделитесь $productName со всеми! $appLink';
  }

  @override
  String get writeReview => 'Написать отзыв';

  @override
  String get rate => 'Оценить';

  @override
  String get notRate => 'Пропустить оценку';

  @override
  String get unexpectedError => 'Произошла непредвиденная ошибка';

  @override
  String get planInformationFetchFailed =>
      'Не удалось получить информацию о плане.';

  @override
  String get subscriptionSettingTitle => 'Премиум-план';

  @override
  String get currentPlanPremium => 'Текущий план: Premium';

  @override
  String get currentPlanFree => 'Текущий план: Бесплатная версия';

  @override
  String get premiumPlanBenefits => 'Keep Fresh Premium';

  @override
  String get adFree => 'Без рекламы';

  @override
  String get selectPlan => 'Выбрать план';

  @override
  String get continueWithFreePlan => 'Продолжить с бесплатным планом';

  @override
  String get subscriptionCancellationNote =>
      'Вы можете отменить подписку в любое время';

  @override
  String get purchaseCompleted => 'Покупка завершена';

  @override
  String get revenueCatNotConfigured => 'RevenueCat не настроен';

  @override
  String get revenueCatInvalidApiKey => 'Недействительный API-ключ RevenueCat';

  @override
  String get planInfoUnavailable => 'Информация о плане недоступна';

  @override
  String get purchaseFailed => 'Покупка не удалась';

  @override
  String get limitedTimeOffer => 'Предложение ограничено по времени: ';

  @override
  String get homeTab => 'Главная';

  @override
  String get exploreTab => 'Исследовать';

  @override
  String get settingsTab => 'Настройки';

  @override
  String get favoriteTab => 'Избранное';

  @override
  String get profileTab => 'Профиль';

  @override
  String get updateAvailableTitle => 'Доступно обновление';

  @override
  String get updateAvailableContent =>
      'Доступна новая версия приложения.\nПожалуйста, обновите для продолжения.';

  @override
  String get updateButton => 'Обновить';

  @override
  String get aiChat => 'AI чат';

  @override
  String get premiumService => 'Премиум-сервис';

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
  String get annualPlan => 'Годовой план';

  @override
  String get monthlyPlan => 'Месячный план';

  @override
  String get recommended => 'Рекомендуется';

  @override
  String discountPercent(int percent) {
    return '$percent% СКИДКА';
  }

  @override
  String get trial => 'Пробный';

  @override
  String get perMonth => '/мес';

  @override
  String get perYear => '/год';

  @override
  String get restorePurchase => 'Восстановить покупку';

  @override
  String get manageSubscription => 'Управление подпиской';

  @override
  String startPremium(String price) {
    return 'Начать Premium (от $price/мес)';
  }

  @override
  String get restoreSuccess => 'Покупка успешно восстановлена';

  @override
  String get restoreFailed => 'Не удалось восстановить покупку';

  @override
  String get noPurchaseToRestore => 'Нет покупок для восстановления';

  @override
  String get ratingDialogTitle => 'Как вам приложение?';

  @override
  String get ratingDialogDescription =>
      'Нажмите на звезды, чтобы оценить приложение.';

  @override
  String get rateApp => 'Оценить';

  @override
  String get skipRating => 'Не сейчас';

  @override
  String aiTimeoutError(int seconds) {
    return 'Время обработки AI истекло ($seconds секунд)';
  }

  @override
  String get aiNetworkError => 'Сбой сетевого подключения';

  @override
  String get aiConfigurationError => 'Сервис AI настроен неправильно';

  @override
  String get aiRateLimitError => 'Достигнут лимит запросов API';

  @override
  String get aiUnknownError => 'Произошла непредвиденная ошибка';

  @override
  String get fcmNotification => 'FCM уведомление';

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
  String get aiConsentScreen => 'Данные ИИ и конфиденциальность';

  @override
  String get aiConsentContent =>
      'Это приложение использует Google Gemini AI (через Firebase) для функций ИИ. Продолжая, вы соглашаетесь на передачу соответствующих данных сервису ИИ Google.';

  @override
  String get aiConsentPrivacyLink => 'Просмотреть политику конфиденциальности';

  @override
  String get appName => 'MangaTrack';
}
