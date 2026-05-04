# 🚀 Step 15: アプリ起動

<!-- PROGRESS_COMMAND_ID: 15-run-app -->
<!-- PROGRESS_PHASE: phase2 -->
<!-- PROGRESS_NAME: アプリ起動確認 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 開発環境5-7分 + 本番環境5-7分

このコマンドは`make run-dev`→`make run-prod`の順序で両方を実行し、失敗した場合は原因を分析・対策して成功するまで繰り返します。

> **Note**: プロジェクト名とFirebase設定は`dart_env/dev.env`と`dart_env/prod.env`から自動的に読み込まれます。

---

## 📋 実行内容

このコマンドは以下を順次自動実行します：

### 1. 開発環境での実行
- 開発環境用アイコン設定
- Firebase開発設定の適用
- `make run-dev` でアプリ起動
- 開発環境での動作確認

### 2. 本番環境での実行
- 本番環境用アイコン設定  
- Firebase本番設定の適用
- `make run-prod` でアプリ起動
- 本番環境での動作確認

### 3. 自動エラー分析・対策
- **Firebase設定ファイル不足**: `firebase_app_id_file.json`と`GoogleService-Info.plist`の自動生成・修復
- **Firebase設定エラー**: Web プラットフォーム設定の自動追加
- **iOS ビルド時間問題**: iOS デバイスでの高速起動に切り替え
- **デバイス接続エラー**: 利用可能デバイスの自動選択
- **依存関係エラー**: プロジェクトのクリーンアップと再セットアップ

### 4. 成功まで繰り返し
- エラーが発生した場合、原因を特定して修正
- 両方の環境でアプリ起動が成功するまで自動的に retry
- 一つの環境で成功したら次の環境に進む

---

## 🎯 環境別確認項目

### 🛠️ 開発環境確認（1番目に実行）

**対象環境**:
- **Firebase Project**: `dart_env/dev.env`の`projectName`-dev
- **Bundle ID (iOS)**: `dart_env/dev.env`の`appId`
- **環境設定ファイル**: `dart_env/dev.env`

**確認項目**:
- [ ] アプリアイコンが開発版になっている
- [ ] Firebase接続が開発環境になっている
- [ ] デバッグ機能が有効になっている
- [ ] 開発者向け設定が表示される
- [ ] テスト広告が表示される

**開発環境での動作確認**:
- Firebase認証が動作する
- Firestoreデータベースにアクセスできる
- Firebase Analyticsが動作する
- プッシュ通知の設定ができる
- デバッグ情報が正常に表示される

### 🏭 本番環境確認（2番目に実行）

**対象環境**:
- **Firebase Project**: `dart_env/prod.env`の`projectName`-prod
- **Bundle ID (iOS)**: `dart_env/prod.env`の`appId`
- **環境設定ファイル**: `dart_env/prod.env`

**確認項目**:
- [ ] アプリアイコンが正式版になっている
- [ ] Firebase接続が本番環境になっている
- [ ] デバッグ機能が無効になっている
- [ ] 本番用の設定が適用されている
- [ ] 本番広告が表示される

**本番環境での動作確認**:
- Firebase認証が動作する
- Firestoreデータベースにアクセスできる
- Firebase Analyticsが動作する
- プッシュ通知が動作する
- 本番広告が表示される

**パフォーマンス確認**:
- [ ] アプリの起動速度
- [ ] 画面遷移の滑らかさ
- [ ] メモリ使用量
- [ ] バッテリー消費量

---

## ⚠️ 重要な注意事項

このコマンドは両方の環境を順次実行するため、以下の点にご注意ください：

### 🛠️ 開発環境（1番目）での注意点
- テスト用のFirebase設定を使用
- テスト広告が表示されます
- デバッグ情報が表示されます
- 開発用APIエンドポイントに接続
- **安全にテストできます**

### 🏭 本番環境（2番目）での注意点
- 🔴 **実際の本番データに接続されます**
- 💰 **実際の課金・広告が発生する可能性があります**
- 📊 **本番Analyticsにテストデータが送信されます**
- 🔐 **本番認証システムを使用します**

**本番環境のセキュリティ**:
- 本番APIキーを使用
- 本番証明書での署名
- 本番ドメインへの接続
- 実際のユーザーデータにアクセス

### 📊 Analytics・テストデータの注意
本番環境でのテスト実行により、Firebase AnalyticsやGoogle Analyticsにテストデータが含まれます。定期的なデータクリーンアップを推奨します。

---

## 🔧 自動対策されるエラー

### ❌ Firebase設定ファイル不足エラー
**問題**: `ios/firebase_app_id_file.json が見つからない`、`ios/Runner/GoogleService-Info.plist が見つからない`

**根本原因**: `make gen-firebase-config` を実行していないか、実行時にエラーが発生した

**自動対策**:
```bash
# 1. Makefileの gen-firebase-config を実行（推奨）
# ⚠️ 本番環境
make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod

# 上記で以下のファイルが自動生成されます:
#   - ios/Runner/GoogleService-Info.plist
#   - ios/firebase_app_id_file.json (GoogleService-Info.plistから自動生成)
#   - lib/firebase_options.dart

# 2. 手動対策（Makefileが使えない場合のみ）
if [ ! -f "ios/firebase_app_id_file.json" ]; then
  echo "Creating ios/firebase_app_id_file.json..."
  # GoogleService-Info.plistから情報を抽出
  GOOGLE_APP_ID=$(grep -A1 "GOOGLE_APP_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs)
  PROJECT_ID=$(grep -A1 "PROJECT_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs)
  GCM_SENDER_ID=$(grep -A1 "GCM_SENDER_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs)

  cat > ios/firebase_app_id_file.json << EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppId & ProjectId for this Firebase project. This file should be committed to source control.",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
fi
```

### ❌ Firebase設定エラー
**開発環境**:
```bash
# 自動実行される対策
# dart_env/dev.envからprojectNameを取得して実行
fvm dart pub global run flutterfire_cli:flutterfire configure --yes --project=$(grep projectName dart_env/dev.env | cut -d'"' -f2)-dev --platforms=ios,web
```

**本番環境**:
```bash
# 自動実行される対策
# dart_env/prod.envからprojectNameを取得して実行
fvm dart pub global run flutterfire_cli:flutterfire configure --yes --project=$(grep projectName dart_env/prod.env | cut -d'"' -f2)-prod --platforms=ios,web
```

### ❌ 依存関係エラー
```bash
# 自動実行される対策
make clean && make setup
```

### ❌ アイコン生成エラー
**開発環境**:
```bash
# 自動実行される対策
make create-launcher-icon FLAVOR=dev
```

**本番環境**:
```bash
# 自動実行される対策
make create-launcher-icon FLAVOR=prod
```

---

## ⚙️ カスタマイズ

### 🛠️ 開発環境の設定 (`dart_env/dev.env`)

```env
# 開発環境用API URL
apiUrl="https://dev-api.example.com"

# 開発環境用AdMob ID（テスト広告）
iOSBannerAdUnitId="ca-app-pub-3940256099942544/2934735716"

# デバッグ設定
enableDebugMode="true"
showDebugInfo="true"
```

### 🏭 本番環境の設定 (`dart_env/prod.env`)

```env
# 本番環境用API URL
apiUrl="https://api.example.com"

# 本番環境用AdMob ID
iOSBannerAdUnitId="ca-app-pub-xxxxxxxxx/xxxxxxxxx"

# 本番設定
enableDebugMode="false"
showDebugInfo="false"
enableAnalytics="true"
enableCrashlytics="true"
```

---

## 🚀 リリース前チェック（本番環境の場合）

### 設定確認
- [ ] 本番Firebase設定が正しい
- [ ] AdMob設定が本番用になっている
- [ ] API URLが本番環境を指している
- [ ] 証明書が本番用になっている

### 機能確認
- [ ] 全ての画面が正常に動作する
- [ ] ユーザー登録・ログインが動作する
- [ ] 課金機能が正常に動作する
- [ ] プッシュ通知が動作する
- [ ] 広告が適切に表示される

### パフォーマンス確認
- [ ] アプリの起動時間が適切
- [ ] メモリリークがない
- [ ] クラッシュが発生しない
- [ ] ネットワーク接続が安定している

---

## 📝 関連コマンド

```bash
# 開発環境で起動（このコマンド）
/run-app --env dev

# 本番環境で起動（このコマンド）
/run-app --env prod

# ログ確認
fvm flutter logs

# デバッグ情報確認
fvm flutter doctor

# プロジェクトのクリーンアップ
make clean && make setup

# 本番ビルド作成
make build-ipa FLAVOR=prod BUILD_NUMBER=1

# 本番リリース
make release-prod-ios BUILD_NUMBER=1
```

---

## 📊 モニタリング（本番環境）

本番環境では以下の監視ツールが有効になります：

- **Firebase Analytics**: ユーザー行動分析
- **Firebase Crashlytics**: クラッシュレポート
- **Firebase Performance**: パフォーマンス監視
- **AdMob**: 広告パフォーマンス
- **App Store Connect/Google Play Console**: アプリストア分析

---

**🎉 このコマンドにより、開発環境→本番環境の順で両方を確実に動作確認でき、リリース前の品質保証が完了します！**

---

## ✅ 完了時アクション

このコマンド完了後、**RELEASE_CHECKLIST.md のステータスを更新**してください：

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md

# 1. チェックボックス更新
- [ ] → - [x] **`/release:step:15-run-app`**

# 2. セクションステータス更新
# Manual02の該当セクションが完了したら:
### **Manual02: 収益化・APNs・スクリーンショット** 🔄 進行中
↓
### **Manual02: 収益化・APNs・スクリーンショット** ✅ 完了
```