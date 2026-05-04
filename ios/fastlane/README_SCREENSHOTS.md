# App Store スクリーンショット自動生成ガイド

## 概要

このシステムは、39言語対応のApp Storeスクリーンショットを完全自動で生成します。

**生成される要素:**
- ✅ デバイスフレーム（iPhone外枠）
- ✅ グラデーション背景（ブランドカラー）
- ✅ タイトルテキスト（各画面の見出し）
- ✅ 説明テキスト（機能説明）
- ✅ 多言語対応（39言語）

## セットアップ

### 1. ImageMagickのインストール

```bash
brew install imagemagick
```

### 2. Ghostscriptのインストール（テキスト描画に必須）

```bash
brew install ghostscript
```

### 3. フォントのインストール（オプション）

より美しいタイポグラフィのために、SF Pro フォントをインストールできます：

```bash
# Apple公式サイトからSF Proフォントをダウンロード
# https://developer.apple.com/fonts/
```

## 使い方

### 基本的な使い方（英語版）

```bash
# 1. スクリーンショットを生成（Flutter integration test）
cd ios
bundle exec fastlane take_screenshots

# 2. デバイスフレーム + マーケティングデザインを適用
bundle exec fastlane apply_frames
```

これで、`screenshots/` に以下の要素を含むスクリーンショットが生成されます：
- デバイスフレーム
- グラデーション背景
- タイトル・説明テキスト

### カスタマイズ

#### 1. テキストの変更

`Framefile.json` を編集：

```json
{
  "data": [
    {
      "filter": "01-home",
      "title": {
        "text": "あなたのタイトル"  // ← ここを変更
      },
      "keyword": {
        "text": "あなたの説明文"    // ← ここを変更
      }
    }
  ]
}
```

#### 2. 背景色の変更

`generate_background.sh` を編集：

```bash
# プライマリカラーからセカンダリカラーへのグラデーション
convert -size 1290x2796 \
  gradient:'#1976D2-#2196F3' \  # ← ここを変更
  -rotate 135 \
  "$OUTPUT_FILE"
```

#### 3. フォントサイズ・色の変更

`Framefile.json` の `default` セクションを編集：

```json
{
  "default": {
    "title": {
      "color": "#FFFFFF",      // タイトルの色
      "font_size": 72         // タイトルのサイズ
    },
    "keyword": {
      "color": "#E3F2FD",     // 説明文の色
      "font_size": 48         // 説明文のサイズ
    }
  }
}
```

## 多言語対応

### 🌟 推奨: ARBファイルから自動翻訳抽出（完全自動化）

**このプロジェクトでは、既に全39言語のARB翻訳ファイルが準備されています。**

#### 仕組み

1. `lib/l10n/app_*.arb` に既にスクリーンショット用の翻訳が含まれています
2. `generate_framefiles_from_arb.rb` が自動的に全言語のFramefileを生成
3. `apply_frames` レーンが各言語に適したテキストを自動適用

#### 使い方

```bash
# 完全自動化（推奨）
cd ios
bundle exec fastlane apply_frames  # 自動でARBから翻訳を読み込み、全言語に適用
```

これで、**39言語全て**のスクリーンショットに、各言語の翻訳が自動的に適用されます。

#### ARBキーの追加/変更方法

`lib/l10n/app_*.arb` に以下のキーが既に含まれています：

```json
{
  "screenshotHomeTitle": "Welcome Home",
  "screenshotHomeDescription": "Your personalized dashboard",
  "screenshotExploreTitle": "Discover More",
  "screenshotExploreDescription": "Explore tailored content",
  "screenshotFavoritesTitle": "Save Favorites",
  "screenshotFavoritesDescription": "Quick access to favorites",
  "screenshotProfileTitle": "Your Profile",
  "screenshotProfileDescription": "Manage your account",
  "screenshotSettingsTitle": "Customize",
  "screenshotSettingsDescription": "Personalize your experience"
}
```

**テキストを変更したい場合：**
1. 該当するARBファイルを編集（例: `app_en.arb`, `app_ja.arb`）
2. `bundle exec fastlane apply_frames` を再実行

**翻訳が追加されていない言語の場合：**
- 英語版がフォールバックとして自動的に使用されます
- 必要に応じて該当言語のARBファイルに翻訳を追加

### 方法2: 手動で各言語のFramefileを作成

```bash
# 日本語版を作成
cp Framefile.json screenshots/ja/Framefile.json
# screenshots/ja/Framefile.json を編集してテキストを日本語に翻訳

# 適用
cd ios
bundle exec fastlane apply_frames
```

## 高度なカスタマイズ

### より高度なデザインが必要な場合

1. **Figma/Photoshopテンプレート**
   - 完全にカスタマイズ可能なデザイン
   - 手動で各スクリーンショットを配置

2. **カスタムPythonスクリプト**
   - Pillow（PIL）ライブラリを使用
   - プログラマティックに高度なデザインを生成

3. **専門デザイナーに依頼**
   - App Storeのコンバージョン率を最大化

## トラブルシューティング

### エラー: "ImageMagick not found"

```bash
brew install imagemagick
```

### エラー: "Ghostscript not found" / テキストが表示されない

フレームは付くがテキストが表示されない場合、Ghostscriptが必要です:

```bash
brew install ghostscript
```

エラー例:
```
sh: gs: command not found
mogrify: delegate library support not built-in 'none' (Freetype)
```

### エラー: "Font not found"

フォント指定を削除するか、システムフォントを使用：

```json
{
  "title": {
    "font": null  // システムデフォルトフォントを使用
  }
}
```

### 背景が表示されない

背景画像が生成されているか確認：

```bash
ls -la ios/fastlane/background.png
```

なければ手動で生成：

```bash
cd ios/fastlane
./generate_background.sh
```

## ファイル構成

```
ios/fastlane/
├── Framefile.json              # 英語版の設定
├── Framefile-ja.json           # 日本語版の設定（生成後）
├── background.png              # グラデーション背景（生成後）
├── generate_background.sh      # 背景生成スクリプト
├── generate_framefiles.rb      # 多言語Framefile生成スクリプト
└── screenshots/                # スクリーンショット格納ディレクトリ
    ├── en-US/
    │   ├── 01-home.png
    │   └── ...
    ├── ja/
    └── ...
```

## ベストプラクティス

1. **シンプルなテキスト**: 短く、わかりやすいメッセージ
2. **ブランドカラー**: アプリのブランドカラーを使用
3. **読みやすさ**: 十分なコントラストを確保
4. **一貫性**: 全スクリーンショットで統一されたデザイン
5. **A/Bテスト**: 複数のバリエーションを試す

## 参考リンク

- [Apple HIG - App Store Screenshots](https://developer.apple.com/design/human-interface-guidelines/app-store)
- [Fastlane frameit](https://docs.fastlane.tools/actions/frameit/)
- [App Store Screenshot Sizes](https://help.apple.com/app-store-connect/#/devd274dd925)
