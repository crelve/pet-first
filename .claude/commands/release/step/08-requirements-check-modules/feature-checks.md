# 機能特化チェック

## 目的
機能カテゴリ別の詳細チェック

---

## 1. 認証・ユーザー管理系要件

### チェック項目
```bash
# Firebase Auth統合確認
grep -r "FirebaseAuth" lib/ --include="*.dart"

# ログイン画面存在確認
find lib/screen -name "*login*" -o -name "*auth*"

# ユーザープロファイル画面確認
find lib/screen -name "*profile*" -o -name "*user*"
```

---

## 2. データ管理系要件

### チェック項目
```bash
# Firestoreモデル確認
find lib/model -name "*.dart"

# データ永続化確認
grep -r "SharedPreferences\|Hive" lib/ --include="*.dart"
```

---

## 3. UI/UX系要件

### チェック項目
```bash
# Loading状態実装確認
grep -r "Loading()" lib/ --include="*.dart"

# エラーハンドリング確認
grep -r "try.*catch" lib/ --include="*.dart" | wc -l
```

---

## 4. 通知・連携系要件

> **Push通知の受信基盤は flutter_foundation が提供**
> - FCMトークン管理: `PushNotificationStateNotifier`（`lib/provider/push_notification_state_notifier.dart`）
> - 通知受信処理: `handleCloudMessage`（`lib/utility/handle_cloud_message.dart`）
> - 通知権限管理: `NotificationPermissionStateNotifier`
> - トークン自動取得フック: `usePushNotificationToken`
>
> app 側は「foundation の初期化・接続」と「リマインダー送信スケジュール」のみ実装する。

### チェック項目
```bash
# foundation の Push通知基盤が app.dart / base_screen で初期化されているか
grep -r "usePushNotificationToken\|foregroundMessageProvider\|backgroundMessageProvider\|initialMessageProvider" lib/ --include="*.dart"

# handleCloudMessage が接続されているか
grep -r "handleCloudMessage\|onBackgroundMessage" lib/ --include="*.dart"

# Firebase App Check（App Attest）確認
grep -r "FirebaseAppCheck\|AppleAppAttestProvider\|AppleDebugProvider" lib/ --include="*.dart"

# Entitlements に App Attest 設定があるか確認
grep "appattest-environment" ios/Runner/Runner-Release.entitlements

# リマインダーPush通知実装確認（採用している場合）
find lib/service -name "reminder*" -o -name "*reminder*"
find lib/model -name "reminder*" -o -name "*reminder*"
grep -r "ReminderNotificationService\|scheduleReminder" lib/ --include="*.dart"

# リマインダーでFCMトークンを foundation から取得しているか（直接 FirebaseMessaging を呼ばない）
grep -r "pushNotificationStateNotifierProvider" lib/ --include="*.dart"
```

### 判定基準
- **Push通知基盤**: foundation の `usePushNotificationToken` / `handleCloudMessage` が app で初期化・接続されていること
- **App Check**: `AppleAppAttestProvider` が本番時に使用されていること（`isNotProduction()` での分岐）
- **Entitlements**: `Runner-Release.entitlements` に `com.apple.developer.devicecheck.appattest-environment = production` が存在すること
- **リマインダー（採用時）**: `scheduleReminder()` に `pushNotificationStateNotifierProvider` から取得したトークンを渡していること。Cloud Functions `processReminders` がデプロイされていること

---

## 🤖 Claude Code への指示

**トークン効率化:**
- 実装されている機能カテゴリのみチェック
- Serena で効率的にファイル検索
- 結果をメモリに保存
