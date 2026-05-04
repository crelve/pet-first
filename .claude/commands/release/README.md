# 🚀 リリースコマンド総合ガイド

**企画から本番リリースまでの完全ワークフロー**

## 📋 コマンド分類

### 🤖 [自動実行コマンド](./step/README-AUTO.md)
**完全自動化** - ユーザー入力不要でAIが判断・実行

| コマンド | 所要時間 | 内容 | 前提条件 |
|----------|----------|------|----------|
| `/release:step:01-guided-init` | 15-25分 | **対話型**企画→設計→要件定義 | - |
| `/release:step:01-project-init` | 8-12分 | **自動**企画→設計→要件定義 | - |
| `/release:step:02-brand-color-setup` | 3-5分 | ブランドカラー設定 | 01完了 |
| `/release:step:03-app-icons-images-guide` | 3-5分 | アイコン・画像作成 | 02完了 |
| `/release:step:04-screen-structure` | 5-10分 | 画面構成設計 | 03完了 |
| `/release:step:05-project-deploy` | 7-10分 | リポジトリ→Firebase→設定 | 04完了 |
| `/release:step:06-setup-auto-implementation` | 5-8分 | GitHub Issues一括作成・実装環境完全構築 | 05完了 |
| `/release:step:07-implement-issue` | variable | Issue自動実装 | 07完了 |
| `/release:step:08-requirements-check` | 1-2分 | 要件適合性チェック + アプリ構造完成度検証 | 実装進行中 |
| `/release:step:09-quality-rules-check` | 2-3分 | 品質ルール準拠確認 | 10完了 |
| `/release:step:14-release-legal` | 5-7分 | 法的要件整備 | 11完了 |
| `/release:step:10-appstore-metadata` | 5-10分 | App Storeメタデータ生成 | 全準備完了 |
| `/release:step:18-release-ios` | 15-20分 | iOS App Storeリリース | 17完了 |

**合計自動化時間**: 40-60分

### ✋ [手動実行コマンド](./step/README-MANUAL.md)
**開発者判断必須** - 環境設定・認証・外部サービス連携

| コマンド | 所要時間 | 内容 | 手動理由 |
|----------|----------|------|----------|
| `/release:step:12-ios-certificate-setup` | 20-30分 | iOS証明書・Xcode設定 | Apple認証 |
| `/release:step:11-monetization-complete` | 10-15分 | AdMob完全セットアップ | ビジネス設定 |
| `/release:step:13-revenuecat-setup` | 30-45分 | RevenueCat IAPセットアップ | 外部サービス連携 |
| `/release:step:15-run-app` | 1-2分 | アプリ起動確認 | 実機確認 |
| `/release:step:16-ios-screenshot` | 60-90分 | iOSスクリーンショット作成 | 創造的デザイン |
| `/release:step:17-apns-auth-key-setup` | 自動 | APNs認証キーセットアップ | Playwright自動化済み |

**合計手動時間**: 150-225分

## 🎯 推奨実行フロー

### **Phase 1: プロジェクト初期化** (25-40分)
```bash
# 1. 企画・設計・要件定義（どちらか選択）
/release:step:01-guided-init                     # 15-25分（対話型：アイデアがある時）
# or
/release:step:01-project-init                    # 8-12分（自動：ゼロから探索）

# 2. 完全自動 - ブランドカラー設定
/release:step:02-brand-color-setup               # 3-5分

# 3. 完全自動 - アイコン・画像作成
/release:step:03-app-icons-images-guide          # 3-5分

# 4. 完全自動 - 画面構成設計
/release:step:04-screen-structure                # 5-10分

# 5. 完全自動 - 新リポジトリ・Firebase環境構築
/release:step:05-project-deploy                  # 7-10分

# 6. 手動設定 - iOS開発環境
/release:step:12-ios-certificate-setup         # 20-30分 (並行作業可能)
```

### **Phase 2: 実装環境構築・機能実装・品質確認・法務** (18-27分)
```bash
# 7. 完全自動 - GitHub Issues一括作成・実装環境完全構築
/release:step:06-setup-auto-implementation       # 5-8分

# 8. AI自動実装 - Issue自動実装
/release:step:07-implement-issue                 # 可変時間

# 9. 手動設定 - AdMob完全セットアップ
/release:step:11-monetization-complete         # 10-15分

# 10. 完全自動 - 要件適合性チェック + アプリ構造完成度検証
/release:step:08-requirements-check              # 1-2分

# 11. 完全自動 - 品質ルール準拠確認
/release:step:09-quality-rules-check             # 2-3分

# 12. 完全自動 - 法的要件整備
/release:step:14-release-legal                   # 5-7分
```

### **Phase 3: 収益化・APNs・スクリーンショット** (116-182分)
```bash
# 13. 完全自動 - App Storeメタデータ生成
/release:step:10-appstore-metadata               # 5-10分

# 14. 手動設定 - RevenueCat IAPセットアップ
/release:step:13-revenuecat-setup              # 30-45分

# 15. 手動確認 - アプリ起動確認
/release:step:15-run-app                       # 1-2分

# 16. 手動作業 - iOSスクリーンショット作成
/release:step:16-ios-screenshot                # 60-90分

# 17. 手動設定 - APNs認証キーセットアップ
/release:step:17-apns-auth-key-setup           # 15-20分
```

### **Phase 4: 最終リリース** (15-20分)
```bash
# 18. 完全自動 - iOS App Storeリリース
/release:step:18-release-ios                     # 15-20分
```

## ⏱️ 総所要時間

| フェーズ | 自動化時間 | 手動時間 | 合計時間 |
|----------|------------|----------|----------|
| **Phase 1: 初期化** | 25-38分 | 20-30分 | 45-68分 |
| **Phase 2: 実装・品質・法務** | 18-27分 | - | 18-27分 |
| **Phase 3: 収益化・準備** | - | 116-182分 | 116-182分 |
| **Phase 4: リリース** | 20-30分 | - | 20-30分 |
| **合計** | **63-95分** | **136-212分** | **199-307分** |

**実質開発時間**: 3.5-5時間でプロダクション対応完了

## 🛡️ トラブルシューティング

### **よくある問題と解決策:**

**🔐 認証エラー**
```bash
# GitHub CLI
gh auth login --web

# Firebase CLI  
firebase login
firebase login:list
```

**🍎 iOS証明書問題**
```bash
# Fastlane match でチーム共有
fastlane match development
fastlane match appstore
```

**🔥 Firebase制限**
```bash
# プロジェクトID制約: 6-30文字、小文字・ハイフンのみ
firebase projects:create your-short-name-dev
```

## 💡 成功のポイント

### **1. 事前準備**
- [ ] Apple Developer Program ($99/年)
- [ ] Google Play Developer ($25一回)
- [ ] GitHub CLI・Firebase CLI認証
- [ ] 必要な画像素材準備

### **2. 実行タイミング**  
- **平日昼間**: Apple・Google審査が早い
- **リリース前**: 十分な品質チェック時間確保
- **段階的実行**: 一度に全てではなく、フェーズ別に検証

### **3. 品質管理**
- 各フェーズ完了時の動作確認
- 手動チェックリストの徹底遵守
- セキュリティ・パフォーマンス要件の確認

---

**📱 結果**: 企画からApp Store配信まで、3-4時間の効率的な開発・リリースフローを実現

---

## 📈 [運用フェーズコマンド](./operations/README.md)
**リリース後の継続運用** - KPIレビュー・改善サイクル・グロース施策

| コマンド | 実行頻度 | 内容 |
|----------|----------|------|
| `/release:operations:kpi-daily` | 毎日 | 日次KPIレビュー |
| `/release:operations:kpi-weekly` | 週1回 | 週次KPIレビュー |
| `/release:operations:kpi-monthly` | 月1回 | 月次KPIレビュー |
| `/release:operations:dau-trend {appId}` | 随時 | DAUトレンド確認 |
| `/release:operations:app-detail {appId}` | 随時 | アプリ詳細メトリクス |
| `/release:operations:02-aso-optimization` | 週1〜月1回 | ASO最適化 |
| `/release:operations:03-ab-testing` | 随時 | A/Bテスト管理 |
| `/release:operations:04-user-feedback` | 毎日〜月1回 | ユーザーフィードバック分析 |
| `/release:operations:05-competitor-watch` | 週1〜四半期 | 競合監視 |

### **運用フェーズ: リリース後の継続改善**
```bash
# 日次KPIレビュー
/release:operations:kpi-daily

# 週次KPIレビュー
/release:operations:kpi-weekly

# 月次KPIレビュー
/release:operations:kpi-monthly

# 個別アプリのDAUトレンド
/release:operations:dau-trend crelve-jh-science

# 個別アプリの詳細メトリクス
/release:operations:app-detail crelve-jh-science
```

---

**🎯 次のステップ**: プロジェクトの状況に応じて[自動実行](./step/README-AUTO.md)または[手動実行](./step/README-MANUAL.md)ガイドを参照してください。リリース後は[運用フェーズ](./operations/README.md)でKPI管理・改善サイクルを回してください。