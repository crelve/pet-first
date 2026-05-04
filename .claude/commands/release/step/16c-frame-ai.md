---
description: スクリーンショットAI生成フレーム適用（Nano Banana)
---

# Step 16c: AI生成フレーム適用

<!-- PROGRESS_COMMAND_ID: 16c-frame-ai -->
<!-- PROGRESS_PHASE: phase5 -->
<!-- PROGRESS_NAME: AI生成フレーム適用 -->
<!-- PROGRESS_STATUS: not_implemented -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 15-30分（実装後）

---

## （以下、実装予定の仕様）

## 使い方

```bash
/release:step:16c-frame-ai
```

## 概要

Nano Banana（画像生成AI）を使用して、プロフェッショナルなマーケティング用スクリーンショットを生成：
- ✅ 高品質なデザイン
- ✅ ブランドカラー自動検出
- ✅ ローカライズされた説明文（39言語）
- ✅ 魅力的な視覚効果
- ✅ App Store最適化

**入力:** `screenshots/{lang}/01-home.png` 等（195枚）
**出力:** `screenshots/{lang}/01-home_ai.png` 等（195枚）
**保持:** 元の生スクリーンショット及びframeit版は保持

**特徴:**
- 🎨 プロフェッショナルなデザイン
- 🌈 ブランドカラー自動適用
- 📈 App Storeでの訴求力向上
- ⚠️ 処理時間がかかる（15-30分）
- 💰 Nano Banana利用料が発生

---

## Claude Code 実行指示

### Step 1: 前提条件チェック

```bash
# 生スクリーンショットが存在するか確認
RAW_COUNT=$(find screenshots -name "*.png" ! -name "*_framed.png" ! -name "background.png" 2>/dev/null | wc -l)
echo "📊 Raw screenshots: $RAW_COUNT"

if [ "$RAW_COUNT" -lt 195 ]; then
  echo "❌ Not enough screenshots. Run /release:step:16a-capture-screenshots first."
  exit 1
fi

# Framefile.json の確認
test -f screenshots/ja/Framefile.json && echo "✅ Framefile.json exists" || echo "❌ Framefile.json missing"
```

❌ がある場合：

```bash
# Framefile.json を再生成
cd ios/fastlane
ruby generate_framefiles_from_arb.rb
cd ../..
```

### Step 2: ブランドカラー自動検出

アプリのブランドカラーを自動検出：

```bash
# lib/theme/app_theme.dart からprimaryColorを抽出
BRAND_COLOR=$(grep -A 5 "primaryColor" lib/theme/app_theme.dart | grep "Color(0x" | sed -E 's/.*Color\((0x[0-9A-Fa-f]+)\).*/\1/')

if [ -n "$BRAND_COLOR" ]; then
  echo "✅ Brand color detected: $BRAND_COLOR"
else
  echo "⚠️  Brand color not found, using default"
  BRAND_COLOR="0xFF2196F3"  # デフォルト: Material Blue
fi
```

### Step 3: AI生成プロンプトの準備

各言語のFramefile.jsonから説明文を読み取り、AI生成プロンプトを準備：

```bash
# サンプル: 日本語の説明文を取得
JA_TITLE=$(jq -r '.data[0].title.text' screenshots/ja/Framefile.json)
JA_DESC=$(jq -r '.data[0].keyword.text' screenshots/ja/Framefile.json)

echo "📝 Japanese text:"
echo "   Title: $JA_TITLE"
echo "   Description: $JA_DESC"
```

### Step 4: Nano Banana API設定

**重要**: Nano Banana APIキーが必要です。

```bash
# APIキーを環境変数に設定（セキュアな方法）
export NANO_BANANA_API_KEY="your-api-key-here"

# または dart_env/prod.env に追加
echo "nanoBananaApiKey=your-api-key-here" >> dart_env/prod.env
```

**APIキーの取得方法:**
1. https://nanobanana.ai にアクセス
2. アカウント作成
3. API設定からキーを発行

### Step 5: AI生成スクリプトの作成

AI生成用のスクリプトを作成します：

```ruby
# ios/fastlane/generate_ai_frames.rb
require 'net/http'
require 'json'
require 'base64'

# Nano Banana APIエンドポイント
API_ENDPOINT = 'https://api.nanobanana.ai/v1/generate'
API_KEY = ENV['NANO_BANANA_API_KEY']

def generate_framed_screenshot(input_path, output_path, title, description, brand_color)
  # 画像をBase64エンコード
  image_data = File.read(input_path)
  image_base64 = Base64.strict_encode64(image_data)

  # AIプロンプト生成
  prompt = <<~PROMPT
    Create a professional App Store marketing screenshot with:
    - Device frame: iPhone 16 Pro Max
    - Title text (top): "#{title}"
    - Description text (below title): "#{description}"
    - Brand color: #{brand_color}
    - Modern gradient background
    - Subtle drop shadow on device
    - Text should be centered and readable
    - Clean, professional design suitable for App Store
  PROMPT

  # API リクエスト
  uri = URI(API_ENDPOINT)
  request = Net::HTTP::Post.new(uri)
  request['Authorization'] = "Bearer #{API_KEY}"
  request['Content-Type'] = 'application/json'

  request.body = {
    prompt: prompt,
    image: image_base64,
    width: 1290,
    height: 2796,
    style: 'marketing'
  }.to_json

  # API コール
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  if response.is_a?(Net::HTTPSuccess)
    result = JSON.parse(response.body)
    generated_image = Base64.decode64(result['image'])
    File.write(output_path, generated_image)
    puts "✅ Generated: #{output_path}"
  else
    puts "❌ API Error: #{response.code} - #{response.body}"
    raise "Failed to generate AI frame"
  end
end
```

### Step 6: AI生成実行（15-30分）

**注意**: このステップは時間がかかります。195枚のスクリーンショットを順次処理します。

```bash
cd ios/fastlane

# AI生成スクリプトを実行
ruby generate_ai_frames_all.rb
```

**処理の流れ:**

```
For each language (39 languages):
  For each screenshot (5 screenshots):
    1. Framefile.jsonから説明文を読み取り
    2. Nano Banana APIにリクエスト送信
    3. AI生成画像を受信
    4. 元のファイルに上書き保存
    5. 次のスクリーンショットへ

Total: 195 API requests
Estimated time: 15-30 minutes
```

**プログレス表示:**

```
[13:00:00]: 🎨 Starting AI frame generation...
[13:00:00]: 📊 Total: 195 screenshots across 39 languages
[13:00:00]: ⏱️  Estimated time: 15-30 minutes
[13:00:05]: Processing ja/01-home.png...
[13:00:12]: ✅ Generated: ja/01-home.png (7s)
[13:00:15]: Processing ja/02-explore.png...
[13:00:22]: ✅ Generated: ja/02-explore.png (7s)
...
[13:28:45]: ✅ AI frame generation completed!
[13:28:45]: 📊 Processed: 195 screenshots
[13:28:45]: ⏱️  Total duration: 28m 45s
[13:28:45]: 💰 API calls: 195
```

### Step 7: 品質確認

AI生成されたスクリーンショットをプレビュー：

```bash
cd ../..
open screenshots/ja/01-home.png
open screenshots/en-US/01-home.png
open screenshots/zh-Hans/01-home.png
```

**チェックポイント:**
- ✅ プロフェッショナルなデザイン
- ✅ ブランドカラーが適用されている
- ✅ デバイスフレームが美しく表示されている
- ✅ テキストが読みやすく配置されている
- ✅ 画像サイズ: 1290x2796px

**品質が満足できない場合:**

プロンプトを調整して再実行：

```ruby
# ios/fastlane/generate_ai_frames.rb の prompt を編集
prompt = <<~PROMPT
  Create a professional App Store marketing screenshot with:
  - More vibrant colors
  - Larger text size
  - Stronger drop shadow
  ...
PROMPT
```

### Step 8: アルファチャンネル確認

App Store Connect対応形式（RGB）になっているか確認：

```bash
# RGBAが0件であることを確認
RGBA_COUNT=$(find screenshots -name "*.png" ! -name "background.png" -exec file {} \; | grep "RGBA" | wc -l)
echo "🔍 RGBA files: $RGBA_COUNT (should be 0)"

if [ "$RGBA_COUNT" -gt 0 ]; then
  echo "⚠️  Converting RGBA to RGB..."
  cd screenshots
  for file in $(find . -name "*.png" ! -name "background.png" -type f); do
    if file "$file" | grep -q "RGBA"; then
      magick "$file" -background white -flatten -alpha off -define png:color-type=2 "$file.tmp" && mv "$file.tmp" "$file"
    fi
  done
  cd ..
  echo "✅ All screenshots converted to RGB"
fi
```

### Step 9: アップロード準備

AI生成スクリーンショットをApp Store Connect用に準備：

```bash
cd ios
bundle exec fastlane prepare_screenshots_for_upload
```

これにより：
- AI生成版（`_ai.png`）が最優先で選択される
- frameit版（`_framed.png`）やオリジナル版も保持される

**ファイル構造（全バージョン保持）:**
```
screenshots/
  ja/
    01-home.png          ← 元の生画像（保持）
    01-home_framed.png   ← frameit版（保持）
    01-home_ai.png       ← AI生成版（最優先）

screenshots_upload/      ← アップロード用
  ja/
    01-home.png          ← ai版がコピーされる
```

**優先順位:** AI > framed > original

これにより、将来的に別のバージョンを試したい場合でも、元データは全て保持されています。

**✅ 完了！**

---

## トラブルシューティング

### エラー: APIキーが設定されていない

```
❌ NANO_BANANA_API_KEY not set
```

**解決策**:

```bash
export NANO_BANANA_API_KEY="your-api-key-here"
```

### エラー: API Rate Limit

```
❌ API Error: 429 - Rate limit exceeded
```

**解決策**: 少し待ってから再実行。または、バッチ処理を調整：

```ruby
# リクエスト間隔を追加
sleep 2  # 2秒待機
```

### エラー: API Timeout

```
❌ API Error: Timeout
```

**解決策**: タイムアウト時間を延長：

```ruby
http.read_timeout = 60  # 60秒
```

### 生成品質が低い

**原因**: プロンプトが適切でない

**解決策**: プロンプトを調整：

```ruby
prompt = <<~PROMPT
  Create a PREMIUM App Store marketing screenshot:
  - Ultra-modern design
  - High contrast text
  - Professional gradient background
  - Subtle animations (if supported)
  - Brand identity: [Your Brand Description]
  ...
PROMPT
```

### コストが高い

**原因**: 195枚 × API料金

**解決策**:
1. 主要言語のみ生成（日本語・英語・中国語など）
2. 残りは自動フレーム適用（/release:step:16b-frame-auto）を併用

```bash
# 主要言語のみAI生成
LANGUAGES="ja,en-US,zh-Hans,ko" ruby generate_ai_frames_all.rb

# 残りの言語は自動フレーム
cd ..
bundle exec fastlane apply_frames
```

---

## コスト試算

**Nano Banana料金（例）:**
- 1画像生成: $0.05
- 195枚: $9.75

**コスト削減方法:**
1. **主要言語のみAI生成** (20枚): $1.00
2. **残り175枚は自動フレーム**: 無料

---

## 完了時アクション

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md
- [ ] → - [x] **`/release:step:16c-frame-ai`**
```

## 次のステップ

```bash
/release:step:10-appstore-metadata
```

App Storeのメタデータ（説明文、キーワード等）を39言語で作成します。

---

## 関連ドキュメント

- [Step 16a: スクリーンショット撮影](./16a-capture-screenshots.md) - 撮影手順
- [Step 16b: 自動フレーム適用](./16b-frame-auto.md) - 自動フレームパターン
- [Nano Banana API Documentation](https://docs.nanobanana.ai)

---

## 参考: 自動フレームとの比較

| 項目 | 自動フレーム (16b) | AI生成 (16c) |
|------|-------------------|-------------|
| **処理時間** | 5-10分 | 15-30分 |
| **コスト** | 無料 | ~$10 |
| **品質** | 標準 | プロフェッショナル |
| **カスタマイズ** | 制限あり | 高度 |
| **安定性** | 非常に安定 | AI依存 |

**推奨**: 初回は自動フレーム（16b）で動作確認し、本番リリース時にAI生成（16c）を使用。
