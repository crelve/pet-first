# Cloud Functions - Daily Metrics Report

毎日AM 9:00 (JST) にApp StoreのDL数とDAUをSlackに通知するCloud Functionです。

## 機能概要

| 指標 | ソース | 説明 |
|------|--------|------|
| 新規DL | App Store Connect API | 新規ダウンロード数 |
| 再DL | App Store Connect API | 再ダウンロード数 |
| DAU | Firebase Analytics | Daily Active Users |
| 新規ユーザー | Firebase Analytics | 新規登録ユーザー数 |
| セッション数 | Firebase Analytics | アプリ起動回数 |
| 週次比較 | Firebase Analytics | 先週比DAU変化率 |

## セットアップ手順

### 1. App Store Connect APIキーの発行

1. [App Store Connect](https://appstoreconnect.apple.com/) にログイン
2. **ユーザーとアクセス** → **キー** → **App Store Connect API**
3. **新規キーを生成** をクリック
4. 名前を入力し、アクセス権限は **Sales and Trends** を選択
5. 生成されたキーをダウンロード（`.p8`ファイル）

**取得する情報:**
- **Issuer ID**: キーページ上部に表示
- **Key ID**: 生成したキーのID
- **Private Key**: ダウンロードした`.p8`ファイルの内容
- **Vendor Number**: [売上とトレンド](https://appstoreconnect.apple.com/trends/reports)で確認
- **App ID**: アプリの詳細ページURLから確認（例: `apps/123456789`の数字部分）

### 2. Firebase Analytics Data APIの有効化

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. Firebaseプロジェクトを選択
3. **APIとサービス** → **ライブラリ**
4. **Google Analytics Data API** を検索して有効化

**GA4プロパティIDの取得:**
1. [Google Analytics](https://analytics.google.com/) にアクセス
2. **管理** → **プロパティ設定**
3. **プロパティID** をコピー（数字のみ）

### 3. Slack Incoming Webhookの作成

1. [Slack API](https://api.slack.com/apps) にアクセス
2. **Create New App** → **From scratch**
3. **Incoming Webhooks** を有効化
4. **Add New Webhook to Workspace** でチャンネルを選択
5. 生成されたWebhook URLをコピー

### 4. Firebase Secretsの設定

```bash
cd functions

# Slack Webhook URL
firebase functions:secrets:set SLACK_WEBHOOK_URL
# 入力: https://hooks.slack.com/services/XXXX/XXXX/XXXX

# App Store Connect API
firebase functions:secrets:set APP_STORE_ISSUER_ID
# 入力: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

firebase functions:secrets:set APP_STORE_KEY_ID
# 入力: XXXXXXXXXX

firebase functions:secrets:set APP_STORE_PRIVATE_KEY
# 入力: -----BEGIN PRIVATE KEY-----\nXXXXXX...\n-----END PRIVATE KEY-----
# 注意: 改行は\nに置換して1行で入力

firebase functions:secrets:set APP_STORE_VENDOR_NUMBER
# 入力: 12345678

firebase functions:secrets:set APP_STORE_APP_ID
# 入力: 123456789

# Firebase Analytics
firebase functions:secrets:set ANALYTICS_PROPERTY_ID
# 入力: 123456789

# アプリ名（Slack通知のタイトル用）
firebase functions:secrets:set APP_NAME
# 入力: MyApp
```

### 5. 依存関係のインストールとデプロイ

```bash
cd functions
npm install
npm run deploy
```

## ファイル構成

```
functions/
├── src/
│   ├── index.ts                         # エントリーポイント
│   ├── scheduled/
│   │   └── dailyMetricsReport.ts       # 日次レポート関数
│   └── services/
│       ├── appStoreConnect.ts          # App Store Connect API
│       ├── firebaseAnalytics.ts        # Firebase Analytics API
│       └── slack.ts                    # Slack通知
├── package.json
└── tsconfig.json
```

## 手動実行（テスト用）

Firebase Consoleから手動でFunctionを実行できます：

1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. **Functions** → **dailyMetricsReport**
3. **テスト関数** をクリック

または、Firebase CLIで：

```bash
firebase functions:shell

# シェル内で
dailyMetricsReport()
```

## トラブルシューティング

### App Store Connect APIでデータが取得できない

- **原因**: Sales Reportは2-3日遅れで生成されます
- **対応**: 最新のデータが必要な場合はAnalytics APIを使用

### Firebase Analytics APIでエラーが発生

- **確認**: Google Analytics Data APIが有効になっているか
- **確認**: プロパティIDが正しいか（GA4のプロパティID）

### Slack通知が届かない

- **確認**: Webhook URLが正しいか
- **確認**: Slackアプリがチャンネルに追加されているか

## Slack通知サンプル

```
📊 MyApp Daily Report
📅 2024-01-15
─────────────────────
📥 新規DL     🔄 再DL
150          45

📲 合計DL    👥 DAU
195          1,234
─────────────────────
🆕 新規ユーザー  📱 セッション
89              3,456

週次比較 (DAU): 📈 +12.5% vs 先週
```

## 料金について

- **Cloud Functions**: Blaze (従量課金) プランが必要
- **スケジュール実行**: 1日1回 = 月30回程度（無料枠内）
- **App Store Connect API**: 無料
- **Firebase Analytics Data API**: 無料（クォータあり）
