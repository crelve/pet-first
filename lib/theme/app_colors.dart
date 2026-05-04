import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';

import '../import/gen.dart';

/// アプリで利用する色情報を管理するクラス
class AppColors {
  /// アプリで利用する色情報を管理するクラス
  const AppColors({
    required this.main,
    required this.primary,
    required this.background,
    required this.headerBackground,
    required this.white,
    required this.black,
    required this.grey,
    required this.red,
    required this.yellow,
    required this.orange,
    required this.green,
    required this.blue,
    required this.blueGray,
    required this.purple,
    required this.activeDotColor,
    required this.loading,
    required this.progress,
    required this.error,
    required this.accent,
    required this.secondary,
    required this.success,
    required this.subscriptionPrimary,
    required this.subscriptionAccent,
    required this.subscriptionBadge,
    required this.subscriptionGradientStart,
    required this.subscriptionGradientMiddle,
    required this.subscriptionGradientEnd,
    required this.subscriptionText,
  });

  /// ライトテーマ用の色情報を管理インスタンスを作成します
  factory AppColors.light() {
    return const AppColors(
      main: ColorName.main,
      primary: ColorName.primary,
      background: ColorName.backGround,
      headerBackground: ColorName.headerBackground,
      white: ColorName.white,
      black: ColorName.black,
      grey: ColorName.grey,
      red: ColorName.red,
      yellow: ColorName.yellow,
      orange: ColorName.orange,
      green: ColorName.green,
      blue: ColorName.blue,
      blueGray: ColorName.blueGrey,
      purple: ColorName.purple,
      activeDotColor: ColorName.white38,
      loading: ColorName.white,
      progress: ColorName.progress,
      error: ColorName.error,
      accent: ColorName.accent,
      secondary: ColorName.secondary,
      success: ColorName.success,
      subscriptionPrimary: ColorName.subscriptionPrimary,
      subscriptionAccent: ColorName.subscriptionAccent,
      subscriptionBadge: ColorName.subscriptionBadge,
      subscriptionGradientStart: ColorName.subscriptionGradientStart,
      subscriptionGradientMiddle: ColorName.subscriptionGradientMiddle,
      subscriptionGradientEnd: ColorName.subscriptionGradientEnd,
      subscriptionText: ColorName.subscriptionText,
    );
  }

  /// ダークテーマ用の色情報を管理インスタンスを作成します
  factory AppColors.dark() {
    return const AppColors(
      main: ColorName.main,
      primary: ColorName.primary,
      background: ColorName.backGround,
      headerBackground: ColorName.headerBackground,
      white: ColorName.white,
      black: ColorName.black,
      grey: ColorName.grey,
      red: ColorName.red,
      yellow: ColorName.yellow,
      orange: ColorName.orange,
      green: ColorName.green,
      blue: ColorName.blue,
      blueGray: ColorName.blueGrey,
      purple: ColorName.purple,
      activeDotColor: ColorName.white38,
      loading: ColorName.white,
      progress: ColorName.progress,
      error: ColorName.error,
      accent: ColorName.accent,
      secondary: ColorName.secondary,
      success: ColorName.success,
      subscriptionPrimary: ColorName.subscriptionPrimary,
      subscriptionAccent: ColorName.subscriptionAccent,
      subscriptionBadge: ColorName.subscriptionBadge,
      subscriptionGradientStart: ColorName.subscriptionGradientStart,
      subscriptionGradientMiddle: ColorName.subscriptionGradientMiddle,
      subscriptionGradientEnd: ColorName.subscriptionGradientEnd,
      subscriptionText: ColorName.subscriptionText,
    );
  }

  /// メインカラー
  final Color main;

  /// プライマリーカラー
  final Color primary;

  /// 背景カラー
  final Color background;

  /// ヘッダー背景カラー
  final Color headerBackground;

  /// 白
  final Color white;

  /// 黒
  final Color black;

  /// グレー
  final Color grey;

  /// 赤
  final Color red;

  /// 黄色
  final Color yellow;

  /// 橙
  final Color orange;

  /// 緑
  final Color green;

  /// 青
  final Color blue;

  /// 青グレー
  final Color blueGray;

  /// 紫
  final Color purple;

  /// アクティブドットカラー
  final Color activeDotColor;

  /// ローディングカラー
  final Color loading;

  /// プログレスカラー
  final Color progress;

  /// エラーカラー
  final Color error;

  /// アクセントカラー
  final Color accent;

  /// セカンダリカラー
  final Color secondary;

  /// 成功カラー
  final Color success;

  /// サブスクリプション画面のプライマリカラー
  final Color subscriptionPrimary;

  /// サブスクリプション画面のアクセントカラー
  final Color subscriptionAccent;

  /// サブスクリプション画面のバッジカラー
  final Color subscriptionBadge;

  /// サブスクリプション画面のグラデーション開始色
  final Color subscriptionGradientStart;

  /// サブスクリプション画面のグラデーション中間色
  final Color subscriptionGradientMiddle;

  /// サブスクリプション画面のグラデーション終了色
  final Color subscriptionGradientEnd;

  /// サブスクリプション画面のテキストカラー
  final Color subscriptionText;

  /// 表面カラー
  Color get surface => white;

  /// 表面変形カラー
  Color get surfaceVariant => grey;

  /// アウトラインカラー
  Color get outline => grey;

  /// プライマリーコンテナカラー
  Color get primaryContainer => ColorUtility.withOpacity(primary, 0.1);

  /// テキストカラー
  Color get text => black;

  /// セカンダリテキストカラー
  Color get textSecondary => grey;

  /// 警告カラー
  Color get warning => orange;

  /// 情報カラー
  Color get info => blue;
}
