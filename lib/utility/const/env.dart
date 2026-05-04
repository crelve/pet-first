/// dartで利用する環境変数を管理するクラス
/// ※Dart-define-from-file引数で渡されるデータ(dart_envフォルダ配下のファイル)が元データ
class Env {
  Env._();

  /// フレーバー
  static const flavor = String.fromEnvironment('flavor');

  /// アプリID
  static const appId = String.fromEnvironment('appId');

  /// ユニバーサルリンク
  static const universalLinks = String.fromEnvironment('universalLinks');

  /// カスタムURLスキーム
  static const customUrlScheme = String.fromEnvironment('customUrlScheme');

  /// バナー広告ID(iOS)
  static const iOSBannerAdUnitId = String.fromEnvironment('iOSBannerAdUnitId');

  /// インタースティシャル広告ID(iOS)
  static const iOSInterstitialAdUnitId = String.fromEnvironment(
    'iOSInterstitialAdUnitId',
  );

  /// リワード広告ID(iOS)
  static const iOSRewardedAdUnitId = String.fromEnvironment(
    'iOSRewardedAdUnitId',
  );

  /// App Open広告ID(iOS)
  static const iOSAppOpenAdUnitId = String.fromEnvironment(
    'iOSAppOpenAdUnitId',
  );

  /// Native広告ID(iOS)
  static const iOSNativeAdUnitId = String.fromEnvironment(
    'iOSNativeAdUnitId',
  );

  // === 広告表示最適化設定 ===

  /// インタースティシャル広告の最小表示間隔（秒）
  /// デフォルト: 60秒
  static const adMinIntervalSeconds = int.fromEnvironment(
    'adMinIntervalSeconds',
    defaultValue: 60,
  );

  /// 1日あたりのインタースティシャル広告の最大表示回数
  /// デフォルト: 10回
  static const adDailyMaxInterstitialCount = int.fromEnvironment(
    'adDailyMaxInterstitialCount',
    defaultValue: 10,
  );

  /// 1日あたりのリワード広告の最大表示回数
  /// デフォルト: 20回（ユーザー任意視聴のため多め）
  static const adDailyMaxRewardedCount = int.fromEnvironment(
    'adDailyMaxRewardedCount',
    defaultValue: 20,
  );

  /// セッションあたりのインタースティシャル広告の最大表示回数
  /// デフォルト: 5回
  static const adSessionMaxInterstitialCount = int.fromEnvironment(
    'adSessionMaxInterstitialCount',
    defaultValue: 5,
  );

  /// RevenueCat APIキー(Apple)
  static const revenueCatAppleApiKey = String.fromEnvironment(
    'revenueCatAppleApiKey',
  );

  /// 買い切り（Lifetime）Product ID
  /// App Store Connect で作成した Non-Consumable の Product ID
  /// dart_env の lifetimeProductId に設定した値が入る
  /// 空文字の場合、RevenueCat の Offering から自動取得される（flutter_foundation の仕様）
  static const lifetimeProductId = String.fromEnvironment(
    'lifetimeProductId',
  );
}
