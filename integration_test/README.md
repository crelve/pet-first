# スクリーンショット自動取得（Dartのみ）

このディレクトリには、App Store用のスクリーンショットを**完全にDartで**自動取得するためのintegration testが含まれています。

## 特徴

✅ **完全Dart実装**: SwiftやXCUITestの知識不要
✅ **39言語対応**: App Store Connect対応の全言語に自動対応
✅ **シンプル**: Flutter開発者にとって理解しやすいコード
✅ **高速**: 1言語あたり約15-30秒で撮影
✅ **カスタマイズ容易**: 画面遷移をDartで自由に制御

## ファイル構成

```
integration_test/
├── screenshot_test.dart                    # 基本的なスクリーンショットテスト（1言語）
└── screenshot_test_all_locales.dart        # 全39言語対応テスト（推奨）
```

## 使い方

### 全言語でスクリーンショット撮影

```bash
# プロジェクトルートで実行
flutter test integration_test/screenshot_test_all_locales.dart
```

または、Fastlane経由で:

```bash
cd ios
bundle exec fastlane take_screenshots
```

**生成される数:**
- 5画面 × 39言語 = **195枚**のスクリーンショット
- 保存先: `ios/fastlane/screenshots/en-US/`, `ios/fastlane/screenshots/ja/`, etc.

**所要時間:**
- 約10-30分（全39言語）
- 1言語のみなら約15-30秒

### 1言語のみテスト

```bash
flutter test integration_test/screenshot_test.dart
```

## カスタマイズ方法

### 1. 撮影する画面を追加・変更

`integration_test/screenshot_test_all_locales.dart`を編集:

```dart
// 06: 新しい画面を追加
if (tabCount > 5) {
  await tester.tap(find.byIcon(Icons.notifications_outlined).first);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await takeScreenshot('06-notifications');
}

// または、特定のボタンをタップして詳細画面へ遷移
final detailButton = find.byKey(const Key('detail_button'));
if (tester.any(detailButton)) {
  await tester.tap(detailButton);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await takeScreenshot('07-detail');
}
```

### 2. 対応言語を絞り込む（テスト用）

全言語の撮影は時間がかかるため、開発中は一部の言語のみでテストすることを推奨します:

```dart
// screenshot_test_all_locales.dart の locales リストを編集
final locales = [
  const Locale('en', 'US'), // English
  const Locale('ja'),       // Japanese
  // 他の言語をコメントアウト
];
```

### 3. 待機時間の調整

アプリの読み込みが遅い場合は待機時間を増やします:

```dart
await tester.pumpAndSettle(const Duration(seconds: 5)); // 2秒 → 5秒
```

### 4. スクロールやスワイプを追加

```dart
// 下にスクロール
await tester.drag(
  find.byType(ListView),
  const Offset(0, -300),
);
await tester.pumpAndSettle();
await takeScreenshot('08-scrolled');

// 横スワイプ
await tester.drag(
  find.byType(PageView),
  const Offset(-300, 0),
);
await tester.pumpAndSettle();
await takeScreenshot('09-next-page');
```

## Dartのみ vs Swift/XCUITest

### Dartアプローチの利点

✅ **学習コスト低**: Flutterエンジニアならすぐ理解できる
✅ **デバッグ容易**: Dartのデバッグツールを使用可能
✅ **柔軟性**: ウィジェットの状態を完全にコントロール
✅ **高速**: シミュレーター起動が1回のみ
✅ **保守性**: アプリコードと同じ言語

### Swift/XCUITestアプローチ（レガシー）

Fastlaneの`snapshot`ツールを使う従来の方法:

```bash
cd ios
bundle exec fastlane take_screenshots_xcui
```

**欠点:**
- Swiftの知識が必要
- XCUITestのセレクタが壊れやすい
- セットアップが複雑（SnapshotHelper.swift等）
- デバッグが困難

**Dartアプローチを推奨します。**

## トラブルシューティング

### エラー: "Could not find an option named 'device-id'"

`flutter test`コマンドでは`--device-id`オプションは不要です。削除してください。

```bash
# ❌ 間違い
flutter test --device-id="iPhone-16-Pro-Max" integration_test/screenshot_test_all_locales.dart

# ✅ 正しい
flutter test integration_test/screenshot_test_all_locales.dart
```

### スクリーンショットが真っ黒

**原因**: アプリの初期化が完了していない

**解決策**: 待機時間を増やす

```dart
await tester.pumpAndSettle(const Duration(seconds: 5));
```

### 特定のウィジェットが見つからない

**原因**: ウィジェットがまだレンダリングされていない、または異なる階層にある

**解決策**: `find`の条件を調整

```dart
// アイコンを直接指定する代わりに、Keyを使用
await tester.tap(find.byKey(const Key('settings_tab')));

// または、テキストで検索
await tester.tap(find.text('Settings'));

// 複数ある場合は.firstを使用
await tester.tap(find.byIcon(Icons.settings).first);
```

### メモリ不足エラー

**原因**: 39言語すべてを一度に処理するとメモリを消費

**解決策**: 言語を分割して実行

```dart
// 方法1: 言語リストを分割
final locales = [
  // グループ1: 主要言語
  const Locale('en', 'US'),
  const Locale('ja'),
  const Locale('zh', 'Hans'),
  // ... 10-15言語ずつ
];

// 方法2: 環境変数で制御
final languageGroup = Platform.environment['LANGUAGE_GROUP'] ?? 'all';
```

## GitHub Actionsでの自動実行

`.github/workflows/ios-deploy.yml`で自動実行されます:

```yaml
- name: Take screenshots (39 languages)
  run: |
    flutter test integration_test/screenshot_test_all_locales.dart
```

手動トリガー:
1. GitHub > Actions > "iOS Deploy"
2. "Run workflow" をクリック
3. "Take screenshots (39 languages)" にチェック
4. "Run workflow" を実行

## 次のステップ

1. **ローカルでテスト**: 1言語でテストして動作確認
   ```bash
   flutter test integration_test/screenshot_test.dart
   ```

2. **全言語で実行**: 本番用スクリーンショットを生成
   ```bash
   flutter test integration_test/screenshot_test_all_locales.dart
   ```

3. **フレームを追加**: App Store用にデバイスフレームを追加
   ```bash
   cd ios
   bundle exec fastlane screenshots_with_frames
   ```

4. **App Store Connectにアップロード**
   ```bash
   cd ios
   bundle exec fastlane upload_screenshots
   ```

## 参考リソース

- [Flutter integration_test](https://docs.flutter.dev/testing/integration-tests)
- [WidgetTester API](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html)
- [Finder API](https://api.flutter.dev/flutter/flutter_test/CommonFinders-class.html)
