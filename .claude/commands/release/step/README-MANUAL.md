# ✋ 手動実行コマンド・ガイド一覧


**開発者判断必須** - 環境設定・認証・外部サービス連携

## 🛡️ セキュリティ・認証設定

### `/release:step:12-ios-certificate-setup` - iOS証明書セットアップ
**所要時間**: 20-30分  
**手動作業**: Apple Developer Console・Xcode設定

**必要な手動作業:**
1. **Apple Developer登録** - 年額99ドル
2. **Certificate作成** - Development・Distribution証明書
3. **App ID作成** - Bundle Identifier設定
4. **Provisioning Profile作成** - 証明書・デバイス・App ID紐付
5. **Xcode設定** - Signing & Capabilities手動設定

```bash
# Xcodeでプロジェクトを開く
open ios/Runner.xcworkspace

# 手動設定項目:
# - Bundle Identifier: com.yourapp.name[.dev]  
# - Team: Apple Developer Team選択
# - Provisioning Profile: 作成済みプロファイル選択
# - ☐ Automatically manage signing のチェックを外す
```

**なぜ手動？**: Apple Developer登録・支払い・デバイス登録は自動化不可

### `/release:step:13-revenuecat-setup` - RevenueCat In-App Purchase セットアップ
**所要時間**: 30-45分
**手動作業**: RevenueCatダッシュボード・App Store Connect設定

**必要な手動作業:**
1. **RevenueCat アカウント作成** - ダッシュボードでプロジェクト追加
2. **App Store Connect設定** - サブスクリプショングループ・製品ID作成
3. **Shared Secret取得・連携** - App Store Connect ↔ RevenueCat
4. **Entitlement・Offering設定** - 購入商品の構成
5. **環境変数更新** - `dart_env/*.env` にAPIキー設定

**なぜ手動？**: App Store Connect課金設定・RevenueCat連携は外部サービス間の認証が必要

### `/release:step:17-apns-auth-key-setup` - APNs認証キーセットアップ
**所要時間**: 自動（数秒）
**自動化済み**: Playwright スクリプトが未設定アプリを自動検出・設定

**実行方法:**
```bash
python3 ~/kikiki/released/company/engineering/scripts/batch-apns-playwright.py
```
新規アプリは次回スクリプト実行時に自動設定される。手動操作不要。

## 🎨 デザイン・コンテンツ作成

### `/release:step:16-ios-screenshot` - iOSスクリーンショット作成
**所要時間**: 60-90分  
**手動作業**: デザイン・撮影・編集

**必要な手動作業:**
1. **アプリ画面設計** - UI/UXデザイン完成度向上
2. **スクリーンショット撮影** - 複数デバイスサイズ対応
3. **マーケティング素材作成** - App Store最適化
4. **テキストオーバーレイ** - 機能説明・キャッチコピー追加

**サイズ要件:**
- iPhone 6.9": 1290 × 2796 px
- iPhone 6.7": 1290 × 2796 px  
- iPhone 6.5": 1242 × 2688 px
- iPhone 5.5": 1242 × 2208 px
- iPad Pro 12.9": 2048 × 2732 px

**なぜ手動？**: 創造的デザイン・ブランディング判断は人間の領域

## 📋 プロジェクト管理・確認

### `/00-release-checklist` - リリースチェックリスト
**所要時間**: 30-60分  
**手動作業**: 各フェーズの品質確認・承認

**チェック項目:**
- [ ] 要件定義完了・ステークホルダー承認
- [ ] UI/UXデザイン最終確認
- [ ] セキュリティ監査通過
- [ ] パフォーマンステスト完了
- [ ] App Store・Google Play審査準備
- [ ] 法務レビュー完了
- [ ] 運用体制確立

**なぜ手動？**: 品質判断・ビジネス承認は人間の責任領域

## 💼 外部サービス連携（支払い・認証必須）

### Firebase Console 手動設定
**各種サービス有効化:**
- Authentication プロバイダー設定
- Firestore セキュリティルール設定  
- Cloud Functions デプロイ承認
- Firebase Hosting ドメイン設定
- Analytics・Crashlytics確認

### Google Play Console・App Store Connect
**ストア情報手動入力:**
- アプリ説明文・キーワード
- 価格設定・配信地域
- 年齢制限・カテゴリ設定
- アプリ内購入・サブスクリプション設定

### AdMob・収益化設定
**手動承認・設定:**
- AdMob アカウント承認（審査あり）
- 広告ユニット作成・配置確認
- 支払い情報・税務情報設定

---

## 📋 手動作業が必要な理由

### **1. セキュリティ・認証**
- Apple・Google の認証システムは2FA・手動承認必須
- 証明書・キー生成は開発者本人確認が必要
- 支払い・契約情報は法的責任を伴う

### **2. ビジネス判断**
- デザイン・ブランディングは創造的判断
- 価格設定・市場戦略は経営判断
- 法務・コンプライアンスは責任範囲の明確化

### **3. 外部サービス制約**
- Apple・Google の管理画面は自動化を制限
- 審査プロセスは人間による判断
- 支払い・契約は本人確認必須

### **4. 品質保証**
- 最終リリース判断は開発者の責任
- ユーザーエクスペリエンスは主観的評価
- セキュリティ・パフォーマンスは専門知識必要

---

## 🎯 効率的な実行順序

### **Phase 1: 初期セットアップ**
```bash
/release:step:12-ios-certificate-setup    # iOS証明書（20-30分）
```

### **Phase 2: 機能開発後**
```bash
/release:step:11-monetization-complete    # AdMob完全セットアップ（10-15分）
/release:step:13-revenuecat-setup         # RevenueCat IAP セットアップ（30-45分）
/release:step:15-run-app                  # アプリ起動確認（1-2分）
/release:step:17-apns-auth-key-setup      # APNs認証キーセットアップ（15-20分）
```

### **Phase 3: リリース準備**
```bash
/release:step:16-ios-screenshot           # iOSスクリーンショット作成（60-90分）
```

### **並行作業可能:**
- Firebase Console設定（開発中随時）
- App Store Connect情報入力（開発中随時）  
- AdMob設定（収益化機能実装後）

---

## 💡 自動化との連携

**推奨ワークフロー:**
1. **自動化で基盤構築** (`/release:step:01-project-init` → `/release:step:05-project-deploy`)
2. **手動で外部サービス設定** (`/release:step:12-ios-certificate-setup`)
3. **自動化で開発・テスト** (`/release:step:06-setup-auto-implementation` → `/release:step:07-implement-issue` → `/release:step:08-requirements-check` → `/release:step:09-quality-rules-check` → `/release:step:14-release-legal`)
4. **手動でリリース準備** (`/release:step:11-monetization-complete` → `/release:step:13-revenuecat-setup` → `/release:step:15-run-app` → `/release:step:16-ios-screenshot` → `/release:step:17-apns-auth-key-setup`)
5. **自動化で最終リリース** (`/release:step:10-appstore-metadata` → `/release:step:18-release-ios`)

**時間配分:**
- 🤖 **自動化**: 40-60分（技術的作業）
- ✋ **手動作業**: 120-180分（判断・創造・外部連携）
- **総所要時間**: 3-4時間でプロダクション対応完了

---

*手動作業は開発者のスキル・判断が重要な領域です。自動化コマンドと組み合わせることで、効率的かつ高品質なアプリ開発・リリースが実現できます。*