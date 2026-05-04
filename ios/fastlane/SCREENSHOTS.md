# Fastlane スクリーンショット自動化ガイド

App Store Connect用のスクリーンショットを自動で取得・カスタマイズするためのFastlane設定です。

## 📸 機能概要

### 自動スクリーンショット取得
- ✅ **39言語対応**: App Store Connectで対応している全言語に自動対応
- ✅ **最適なデバイスサイズ**: iPhone 16 Pro Max (最新) + iPhone 15 Pro Max (App Store要件対応)
- ✅ **ステータスバー最適化**: 9:41固定、バッテリー満タン表示
- ✅ **複数画面対応**: integration testで定義した全画面を自動撮影

### デバイスフレーム & テキストオーバーレイ
- ✅ **多言語テキスト**: 各言語に対応したキーワード・説明文を自動追加
- ✅ **カスタマイズ可能**: 背景色、フォントサイズ、パディングを調整可能
- ✅ **App Store品質**: プロフェッショナルな見た目のスクリーンショットを生成

## 🚀 使い方

### 基本的な使い方

```bash
# 1. スクリーンショット自動取得（39言語 × 2デバイス = 78セット）
cd ios
fastlane take_screenshots

# 2. デバイスフレーム＋テキスト付きスクリーンショット作成
fastlane screenshots_with_frames

# 3. App Store Connectにアップロード
fastlane upload_screenshots
```

### ステップバイステップガイド

#### ステップ1: integration testをカスタマイズ

`integration_test/screenshot_test.dart` を編集して、アプリの主要画面を追加します。

```dart
// 例: ホーム画面
await binding.takeScreenshot('01-home');

// 例: 設定画面
await tester.tap(find.byKey(Key('settings_button')));
await tester.pumpAndSettle();
await binding.takeScreenshot('02-settings');

// 例: 詳細画面
await tester.tap(find.byKey(Key('detail_button')));
await tester.pumpAndSettle();
await binding.takeScreenshot('03-detail');
```

#### ステップ2: Framefile.jsonに画面を追加

各スクリーンショットに対応するキーワード・タイトルを39言語分追加します。

```json
{
  "filter": "03-detail",
  "keyword": {
    "en-US": "Detail View",
    "ja": "詳細画面",
    "zh-Hans": "详细视图",
    // ... 他の36言語
  },
  "title": {
    "en-US": "View all the details you need",
    "ja": "必要な詳細情報を全て表示",
    "zh-Hans": "查看您需要的所有详细信息",
    // ... 他の36言語
  }
}
```

#### ステップ3: スクリーンショット取得を実行

```bash
cd ios
fastlane take_screenshots
```

これにより、以下のスクリーンショットが生成されます：
- **39言語** × **2デバイス** × **画面数** = 大量のスクリーンショット
- 保存先: `ios/fastlane/screenshots/`

## 📱 対応デバイス

App Store Connect要件に準拠した最適なデバイス構成：

| デバイス | 画面サイズ | 解像度 | App Store要件 |
|---------|----------|-------|--------------|
| iPhone 16 Pro Max | 6.9インチ | 2868 × 1320px | ✅ 最新デバイス |
| iPhone 15 Pro Max | 6.7インチ | 1290 × 2796px | ✅ 1284×2778に対応 |

App Store Connectでは、最大ディスプレイサイズ（6.7インチ以上）のスクリーンショットを提出すれば、それが小さいデバイスにも自動適用されます。

## 🌍 対応言語（39言語）

App Store Connectで対応している全言語に対応：

### 主要言語
- 🇺🇸 English (US) - `en-US`
- 🇯🇵 Japanese (日本語) - `ja`
- 🇨🇳 Chinese Simplified (简体中文) - `zh-Hans`
- 🇰🇷 Korean (한국어) - `ko`
- 🇩🇪 German (Deutsch) - `de-DE`
- 🇫🇷 French (Français) - `fr-FR`
- 🇧🇷 Portuguese (Português - Brasil) - `pt-BR`
- 🇪🇸 Spanish (Español) - `es-ES`
- 🇮🇳 Hindi (हिन्दी) - `hi`
- 🇮🇹 Italian (Italiano) - `it`

### その他の言語（29言語）
Arabic, Catalan, Chinese Traditional, Croatian, Czech, Danish, Dutch, English (AU/CA/GB), Finnish, French Canadian, Greek, Hebrew, Hungarian, Indonesian, Malay, Norwegian, Polish, Portuguese (Portugal), Romanian, Russian, Slovak, Spanish (Mexican), Swedish, Thai, Turkish, Ukrainian, Vietnamese

完全なリストは `Snapshotfile` を参照してください。

## 🎨 カスタマイズ

### 背景色の変更

`Framefile.json` の `background` を編集：

```json
{
  "default": {
    "background": "#1A1A2E"  // ダークブルー（デフォルト）
    // または
    // "background": "#FFFFFF"  // ホワイト
    // "background": "./background.png"  // 背景画像
  }
}
```

### テキストサイズ・色の変更

```json
{
  "default": {
    "keyword": {
      "font_scale_factor": 0.15,  // キーワードのサイズ
      "color": "#FFFFFF"          // 白色
    },
    "title": {
      "font_scale_factor": 0.10,  // タイトルのサイズ
      "color": "#FFFFFF",
      "padding": 30               // 上下のパディング
    }
  }
}
```

### カスタムフォントの使用（オプション）

1. フォントファイルを配置:
   ```bash
   mkdir -p fonts
   # フォントファイル（.ttf または .otf）を配置
   ```

2. `Framefile.json` を編集:
   ```json
   {
     "default": {
       "keyword": {
         "fonts": [
           {
             "font": "./fonts/YourFont-Bold.ttf",
             "supported": ["ja", "en-US"]
           }
         ]
       }
     }
   }
   ```

## 🔧 トラブルシューティング

### 問題: シミュレータが起動しない

```bash
# シミュレータを手動で起動
open -a Simulator

# または必要なシミュレータをインストール
# Xcode > Settings > Platforms > iOS Simulators
```

### 問題: 特定の言語のスクリーンショットが取得されない

1. アプリが該当言語の翻訳ファイル（ARBファイル）を持っているか確認
2. `lib/l10n/` に該当言語のARBファイルがあることを確認
3. `flutter gen-l10n` を実行して翻訳を生成

### 問題: テキストが長すぎて切れる

`Framefile.json` の `font_scale_factor` を小さくする:

```json
{
  "title": {
    "font_scale_factor": 0.08  // 0.10 → 0.08に縮小
  }
}
```

### 問題: スクリーンショットが真っ暗

`integration_test/screenshot_test.dart` に以下を追加:

```dart
await binding.convertFlutterSurfaceToImage();
await tester.pumpAndSettle();
await binding.takeScreenshot('screen-name');
```

## 📊 生成されるファイル数

**計算例:**
- 画面数: 2枚（ホーム、設定）
- デバイス数: 2台（iPhone 16 Pro Max, iPhone 15 Pro Max）
- 言語数: 39言語

**合計:** 2画面 × 2デバイス × 39言語 = **156枚**のスクリーンショット

フレーム付きの場合、さらに156枚のカスタマイズ版が生成されます。

## 🔗 参考リンク

- [Fastlane snapshot](https://docs.fastlane.tools/actions/snapshot/)
- [Fastlane frameit](https://docs.fastlane.tools/actions/frameit/)
- [App Store Connect スクリーンショット仕様](https://help.apple.com/app-store-connect/#/devd274dd925)
- [Flutter integration testing](https://docs.flutter.dev/testing/integration-tests)

## 💡 ベストプラクティス

### スクリーンショットの枚数
App Store Connectでは最大10枚のスクリーンショットを掲載できます。以下のような構成がおすすめ：

1. **ホーム/メイン画面** - アプリの第一印象
2. **主要機能1** - コアバリューの提示
3. **主要機能2** - 差別化ポイント
4. **主要機能3** - ユーザーメリット
5. **設定/カスタマイズ** - 柔軟性のアピール

### テキストオーバーレイのコツ
- **キーワード**: 短く、インパクトのある言葉（2-4語）
- **タイトル**: 機能のメリットを明確に（1文）
- **一貫性**: 全スクリーンショットで統一感を持たせる

### 翻訳の品質
`Framefile.json` の翻訳テキストは、プロの翻訳者によるレビューを推奨します。現在のテキストは機械翻訳ベースのため、商用利用前に確認してください。
