# 📊 Step 19: 日次メトリクスレポート設定

<!-- PROGRESS_COMMAND_ID: 19-metrics-setup -->
<!-- PROGRESS_PHASE: phase6 -->
<!-- PROGRESS_NAME: 日次メトリクスレポート設定 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 10-15分

アプリを日次メトリクスレポートシステムに追加し、毎日AM 9:00 (JST) にSlackへDL数・DAU・収益情報を自動通知する設定を行います。

## 🎯 概要

### 取得するメトリクス
- **App Store Connect API**: 新規DL数、再DL数、合計DL数
- **Firebase Analytics**: DAU、新規ユーザー、セッション数、週次比較
- **AdMob API**: 推定収益（円）、インプレッション、クリック、eCPM

### 必要な情報
- App Store App ID（App Store Connect から取得）
- Firebase Analytics Property ID（Firebase Console から取得）
- AdMob App ID（AdMob Console から取得）

---

## 📋 前提条件

- [ ] App Store Connect でアプリが公開済み
- [ ] Firebase プロジェクトが作成済み
- [ ] Firebase Analytics が有効
- [ ] AdMob でアプリが登録済み（収益レポートが必要な場合）
- [ ] 日次レポートシステムがデプロイ済み（初回のみ）

---

## 🚀 設定手順

### Step 1: 必要な ID を収集

#### 1.1 App Store App ID の取得

```
App Store Connect での確認:
1. App Store Connect (https://appstoreconnect.apple.com) にログイン
2. 「マイ App」→ 対象アプリを選択
3. 「アプリ情報」→「一般情報」
4. Apple ID を確認（例: 6740014456）

📋 App Store App ID: _______________
```

#### 1.2 Firebase Analytics Property ID の取得

```
Firebase Console での確認:
1. Firebase Console (https://console.firebase.google.com) にログイン
2. プロジェクトを選択
3. 左メニュー「アナリティクス」→「Dashboard」
4. 左下の歯車アイコン → 「アナリティクスの設定」
5. プロパティ ID を確認（例: 123456789）

📋 Analytics Property ID: _______________
```

#### 1.3 AdMob App ID の取得

```
AdMob Console での確認:
1. AdMob Console (https://admob.google.com) にログイン
2. 左メニュー「アプリ」→ 対象アプリを選択
3. 「アプリの設定」
4. アプリ ID を確認（例: ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY）

📋 AdMob App ID: _______________
```

---

### Step 2: Firestore にアプリを登録

#### 2.1 Firebase Console から登録

```
Firestore Database での登録:
1. Firebase Console → Firestore Database
2. 「metrics_apps」コレクションを選択
3. 「ドキュメントを追加」をクリック
4. ドキュメント ID: 自動生成 または アプリ識別子

📝 フィールド設定:
   appName: "アプリ名"
   appStoreAppId: "取得したApp Store App ID"
   analyticsPropertyId: "取得したAnalytics Property ID"
   admobAppId: "取得したAdMob App ID"（オプション）
   enabled: true
```

#### 2.2 スクリプトから登録（推奨）

```bash
# functions ディレクトリに移動
cd functions

# アプリ追加スクリプトを実行
./scripts/add-app.sh

# 対話形式で入力
# App Name: アプリ名
# App Store App ID: 6740014456
# Analytics Property ID: 123456789
# AdMob App ID (optional): ca-app-pub-xxx~yyy
```

---

### Step 3: Firebase Analytics の権限設定

```
サービスアカウントに Analytics 閲覧権限を付与:

1. Google Analytics (https://analytics.google.com) にログイン
2. 左下「管理」→ 対象プロパティの「プロパティのアクセス管理」
3. 「+」→「ユーザーを追加」
4. メールアドレスを入力:
   513162290068-compute@developer.gserviceaccount.com
5. 役割: 「閲覧者」を選択
6. 「追加」をクリック
```

---

### Step 4: 動作確認

#### 4.1 手動実行でテスト

```bash
# Cloud Scheduler ジョブを手動実行
gcloud scheduler jobs run firebase-schedule-dailyMetricsReport-us-central1 \
  --location=us-central1 \
  --project=kikiki-flutter-template-prod
```

#### 4.2 Slack 通知を確認

```
確認項目:
- [ ] Slack チャンネルに通知が届いた
- [ ] アプリ名が正しく表示されている
- [ ] DL数が表示されている（0でも可）
- [ ] DAU/セッションが表示されている
- [ ] 収益情報が表示されている（AdMob設定時）
```

#### 4.3 ログを確認

```bash
# Cloud Functions ログを確認
gcloud functions logs read dailyMetricsReport \
  --project=kikiki-flutter-template-prod \
  --limit=20 \
  --gen2
```

---

## ✅ 完了チェックリスト

### ID 収集
- [ ] App Store App ID を取得済み
- [ ] Firebase Analytics Property ID を取得済み
- [ ] AdMob App ID を取得済み（オプション）

### Firestore 登録
- [ ] metrics_apps コレクションにアプリを追加済み
- [ ] enabled: true に設定済み

### 権限設定
- [ ] Firebase Analytics にサービスアカウントを追加済み

### 動作確認
- [ ] 手動実行でテスト済み
- [ ] Slack 通知が正常に届くことを確認済み
- [ ] 全メトリクスが表示されることを確認済み

---

## 📊 Slack 通知サンプル

```
📊 Daily Metrics Report
🎯 アプリ: アプリ名
📅 日付: 2025-12-10

📥 新規DL: 15
🔄 再DL: 3
📲 合計DL: 18
👥 DAU: 150

🆕 新規ユーザー: 12
📱 セッション数: 320

💰 推定収益: ¥1,234
👁️ インプレッション: 5,678
👆 クリック: 45
📊 eCPM: ¥217

週次比較 (DAU): 📈 +12% vs 先週
```

---

## 🆘 トラブルシューティング

### Q: 通知が届かない

```bash
# 1. Cloud Functions ログを確認
gcloud functions logs read dailyMetricsReport --project=kikiki-flutter-template-prod --limit=50 --gen2

# 2. Firestore にアプリが登録されているか確認
# Firebase Console → Firestore → metrics_apps

# 3. enabled: true になっているか確認
```

### Q: DL数が取得できない

```
確認項目:
- App Store App ID が正しいか
- App Store Connect API の認証情報が設定されているか
- アプリが公開されてから24時間以上経過しているか
```

### Q: DAU/セッションが0になる

```
確認項目:
- Analytics Property ID が正しいか
- サービスアカウントに閲覧権限があるか
- 該当日にアプリ利用があったか
```

### Q: 収益情報が表示されない

```
確認項目:
- AdMob App ID が Firestore に設定されているか
- AdMob API の認証情報（OAuth）が設定されているか
- 該当日に広告インプレッションがあったか
```

---

## 🔧 システム概要

### アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                    Cloud Scheduler                          │
│                  (毎日 AM 9:00 JST)                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│               Cloud Functions (2nd Gen)                     │
│                  dailyMetricsReport                         │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
┌───────────┐  ┌───────────┐  ┌───────────┐
│ App Store │  │ Firebase  │  │  AdMob    │
│ Connect   │  │ Analytics │  │   API     │
│   API     │  │   API     │  │           │
└───────────┘  └───────────┘  └───────────┘
        │             │             │
        └─────────────┼─────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   Slack Webhook                             │
│              (日次レポート通知)                               │
└─────────────────────────────────────────────────────────────┘
```

### 関連ファイル

```
functions/
├── src/
│   ├── scheduled/
│   │   └── dailyMetricsReport.ts    # メインの Scheduled Function
│   └── services/
│       ├── appConfig.ts             # Firestore アプリ設定管理
│       ├── appStoreConnect.ts       # App Store Connect API
│       ├── firebaseAnalytics.ts     # Firebase Analytics API
│       ├── admob.ts                 # AdMob API
│       └── slack.ts                 # Slack 通知
├── scripts/
│   ├── add-app.sh                   # アプリ追加スクリプト
│   └── list-apps.sh                 # アプリ一覧スクリプト
└── README.md                        # セットアップガイド
```

---

## 📚 参考リンク

- [App Store Connect](https://appstoreconnect.apple.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Analytics](https://analytics.google.com/)
- [AdMob Console](https://admob.google.com/)
- [Cloud Scheduler](https://console.cloud.google.com/cloudscheduler)

---

## ✅ 完了時アクション

このコマンド完了後、**RELEASE_CHECKLIST.md のステータスを更新**してください：

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md

# 1. チェックボックス更新
- [ ] → - [x] **`/release:step:19-metrics-setup`**

# 2. セクションステータス更新（最初の完了時のみ）
### **Post-Release: メトリクス設定** (1コマンド) ⬜ 未着手
↓
### **Post-Release: メトリクス設定** (1コマンド) ✅ 完了
```
