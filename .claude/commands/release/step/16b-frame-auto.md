---
description: スクリーンショット自動フレーム適用（frameit + ImageMagick
---

# Step 16b: 自動フレーム適用

<!-- PROGRESS_COMMAND_ID: 16b-frame-auto -->
<!-- PROGRESS_PHASE: phase5 -->
<!-- PROGRESS_NAME: 自動フレーム適用 -->
<!-- PROGRESS_STATUS: not_implemented -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 5-10分（実装後）

## ✅ 実装済み

frameit + ImageMagickによる自動フレーム適用機能が実装されています。

**重要**: 元の生スクリーンショットは保持され、フレーム適用版は `_framed.png` として別ファイルで保存されます。

---

## 使い方

```bash
/release:step:16b-frame-auto
```

## 概要

frameit + ImageMagickを使用して、生スクリーンショットに以下を自動適用：
- ✅ デバイスフレーム（iPhone 16 Pro Max）
- ✅ ローカライズされた説明文（39言語）
- ✅ 背景画像（ブランドカラー）
- ✅ アルファチャンネル除去（RGB形式）

**入力:** `screenshots/{lang}/01-home.png` 等（195枚）
**出力:** `screenshots/{lang}/01-home_framed.png` 等（195枚）
**保持:** 元の生スクリーンショットはそのまま保持

**特徴:**
- 🚀 高速（5-10分）
- 💰 コスト不要
- 🔒 安定動作
- 📱 App Store Connect即アップロード可

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

# 必須ファイルの確認
test -f ios/fastlane/background.png && echo "✅ background.png exists" || echo "❌ background.png missing"
test -f screenshots/ja/Framefile.json && echo "✅ Framefile.json exists" || echo "❌ Framefile.json missing"
```

すべて ✅ であれば次に進んでください。

❌ がある場合：

```bash
# background.png を自動生成（creative/background_colors.jsonから）
ios/fastlane/generate_background.sh

# Framefile.json を再生成
ios/fastlane/generate_framefiles_from_arb.rb
```

### Step 2: 環境確認

```bash
# ImageMagick確認
magick -version | head -1

# Ghostscript確認（PDF処理用）
gs --version
```

不足がある場合：

```bash
brew install imagemagick ghostscript
```

### Step 3: フレーム適用（5-10分）

以下のコマンドを実行してください：

```bash
cd ios
bundle exec fastlane apply_frames
```

**処理の流れ:**

```
1. frameit がデバイスフレームを適用
   ↓ 01-home.png → 01-home_framed.png

2. ImageMagick が CJK言語のテキストを追加
   ↓ 日本語・中国語・韓国語にローカライズされたテキスト

3. アルファチャンネルを除去（RGB形式に変換）
   ↓ App Store Connect対応形式

4. _framed.png を元のファイル名にリネーム
   ↓ 01-home_framed.png → 01-home.png（上書き）
```

**プログレス表示:**

```
[12:45:10]: Applying device frames to screenshots...
[12:45:23]: Processing ja locale...
[12:45:45]: 🎨 Framing Japanese screenshots with ImageMagick...
[12:46:12]: ✅ 01-home: ホームへようこそ
[12:46:23]: ✅ 02-explore: もっと発見
...
[12:52:45]: ✅ Frame application completed!
[12:52:45]: 📊 Processed: 195 screenshots
[12:52:45]: ⏱️  Duration: 7m 35s
```

完了後、フレーム付き画像を確認：

```bash
cd ..
FRAMED_COUNT=$(find screenshots -name "*.png" ! -name "background.png" | wc -l)
echo "📊 Framed screenshots: $FRAMED_COUNT"
```

期待値: **195枚**（`_framed.png` は元のファイルに上書き済み）

### Step 4: 品質確認

フレーム付き画像をプレビュー：

```bash
open screenshots/ja/01-home.png
open screenshots/en-US/01-home.png
open screenshots/zh-Hans/01-home.png
```

**チェックポイント:**
- ✅ デバイスフレームが適用されている
- ✅ 背景画像が表示されている
- ✅ ローカライズされた説明文が中央揃えで表示されている
- ✅ CJK言語のフォントが正しく表示されている
- ✅ 画像サイズ: 1290x2796px

### Step 5: アルファチャンネル確認（重要）

App Store Connect対応形式（RGB）になっているか確認：

```bash
# RGBAが0件であることを確認
RGBA_COUNT=$(find screenshots -name "*.png" ! -name "background.png" -exec file {} \; | grep "RGBA" | wc -l)
echo "🔍 RGBA files: $RGBA_COUNT (should be 0)"

if [ "$RGBA_COUNT" -eq 0 ]; then
  echo "✅ All screenshots are RGB format (App Store Connect ready)"
else
  echo "⚠️  Found $RGBA_COUNT RGBA files. They should be converted to RGB."
fi
```

### Step 6: アップロード準備

フレーム付きスクリーンショットをApp Store Connect用に準備：

```bash
cd ios
bundle exec fastlane prepare_screenshots_for_upload
```

これにより：
- `screenshots_upload/` ディレクトリが作成される
- 各言語で最適なバージョン（framed > original）が選択される
- アップロード用に元のファイル名（`01-home.png`）でコピーされる

**ファイル構造:**
```
screenshots/
  ja/
    01-home.png          ← 元の生画像（保持）
    01-home_framed.png   ← フレーム付き画像

screenshots_upload/      ← アップロード用
  ja/
    01-home.png          ← framed版がコピーされる
```

### Step 7: オプション - AI生成フレームへの切り替え

より高品質なフレームが必要な場合：

```bash
/release:step:16c-frame-ai
```

AI生成後も、元の生画像とframeit版は保持されます：
```
screenshots/
  ja/
    01-home.png          ← 元の生画像（保持）
    01-home_framed.png   ← frameit版（保持）
    01-home_ai.png       ← AI生成版（新規）
```

アップロード時は自動的に AI > framed > original の優先順位で選択されます。

**✅ 完了！**

---

## トラブルシューティング

### エラー: ImageMagick未インストール

```
❌ magick: command not found
```

**解決策**:

```bash
brew install imagemagick
magick -version  # v7.x.x を確認
```

### エラー: CJKフォントが見つからない

```
❌ Font '.Hiragino-Kaku-Gothic-Interface-W6' not found
```

**解決策**: macOS標準フォントなので再インストール不要。Xcodeを再起動。

### エラー: background.pngがない

```
❌ background.png not found
```

**解決策**: 自動生成

```bash
cd ios
bundle exec fastlane customize_screenshots
```

### フレーム付き画像のテキストが右寄り

**原因**: 古い`frame_cjk_screenshots.rb`を使用している

**解決策**: 最新版を使用（`-gravity Center -annotate`で中央揃え済み）

```bash
# 最新版の確認
grep "gravity Center" ios/fastlane/frame_cjk_screenshots.rb
```

### アルファチャンネルが残っている

**原因**: ImageMagickコマンドが古い

**解決策**: 手動で変換

```bash
cd screenshots
for file in $(find . -name "*.png" ! -name "background.png" -type f); do
  if file "$file" | grep -q "RGBA"; then
    magick "$file" -background white -flatten -alpha off -define png:color-type=2 "$file.tmp" && mv "$file.tmp" "$file"
  fi
done
```

---

## カスタマイズガイド（参考）

### 背景画像のカスタマイズ

```bash
# ブランドカラーから自動生成（推奨）
cd ios
bundle exec fastlane customize_screenshots

# または手動で編集
open ios/fastlane/background.png
```

### 説明文のカスタマイズ

`lib/l10n/app_en.arb` を編集：

```json
{
  "screenshotHomeTitle": "Welcome Home",
  "screenshotHomeDescription": "Your personalized dashboard"
}
```

編集後、39言語に自動翻訳：

```bash
flutter pub run flutter_foundation:translate_arb
```

Framefileを再生成：

```bash
cd ios/fastlane
ruby generate_framefiles_from_arb.rb
```

---

## 完了時アクション

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md
- [ ] → - [x] **`/release:step:16b-frame-auto`**
```

## 次のステップ

```bash
/release:step:10-appstore-metadata
```

App Storeのメタデータ（説明文、キーワード等）を39言語で作成します。

---

## 関連ドキュメント

- [Step 16a: スクリーンショット撮影](./16a-capture-screenshots.md) - 撮影手順
- [Step 16c: AI生成フレーム](./16c-frame-ai.md) - AI生成パターン
- [ios/fastlane/SCREENSHOTS.md](../../../ios/fastlane/SCREENSHOTS.md) - スクリーンショット詳細設定
