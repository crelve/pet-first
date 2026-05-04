// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_first/firebase_options.dart';
import 'package:pet_first/import/screen.dart';
import 'package:pet_first/import/utility.dart';
import 'package:pet_first/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化（テスト実行前に1回だけ）
  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  });

  // スクリーンショット保存用のディレクトリを取得
  String getScreenshotDir() {
    // 言語コードを環境変数から取得（Fastlaneから渡される）
    final locale = Platform.environment['FASTLANE_SNAPSHOT_LOCALE'] ?? 'en-US';

    // ios/fastlane/screenshots/en-US/ のような構造で保存
    final screenshotsDir = path.join(
      Directory.current.path,
      'ios',
      'fastlane',
      'screenshots',
      locale,
    );

    Directory(screenshotsDir).createSync(recursive: true);
    return screenshotsDir;
  }

  // スクリーンショットを撮影するヘルパー関数
  Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    final screenshotDir = getScreenshotDir();
    final screenshotPath = path.join(screenshotDir, '$name.png');

    // integration_testのスクリーンショット機能を使用
    await binding.takeScreenshot(name);

    logger.d('📸 Screenshot saved: $screenshotPath');
  }

  group('App Screenshots', () {
    testWidgets('Take screenshots of all main screens', (
      WidgetTester tester,
    ) async {
      // SharedPreferencesの初期化
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // アプリを起動（正しい方法）
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            aiServiceProvider.overrideWithValue(GeminiService()),
            adConfigProvider.overrideWithValue(
              AdConfig(
                bannerAdUnitId: Env.iOSBannerAdUnitId,
                interstitialAdUnitId: Env.iOSInterstitialAdUnitId,
                rewardedAdUnitId: Env.iOSRewardedAdUnitId,
                appOpenAdUnitId: Env.iOSAppOpenAdUnitId,
                nativeAdUnitId: Env.iOSNativeAdUnitId,
                minIntervalSeconds: Env.adMinIntervalSeconds,
                dailyMaxInterstitialCount: Env.adDailyMaxInterstitialCount,
                dailyMaxRewardedCount: Env.adDailyMaxRewardedCount,
                sessionMaxInterstitialCount: Env.adSessionMaxInterstitialCount,
                isProduction: !isNotProduction(),
              ),
            ),
            ratingConfigProvider.overrideWithValue(
              const RatingConfig(
                storeReviewUrl: ExternalPageList.iosAppReviewLink,
              ),
            ),
            updateConfigProvider.overrideWithValue(
              const UpdateConfig(
                minSupportedVersion: minSupportedVersion,
                storeAppUrl: ExternalPageList.iosAppLink,
              ),
            ),
            revenueCatInitializedProvider.overrideWithValue(false),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false, // スクリーンショット用にDebugバナーを非表示
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Builder(
              builder: (context) => const BaseScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      logger
        ..d('🚀 Starting screenshot capture...')
        // 01: ホーム画面（デフォルトタブ）
        ..d('📱 Capturing screen 01: Home');
      await takeScreenshot(tester, '01-home');

      // タブバーを見つける
      final tabBar = find.byType(BottomNavigationBar);

      if (tester.any(tabBar)) {
        final bottomNavBar = tester.widget<BottomNavigationBar>(tabBar);
        final tabCount = bottomNavBar.items.length;

        logger.d('📊 Found $tabCount tabs');

        // 02: 2番目のタブ（Explore）
        if (tabCount > 1) {
          logger.d('📱 Capturing screen 02: Explore');
          await tester.tap(find.byIcon(Icons.explore_outlined).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await takeScreenshot(tester, '02-explore');
        }

        // 03: 3番目のタブ（Favorites）
        if (tabCount > 2) {
          logger.d('📱 Capturing screen 03: Favorites');
          await tester.tap(find.byIcon(Icons.favorite_outline).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await takeScreenshot(tester, '03-favorites');
        }

        // 04: 4番目のタブ（Profile）
        if (tabCount > 3) {
          logger.d('📱 Capturing screen 04: Profile');
          await tester.tap(find.byIcon(Icons.person_outline).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await takeScreenshot(tester, '04-profile');
        }

        // 05: 5番目のタブ（Settings）
        if (tabCount > 4) {
          logger.d('📱 Capturing screen 05: Settings');
          await tester.tap(find.byIcon(Icons.settings_outlined).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await takeScreenshot(tester, '05-settings');
        }
      }

      logger.d('✅ Screenshot capture completed!');
    });
  });
}
