# スクリーンショット背景画像生成ガイド

## 概要

`generate_background.sh` は、App Storeスクリーンショット用の背景画像（1290x2796px）を自動生成するスクリプトです。

アプリのカテゴリとブランドカラーに基づいて、最適なスタイルの背景を自動選択・生成します。

## クイックスタート

### 自動生成（推奨）

```bash
# /release:step:03-app-icons-images-guide コマンドを実行すると自動的に：
# 1. アプリコンセプトを分析
# 2. カテゴリに応じたスタイルを選択
# 3. background_colors.json を生成
# 4. generate_background.sh を実行
# 5. background.png を生成

cd ios/fastlane
bash generate_background.sh
```

### 手動カスタマイズ

```bash
# 1. 設定ファイルを編集
vim ../../creative/background_colors.json

# 2. 背景を再生成
bash generate_background.sh

# 3. プレビュー
open background.png
```

## 利用可能なスタイル

### 1. simple - シンプルグラデーション
**用途**: ユーティリティ、生産性アプリ
**特徴**: ブランドカラーベースの縦グラデーション
**例**: `#7DDAFF` → `#1976D2`

```json
{
  "style": "simple",
  "colors": {
    "primary": "#1976D2"
  }
}
```

### 2. luxurious - 豪華グラデーション（デフォルト）
**用途**: ゲーム、エンターテイメント
**特徴**: 多色グラデーション + ノイズ + 光沢
**例**: 紫 → ピンク → オレンジ

```json
{
  "style": "luxurious",
  "colors": {
    "gradient_start": "#667eea",
    "gradient_mid": "#764ba2",
    "gradient_end": "#f5576c"
  },
  "gradient_angle": 135,
  "noise_intensity": 0.15,
  "overlay_opacity": 0.3
}
```

### 3. natural - ナチュラルグラデーション
**用途**: 健康、フィットネス、医療アプリ
**特徴**: 緑 → 青の自然なグラデーション

```json
{
  "style": "natural",
  "colors": {
    "gradient_start": "#4CAF50",
    "gradient_end": "#03A9F4"
  }
}
```

### 4. professional - プロフェッショナル
**用途**: 金融、ビジネスアプリ
**特徴**: 濃紺 → ライトブルーの信頼感あるグラデーション

```json
{
  "style": "professional"
}
```

### 5. pop - ポップグラデーション
**用途**: SNS、コミュニケーション、デートアプリ
**特徴**: 鮮やかな2色の斜めグラデーション

```json
{
  "style": "pop",
  "colors": {
    "gradient_start": "#FF6B9D",
    "gradient_end": "#FFA06B"
  }
}
```

### 6. soft - 柔らかいグラデーション
**用途**: 教育、学習アプリ
**特徴**: パステル調の優しいグラデーション

```json
{
  "style": "soft"
}
```

### 7. trend - トレンドグラデーション
**用途**: ライフスタイル、ショッピングアプリ
**特徴**: 2025年トレンドのパステルカラー

```json
{
  "style": "trend"
}
```

## 設定ファイルの詳細

### background_colors.json の構造

```json
{
  "style": "luxurious|simple|natural|professional|pop|soft|trend",
  "colors": {
    "primary": "#1976D2",           // ブランドカラー（simpleスタイル用）
    "gradient_start": "#667eea",    // グラデーション開始色
    "gradient_mid": "#764ba2",      // グラデーション中間色（luxurious用）
    "gradient_end": "#f5576c"       // グラデーション終了色
  },
  "gradient_angle": 135,            // グラデーション角度（luxurious, pop用）
  "noise_intensity": 0.15,          // ノイズ強度 0.0-1.0（luxurious用）
  "overlay_opacity": 0.3            // 光沢オーバーレイ透明度（luxurious用）
}
```

### パラメータの説明

| パラメータ | 説明 | デフォルト値 |
|-----------|------|-------------|
| `style` | 背景スタイル | `luxurious` |
| `colors.primary` | ブランドカラー（HEX） | `#1976D2` |
| `colors.gradient_start` | グラデーション開始色 | `#667eea` |
| `colors.gradient_mid` | グラデーション中間色 | `#764ba2` |
| `colors.gradient_end` | グラデーション終了色 | `#f5576c` |
| `gradient_angle` | グラデーション角度（度） | `135` |
| `noise_intensity` | ノイズテクスチャ強度 | `0.15` |
| `overlay_opacity` | 光沢オーバーレイ透明度 | `0.3` |

## トラブルシューティング

### ImageMagick not found

```bash
brew install imagemagick-full
```

### jq not found（設定ファイル読み込みに必要）

```bash
brew install jq
```

設定ファイルがない場合は、デフォルト設定（luxurious）で動作します。

### 生成画像のサイズが正しくない

スクリプトは常に `1290x2796px`（iPhone 16 Pro Max）で生成します。

### 設定ファイルが反映されない

```bash
# 設定ファイルのパスを確認
ls -l ../../creative/background_colors.json

# JSONの構文をチェック
cat ../../creative/background_colors.json | jq .
```

## AI生成オプション

ImageMagickベースの生成に満足できない場合、Gemini Nano Bananaでカスタム背景を生成できます：

```bash
# 1. プロンプトファイルを確認
cat ../../creative/background_prompt.txt

# 2. Gemini Nano Banana で画像生成
# https://gemini.google.com/

# 3. 生成画像を保存
cp ~/Downloads/generated_background.png background.png
```

## 関連ファイル

- `generate_background.sh` - 背景生成スクリプト
- `../../creative/background_colors.json` - 設定ファイル
- `../../creative/background_prompt.txt` - Gemini用プロンプト
- `background.png` - 生成された背景画像（1290x2796px）

## 使用例

### ケース1: 生産性アプリ（タスク管理）

```json
{
  "style": "simple",
  "colors": {
    "primary": "#2196F3"
  }
}
```

### ケース2: フィットネスアプリ

```json
{
  "style": "natural",
  "colors": {
    "gradient_start": "#4CAF50",
    "gradient_end": "#00BCD4"
  }
}
```

### ケース3: ソーシャルアプリ

```json
{
  "style": "pop",
  "colors": {
    "gradient_start": "#E91E63",
    "gradient_end": "#FF5722"
  }
}
```

---

**参考**: `/release:step:03-app-icons-images-guide` コマンドで自動生成される設定を使うと、アプリカテゴリに最適化された背景が作成されます。
