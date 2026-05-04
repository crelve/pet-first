# 📋 Step 09b: InfoPlist.strings パーミッション確認・修正

<!-- PROGRESS_COMMAND_ID: 09b-infoplist-check -->
<!-- PROGRESS_PHASE: phase3 -->
<!-- PROGRESS_NAME: InfoPlist.strings パーミッション確認・修正 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 5-10分

App Store審査でリジェクトされないよう、iOS パーミッション説明文を確認・修正します。

---

## 🔍 チェック内容

### 1. 無効キー・プレースホルダーの検出

以下のキーは削除が必要です：

| キー | 理由 |
|------|------|
| `NSMicrophoneUsageDescription` | アプリがマイクを使用しない場合はNG（不要なパーミッション要求でリジェクト） |
| `NSUserNotificationsUsageDescription` | iOSに存在しないキー（通知はシステムダイアログで処理） |
| `MDItemKeywords` | テンプレートのプレースホルダー。Keyword1等が残るとメタデータ不正でリジェクト |
| `kMDItemKeywords` | 同上 |

### 2. 説明文の品質

Appleは「なぜ必要か」を具体的に記述することを要求します。

| NG例 | OK例 |
|------|------|
| 「カメラへのアクセスが必要です」 | 「毎日の肌の変化を記録するための写真撮影に使用します」 |
| 「写真を保存するために必要です」 | 「肌の進捗写真をフォトライブラリから選択・保存するために使用します」 |
| 「トラッキングに使用します」 | 「あなたの興味に合わせたパーソナライズ広告を表示するために使用します」 |

---

## Claude Code 実行指示

### Step 1: 現状確認

```bash
# 使用中のパーミッションキーを確認
grep -r "NSMicrophoneUsageDescription\|NSUserNotificationsUsageDescription" ios/Runner/
echo "---"
# プレースホルダーキーワードを確認
grep -r "MDItemKeywords\|kMDItemKeywords\|Keyword1" ios/Runner/Info.plist
echo "---"
cat ios/Runner/en.lproj/InfoPlist.strings
echo "---"
# Info.plist 本体の確認
grep -A1 "NSMicrophoneUsageDescription\|NSPhotoLibrary\|NSCamera\|NSTracking\|NSUserNotifications" ios/Runner/Info.plist
```

### Step 2: アプリの機能に応じた必要キーを判定

以下を確認し、実際に使用する機能のキーだけを残す：

| キー | 使用条件 |
|------|---------|
| `NSUserTrackingUsageDescription` | AdMobなど広告SDKを使用する場合 |
| `NSPhotoLibraryUsageDescription` | ギャラリーから写真を選択・保存する場合 |
| `NSCameraUsageDescription` | カメラで写真・動画を撮影する場合 |
| `NSLocationWhenInUseUsageDescription` | 位置情報を使用する場合 |

**このアプリで使用するパーミッションキーを確認するコマンド:**
```bash
# パーミッション関連のコードを検索
grep -r "ImagePicker\|AVCaptureDevice\|CLLocation\|ATTrackingManager\|PHPhoto" lib/ --include="*.dart" | grep -v "//.*grep"
```

### Step 3: 無効キー・プレースホルダーの削除

不要なキーが見つかった場合：

```bash
# Info.plist からマイクキーを削除（マイク未使用の場合）
/usr/libexec/PlistBuddy -c "Delete :NSMicrophoneUsageDescription" ios/Runner/Info.plist 2>/dev/null

# プレースホルダーキーワード削除
/usr/libexec/PlistBuddy -c "Delete :MDItemKeywords" ios/Runner/Info.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Delete :kMDItemKeywords" ios/Runner/Info.plist 2>/dev/null

# InfoPlist.strings から削除（全言語一括）
find ios/Runner -name "InfoPlist.strings" -exec sed -i '' '/"NSMicrophoneUsageDescription"/d' {} \;
find ios/Runner -name "InfoPlist.strings" -exec sed -i '' '/"NSUserNotificationsUsageDescription"/d' {} \;
```

### Step 4: 説明文の改善（全39言語）

説明文が具体性に欠ける場合、以下のPythonスクリプトで一括更新する。
**各言語の翻訳はアプリの実際の機能・言語に合わせて適切に記述すること。**

```python
# /tmp/fix_infoplist.py として実行
import os, re

lproj_base = "ios/Runner"

translations = {
    # キー: (NSUserTrackingUsageDescription, NSPhotoLibraryUsageDescription, NSCameraUsageDescription)
    "en":    ("To show you personalized ads based on your interests.", "To select and save your [APP_FEATURE] photos from your photo library.", "To take photos for [APP_FEATURE]."),
    "ja":    ("あなたの興味に合わせたパーソナライズ広告を表示するために使用します。", "[APP_FEATURE]の写真をフォトライブラリから選択・保存するために使用します。", "[APP_FEATURE]の写真撮影に使用します。"),
    # ... 他言語も同様に
}

# 各 .lproj を処理し、必要なキーのみ記述する
```

### Step 5: 最終確認

```bash
# 無効キー・プレースホルダーが完全に除去されたことを確認
grep -r "NSMicrophoneUsageDescription\|NSUserNotificationsUsageDescription\|MDItemKeywords\|kMDItemKeywords\|Keyword1" ios/Runner/Info.plist && echo "⚠️ Invalid keys remain" || echo "✅ No invalid keys"

# en.lproj の内容を確認
cat ios/Runner/en.lproj/InfoPlist.strings

# ja.lproj の内容を確認
cat ios/Runner/ja.lproj/InfoPlist.strings
```

---

## ✅ 完了条件

- [ ] `NSMicrophoneUsageDescription` が存在しない（マイク未使用の場合）
- [ ] `NSUserNotificationsUsageDescription` が存在しない（全言語）
- [ ] `MDItemKeywords` / `kMDItemKeywords` が存在しない（プレースホルダー削除済み）
- [ ] `Info.plist` 本体にも不要なキーがない
- [ ] 説明文がアプリ機能を具体的に説明している（39言語）

---

## ✅ 完了時アクション

`RELEASE_CHECKLIST.md` の該当ステップをチェック済みに更新：

```
- [ ] `/release:step:09b-infoplist-check`
↓
- [x] `/release:step:09b-infoplist-check`
```
