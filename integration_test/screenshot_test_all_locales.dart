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
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // スクリーンショット保存ディレクトリの絶対パス
  late final String screenshotsBasePath;

  // Firebase初期化とディレクトリ作成（テスト実行前に1回だけ）
  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // プロジェクトルートの絶対パスを取得
    final currentPath = Directory.current.path;
    // ignore: avoid_print
    print('🔍 Current directory: $currentPath');

    // テスト実行時のカレントディレクトリがプロジェクトルートであることを前提
    // パスが空または"/"の場合は、明示的なパスを使用
    final String projectRoot;
    if (currentPath.isEmpty || currentPath == '/') {
      // 環境変数から取得を試みる
      projectRoot = Platform.environment['PWD'] ??
          '/Users/tomohitokii/kikiki/new/flutter-template';
      // ignore: avoid_print
      print('⚠️  Using fallback project root: $projectRoot');
    } else {
      projectRoot = currentPath;
    }

    screenshotsBasePath = '$projectRoot/screenshots';
    // ignore: avoid_print
    print('📁 Screenshots will be saved to: $screenshotsBasePath');

    // スクリーンショット保存ディレクトリを作成
    final screenshotsDir = Directory(screenshotsBasePath);
    if (screenshotsDir.existsSync()) {
      screenshotsDir.deleteSync(recursive: true);
    }
    screenshotsDir.createSync(recursive: true);
  });

  // App Store Connect対応39言語
  final locales = [
    const Locale('en', 'US'), // English (US)
    const Locale('ja'), // Japanese
    const Locale('zh', 'Hans'), // Chinese Simplified
    const Locale('ko'), // Korean
    const Locale('de', 'DE'), // German
    const Locale('fr', 'FR'), // French
    const Locale('pt', 'BR'), // Portuguese (Brazil)
    const Locale('es', 'ES'), // Spanish
    const Locale('hi'), // Hindi
    const Locale('it'), // Italian
    const Locale('ar', 'SA'), // App Store Connect requires 'ar-SA' not 'ar' // Arabic
    const Locale('ca'), // Catalan
    const Locale('zh', 'Hant'), // Chinese Traditional
    const Locale('hr'), // Croatian
    const Locale('cs'), // Czech
    const Locale('da'), // Danish
    const Locale('nl', 'NL'), // Dutch
    const Locale('en', 'AU'), // English (Australia)
    const Locale('en', 'CA'), // English (Canada)
    const Locale('en', 'GB'), // English (UK)
    const Locale('fi'), // Finnish
    const Locale('fr', 'CA'), // French Canadian
    const Locale('el'), // Greek
    const Locale('he'), // Hebrew
    const Locale('hu'), // Hungarian
    const Locale('id'), // Indonesian
    const Locale('ms'), // Malay
    const Locale('no'), // Norwegian
    const Locale('pl'), // Polish
    const Locale('pt', 'PT'), // Portuguese Portugal
    const Locale('ro'), // Romanian
    const Locale('ru'), // Russian
    const Locale('sk'), // Slovak
    const Locale('es', 'MX'), // Spanish Mexican
    const Locale('sv'), // Swedish
    const Locale('th'), // Thai
    const Locale('tr'), // Turkish
    const Locale('uk'), // Ukrainian
    const Locale('vi'), // Vietnamese
  ];

  group('Screenshot capture for all locales', () {
    for (final locale in locales) {
      testWidgets(
        'Capture screenshots for $locale',
        (WidgetTester tester) async {
          // ロケール用のディレクトリを作成
          final localeName = locale.countryCode != null
              ? '${locale.languageCode}-${locale.countryCode}'
              : locale.languageCode;
          final localeDir = Directory('$screenshotsBasePath/$localeName');
          if (!localeDir.existsSync()) {
            localeDir.createSync(recursive: true);
          }

          // ignore: avoid_print
          print('📸 Capturing screenshots for $localeName');

          // SharedPreferencesの初期化
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();

          // テスト用のアプリを起動（特定のロケールで）
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
                    sessionMaxInterstitialCount:
                        Env.adSessionMaxInterstitialCount,
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
                locale: locale,
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

          // スクリーンショット撮影ヘルパー
          Future<void> takeScreenshot(String name) async {
            await binding.convertFlutterSurfaceToImage();
            await tester.pumpAndSettle();

            final screenshot = await binding.takeScreenshot(name);
            final file = File('$screenshotsBasePath/$localeName/$name.png');
            await file.writeAsBytes(screenshot);

            // ignore: avoid_print
            print('  ✅ $localeName/$name.png');
          }

          // 01: ホーム画面
          await takeScreenshot('01-home');

          // タブバーを見つける
          final tabBar = find.byType(BottomNavigationBar);

          if (tester.any(tabBar)) {
            final bottomNavBar = tester.widget<BottomNavigationBar>(tabBar);
            final tabCount = bottomNavBar.items.length;

            // 02: 2番目のタブ（Explore）
            if (tabCount > 1) {
              await tester.tap(find.byIcon(Icons.explore_outlined).first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              await takeScreenshot('02-explore');
            }

            // 03: 3番目のタブ（Favorites）
            if (tabCount > 2) {
              await tester.tap(find.byIcon(Icons.favorite_outline).first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              await takeScreenshot('03-favorites');
            }

            // 04: 4番目のタブ（Profile）
            if (tabCount > 3) {
              await tester.tap(find.byIcon(Icons.person_outline).first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              await takeScreenshot('04-profile');
            }

            // 05: 5番目のタブ（Settings）
            if (tabCount > 4) {
              await tester.tap(find.byIcon(Icons.settings_outlined).first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              await takeScreenshot('05-settings');
            }
          }

          // ignore: avoid_print
          print('✅ Completed: $localeName');
        },
        timeout: const Timeout(Duration(minutes: 60)),
      );
    }
  });
}
