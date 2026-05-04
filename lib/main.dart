// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'gen/colors.gen.dart';
import 'import/theme.dart';
import 'import/utility.dart';

/// アプリケーションのエントリポイント(アプリ起動時の処理)
Future<void> main() async {
  // スプラッシュ画面の表示
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // 各種サービスの初期化
    final prefs = await SharedPreferences.getInstance();

    // Firebaseの初期化（iOSネイティブが先にconfigure済みの場合はduplicate-appを無視）
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } on Object catch (e) {
      if (!e.toString().contains('duplicate-app')) rethrow;
    }

    // App Checkの初期化（Firestoreより前に実行する必要がある）
    await FirebaseAppCheck.instance.activate(
      providerApple: isNotProduction()
          ? const AppleDebugProvider()
          : const AppleDeviceCheckProvider(),
    );

    /// Firestoreの初期化
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // その他のサービスの初期化
    await Future.wait([
      MobileAds.instance.initialize(),
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    ]);

    // RevenueCatの初期化（APIキーが設定されている場合のみ）
    final revenueCatInitialized = await _initializeRevenueCat();

    // アプリの起動
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // flutter_foundation のAIサービスを注入
        aiServiceProvider.overrideWithValue(
          GeminiService(),
        ),
        // flutter_foundation の広告設定を注入
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
        // flutter_foundation のレビュー設定を注入
        ratingConfigProvider.overrideWithValue(
          const RatingConfig(
            storeReviewUrl: ExternalPageList.iosAppReviewLink,
          ),
        ),
        // flutter_foundation のアップデートチェック設定を注入
        updateConfigProvider.overrideWithValue(
          const UpdateConfig(
            minSupportedVersion: minSupportedVersion,
            storeAppUrl: ExternalPageList.iosAppLink,
          ),
        ),
        // RevenueCat初期化状態
        revenueCatInitializedProvider.overrideWithValue(revenueCatInitialized),
      ],
      observers: [ProviderLogger()],
    );

    // スプラッシュ画面を非表示
    FlutterNativeSplash.remove();

    runApp(UncontrolledProviderScope(container: container, child: const App()));
  } on Exception catch (e, stackTrace) {
    // 初期化エラーのハンドリング
    logger.e('Failed to initialize app', error: e, stackTrace: stackTrace);

    // エラー画面を表示
    FlutterNativeSplash.remove();
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: ColorName.red),
                hSpace(height: 16),
                ThemeText(
                  text: 'Failed to initialize app',
                  color: AppColors.light().text,
                  style: AppTextTheme(MediaType.pc).h30,
                ),
                hSpace(height: 8),
                ThemeText(
                  text: 'Error: $e',
                  color: AppColors.light().text,
                  style: AppTextTheme(MediaType.pc).h30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// RevenueCatの初期化
/// 初期化に成功した場合はtrueを返す
Future<bool> _initializeRevenueCat() async {
  // 現在はiOSのみ対応
  if (!Platform.isIOS) {
    logger.i('RevenueCat is currently only supported on iOS');
    return false;
  }

  const apiKey = Env.revenueCatAppleApiKey;

  if (apiKey.isEmpty) {
    logger.w('RevenueCat API key is not configured - skipping initialization');
    return false;
  }

  try {
    await Purchases.setLogLevel(LogLevel.info);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    logger.i('RevenueCat initialized successfully');
      // 匿名認証でFirebase UIDをRevenueCatに紐付け（デバイス間で購入履歴を同期）
      final credential = await FirebaseAuth.instance.signInAnonymously();
      if (credential.user != null) {
        await SubscriptionService.logIn(credential.user!.uid);
        logger.i(
          'RevenueCat linked with Firebase UID: ${credential.user!.uid}',
        );
      }
    return true;
  } on Exception catch (e) {
    logger.e('Failed to initialize RevenueCat', error: e);
    return false;
  }
}
