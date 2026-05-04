---
description: アイコン適用（CEO Phase）- Geminiで生成した画像をアプリに配置してlauncher_iconを再生成
---

# Step 13: アイコン適用（CEO作業）

<!-- PROGRESS_COMMAND_ID: 13-icon-apply -->
<!-- PROGRESS_PHASE: ceo -->
<!-- PROGRESS_NAME: アイコン適用 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**所要時間**: 約3分/本

---

## CEO作業手順

### 1. プロンプトの確認

Step 03で生成されたプロンプトを確認する。

```bash
APP_NAME=$(basename $(pwd))
cat creative/app_icon_prompt.txt
```

### 2. Geminiで画像生成

1. [Gemini](https://gemini.google.com/) を開く
2. `creative/app_icon_prompt.txt` の内容をそのままGeminiに貼り付ける
3. 生成された画像をダウンロードする（1024×1024px PNG推奨）

**生成のポイント:**
- 角丸なし・背景透明なしのSHARPなSQUARE画像を生成すること
- 気に入らなければ「regenerate」か微調整プロンプトで再生成
- ダークモード対応が必要な場合は別途ダーク版も生成

### 3. ウォーターマーク除去

Gemini生成画像は右下にスパークルマーク（ウォーターマーク）が焼き込まれる。配置前に必ず除去する。

```bash
# ~/Downloads/ の5枚（appIcon/logoIcon/walkthrough1-3）を一括除去
python3 ~/kikiki/released/company/scripts/remove-watermark.py
```

### 4. 画像を配置

生成した画像をアプリの所定ディレクトリに配置する。

```bash
# ダウンロードした画像を配置（パスは実際のダウンロード先に合わせて変更）
cp ~/Downloads/generated_icon.png launcher_icon/image/appIcon.png

# 画像が正しく配置されたか確認
ls -lh launcher_icon/image/appIcon.png
file launcher_icon/image/appIcon.png
```

### 5. launcher_icon を再生成（コマンド実行）

```bash
# Prod環境のlauncher_iconを再生成
make create-launcher-icon FLAVOR=prod

# Dev環境も更新（任意）
make create-launcher-icon FLAVOR=dev

# スプラッシュスクリーンも再生成
make create-native-splash
```

### 6. 確認

```bash
# iOS用アイコンが生成されたか確認
ls ios/Runner/Assets.xcassets/AppIcon.appiconset/ | head -5
```

ビルドなしでもアイコンファイルが存在すればOK。

---

## 完了したら

このステップ完了後、session-buildが自動で次のCEO Phaseステップ（Step 14: TestFlight実機確認）に進める。

```bash
# companyリポのbuilding/ファイルのcurrent_stepを "14" に更新
# → session-buildが自動検知してStep 14をceo-local-todoに追記する
```

---

## トラブルシューティング

### make create-launcher-icon が失敗する場合

```bash
# flutter pub getを先に実行
fvm flutter pub get
make create-launcher-icon FLAVOR=prod
```

### 画像サイズが合わない場合

```bash
# ImageMagickでリサイズ（インストール済みの場合）
magick ~/Downloads/generated_icon.png -resize 1024x1024 launcher_icon/image/appIcon.png
```
