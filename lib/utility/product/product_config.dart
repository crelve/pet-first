/// 最小サポートバージョン
const minSupportedVersion = '1.0.0';

/// 外部ブラウザで表示するURLを管理するクラス
class ExternalPageList {
  /// iOSアプリID
  static const _iosAppId = '6742074009';

  /// iOSアプリのURL
  static const iosAppLink = 'https://apps.apple.com/jp/app/id$_iosAppId';

  /// iOSレビューアプリのURL
  static const iosAppReviewLink = '$iosAppLink?action=write-review';

  /// 利用規約のURL
  static const legal =
      'https://kikiki-flutter-template-prod.web.app/terms.html';

  /// プライバシーポリシーのURL
  static const privacyPolicy =
      'https://kikiki-flutter-template-prod.web.app/privacy.html';
}
