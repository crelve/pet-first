# スクリーンショットシステム - クイックテストガイド

完全なシステムを2言語（日本語・英語）でテストできます。

## 📋 事前準備

### 1. ImageMagick のインストール

```bash
brew install imagemagick
```

確認:
```bash
convert -version
```

### 2. Ghostscript のインストール（テキスト描画に必須）

```bash
brew install ghostscript
```

確認:
```bash
gs --version
```

### 3. iOS シミュレータの確認

以下のいずれかが利用可能か確認:
- iPhone 16 Pro Max
- iPhone 15 Pro Max
- iPhone 15 Pro
- iPhone 14 Pro Max

確認コマンド:
```bash
xcrun simctl list devices | grep "iPhone"
```

## 🚀 クイックテスト実行

### ステップ1: スクリーンショット取得（2-3分）

```bash
cd ios
bundle exec fastlane take_screenshots_quick
```

**実行内容:**
- 日本語（ja）と英語（en-US）の2言語のみ
- 各言語 × 5画面 = 10枚のスクリーンショット
- 保存先: `screenshots/ja/`, `screenshots/en-US/`

**生成されるファイル:**
```
screenshots/
├── ja/
│   ├── 01-home.png
│   ├── 02-explore.png
│   ├── 03-favorites.png
│   ├── 04-profile.png
│   └── 05-settings.png
└── en-US/
    ├── 01-home.png
    ├── 02-explore.png
    ├── 03-favorites.png
    ├── 04-profile.png
    └── 05-settings.png
```

### ステップ2: マーケティングデザイン適用（1-2分）

```bash
bundle exec fastlane apply_frames_quick
```

**実行内容:**
1. グラデーション背景を生成（1290x2796 px）
2. 背景画像を各言語ディレクトリにコピー
3. ARBファイルから翻訳を抽出してFramefile生成
4. デバイスフレーム + 背景 + テキストを適用

**生成されるファイル:**
```
screenshots/
├── ja/
│   ├── 01-home.png          # 元の画像
│   ├── 01-home_framed.png   # フレーム付き（App Store用）
│   ├── 02-explore.png
│   ├── 02-explore_framed.png
│   ├── ...
│   ├── background.png       # グラデーション背景
│   └── Framefile.json       # 日本語翻訳テキスト
└── en-US/
    ├── 01-home.png
    ├── 01-home_framed.png
    ├── ...
    ├── background.png
    └── Framefile.json       # 英語翻訳テキスト
```

### ステップ3: 結果確認

```bash
# 日本語スクリーンショットを開く
open screenshots/ja

# 英語スクリーンショットを開く
open screenshots/en-US
```

**確認ポイント:**
- ✅ `*_framed.png` ファイルにデバイスフレームが付いているか
- ✅ グラデーション背景が表示されているか
- ✅ 日本語/英語のタイトル・説明テキストが表示されているか
- ✅ テキストが正しく翻訳されているか

## 🔍 期待される結果

### 日本語 (ja)

**01-home_framed.png:**
- タイトル: "ホームへようこそ"
- 説明: "あなた専用のダッシュボード"

**02-explore_framed.png:**
- タイトル: "もっと発見"
- 説明: "あなたにぴったりのコンテンツ"

### 英語 (en-US)

**01-home_framed.png:**
- タイトル: "Welcome Home"
- 説明: "Your personalized dashboard"

**02-explore_framed.png:**
- タイトル: "Discover More"
- 説明: "Explore tailored content"

## 📊 ワンライナーテスト

両方のステップを一度に実行:

```bash
cd ios && \
bundle exec fastlane take_screenshots_quick && \
bundle exec fastlane apply_frames_quick && \
open ../screenshots/ja
```

## 🎯 完全版への移行

テストが成功したら、全39言語で実行:

```bash
# 全言語でスクリーンショット取得（10-30分）
bundle exec fastlane take_screenshots

# 全言語にマーケティングデザイン適用（5-10分）
bundle exec fastlane apply_frames
```

## ❓ トラブルシューティング

### ImageMagick not found

```bash
brew install imagemagick
```

### Ghostscript not found / テキストが表示されない

フレームは付くがテキストが表示されない場合、Ghostscriptが必要です:

```bash
brew install ghostscript
```

エラー例:
```
sh: gs: command not found
mogrify: delegate library support not built-in 'none' (Freetype)
```

### シミュレータが見つからない

```bash
# 利用可能なシミュレータ一覧
xcrun simctl list devices

# iPhone 16 Pro Max がない場合はインストール
# Xcode → Settings → Platforms → iOS → Simulators
```

### Framefileが見つからない

```bash
# ARBファイルから再生成
cd ios
bundle exec fastlane generate_framefiles
```

### 背景画像が生成されない

```bash
# 手動で背景画像を生成
cd ios/fastlane
./generate_background.sh
ls -lh background.png
```

## 📝 カスタマイズ

### テスト言語を変更

`integration_test/screenshot_test_quick.dart` の `locales` を編集:

```dart
final locales = [
  const Locale('ja'),        // 日本語
  const Locale('zh', 'Hans'), // 中国語
  const Locale('ko'),        // 韓国語
];
```

`ios/fastlane/Fastfile` の `apply_frames_quick` も同様に編集:

```ruby
test_locales = ["ja", "zh-Hans", "ko"]
```

### テキストの変更

`lib/l10n/app_ja.arb` や `app_en.arb` を編集:

```json
{
  "screenshotHomeTitle": "カスタムタイトル",
  "screenshotHomeDescription": "カスタム説明文"
}
```

編集後、Framefileを再生成:

```bash
cd ios
bundle exec fastlane generate_framefiles
```
