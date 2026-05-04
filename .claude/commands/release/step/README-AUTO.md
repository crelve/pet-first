# 🤖 自動実行コマンド一覧

**完全自動化** - ユーザー入力不要でAIが判断・実行

---

## 🎯 対話型コマンド（NEW）

### `/release:step:01-guided-init` - ガイド付きプロジェクト初期化（対話型）
**所要時間**: 15-25分（対話含む）

**アイデアがある時におすすめ！** シンプルな概要を伝えるだけで、Claudeが対話しながらアイデアを形にします。

```bash
/release:step:01-guided-init
# → Claudeが「どんなアプリを作りたいですか？」から対話開始
```

| 特徴 | 内容 |
|------|------|
| **対話フェーズ** | ターゲット・課題・差別化・マネタイズ・AI活用を質問 |
| **自動フェーズ** | 市場調査→競合分析→要件定義→リポジトリ構築 |
| **カスタマイズ性** | 高（対話で細かく調整可能） |
| **お任せ対応** | 全質問「お任せ」でもOK |

**2つの01コマンドの違い**:
- `01-guided-init`: アイデアがある時（対話で詳細を詰める）
- `01-project-init`: アイデア探索から（完全自動でゼロから生成）

---

## 📊 フロー概要

```
Auto01 → Auto02 → Manual02 → Auto03 → Post-Release
```

| フェーズ | 内容 | コマンド数 |
|---------|------|-----------|
| **Auto01** | プロジェクト初期化 + 証明書（自動化済み） | 6 |
| **Auto02** | 実装環境構築・機能実装・品質確認・法務 | 5 |
| **Manual02** | 収益化・APNs・スクリーンショット | 5 |
| **Auto03** | メタデータ生成・最終リリース | 2 |
| **Post-Release** | メトリクス設定 | 1 |

---

## 🚀 Auto01: プロジェクト初期化（5コマンド）

### `/release:step:01-project-init` - 企画・設計・要件定義
**所要時間**: 8-12分

- ✅ **Phase 1**: アイデア探索・選定（8軸評価で3案選定）
- ✅ **Phase 2**: アプリ名決定・多言語設定（全39言語ARB + iOS）
- ✅ **Phase 3**: 競合深掘り調査（選定3案の直接競合を詳細分析）
- ✅ **Phase 4**: ビジネス設計（最終1案選定・ペルソナ・収益モデル・MVP定義）
- ✅ **Phase 5**: 技術設計（Firebase必須構成・セキュリティ設計）
- ✅ **Phase 6**: 要件定義作成（**ハイブリッド方式** - EARS記法 + 画面別実装仕様）
- ✅ **Phase 7**: 仕様書作成（設計・Mermaid図・実装計画）
- ✅ **Phase 8**: リポジトリ構築（GitHub Private repo作成・ドキュメント移行）

**生成物**: `docs/project/` 配下に完全設計ドキュメント一式

---

### `/release:step:02-brand-color-setup` - ブランドカラー設定
**所要時間**: 3-5分

- 競合カラー分析・差別化戦略
- 色の心理効果を考慮したカラー選定
- `assets/color/colors.xml` 更新
- `docs/project/brand_colors.md` 作成
- ColorName自動生成

---

### `/release:step:03-app-icons-images-guide` - アプリアイコン・画像作成
**所要時間**: 3-5分

- AI画像生成・リサイズ自動化
- iOS全サイズ対応
- App Store・Google Play用素材準備

---

### `/release:step:04-screen-structure` - 画面構成設計
**所要時間**: 5-8分

- 画面一覧・遷移図作成
- ルーティング設計
- 画面テンプレート生成

---

### `/release:step:05-project-deploy` - プロジェクトデプロイ
**所要時間**: 7-10分

- ✅ GitHubリポジトリ作成・セキュリティ対策
- ✅ Firebase開発/本番環境作成
- ✅ パッケージ名・Bundle ID・設定統合
- ✅ 最終調整・整合性検証

**前提条件**: GitHub CLI・Firebase CLI認証済み

---

## 🔧 Auto02: 実装環境構築・機能実装・品質確認・法務（5コマンド）

### `/release:step:06-setup-auto-implementation` - GitHub Issues一括作成・実装環境完全構築
**所要時間**: 5-8分

- GitHub Issues・マイルストーン自動生成
- 実装ガイド・テンプレート作成
- Issue→PR自動生成ワークフロー
- AI実装→テスト→レビュー自動化
- 品質ゲート・CI/CDパイプライン統合

---

### `/release:step:07-implement-issue` - Issue自動実装
**所要時間**: Issue単位で変動

- GitHub Issueの自動実装
- テスト作成・実行
- PR作成・レビュー対応

---

### `/release:step:08-requirements-check` - 要件適合性チェック + アプリ構造完成度検証
**所要時間**: 3-5分 (構造検証含む: 5-8分)

- EARS記法要件との突合
- 未実装機能の特定
- GitHub Issue連携・自動追跡
- **アプリ構造完成度スコア算出 (--verify-structure)**
- **Phase 3完了判定 (完成度95%以上で合格)**
- 品質ゲート達成度チェック

---

### `/release:step:09-quality-rules-check` - 品質ルール準拠確認
**所要時間**: 1-2分

- makeコマンドによる自動化チェック
- 色管理・Barrel Import・多言語化規則
- 静的解析エラー0件を保証

---

### `/release:step:14-release-legal` - 法的要件整備
**所要時間**: 10-15分

- 要件定義ベース法務文書作成
- GDPR・個人情報保護法対応
- App Store・Google Play審査要件準拠
- Notion + Firebase Hostingで公開

---

## 🚀 Auto03: メタデータ生成・最終リリース（2コマンド）

### `/release:step:10-appstore-metadata` - App Storeメタデータ生成
**所要時間**: 5-10分

- 多言語メタデータ自動生成（39言語対応）
- スクリーンショット統合
- App Store Connect最適化

---

### `/release:step:18-release-ios` - iOS App Storeリリース
**所要時間**: 15-20分

- ビルド・アーカイブ自動化
- App Store Connect メタデータ設定
- TestFlight配信サポート
- 審査対応ガイダンス

---

## 💡 基本フロー

```bash
# === Auto01: プロジェクト初期化 ===
/release:step:01-guided-init    # 対話型（アイデアがある時）
# or
/release:step:01-project-init   # 自動（ゼロから探索）

/release:step:02-brand-color-setup
/release:step:03-app-icons-images-guide
/release:step:04-screen-structure
/release:step:05-project-deploy

/release:step:12-ios-certificate-setup  # ASC API自動化済み

# === Auto02: 実装環境構築・機能実装・品質確認・法務 ===
/release:step:06-setup-auto-implementation
/release:step:07-implement-issue
/release:step:08-requirements-check
/release:step:09-quality-rules-check
/release:step:14-release-legal

# === Manual02: 収益化・APNs・スクリーンショット ===
/release:step:11-monetization-complete
/release:step:13-revenuecat-setup
/release:step:15-run-app
/release:step:16-ios-screenshot
/release:step:17-apns-auth-key-setup

# === Auto03: メタデータ生成・最終リリース ===
/release:step:10-appstore-metadata
/release:step:18-release-ios

# === Post-Release: メトリクス設定 ===
/release:step:19-metrics-setup
```

---

## ✨ 特徴

- ⚡ **完全自動**: ユーザー入力一切不要
- 🤖 **AI判断**: 要件定義ベースで最適な実装選択
- 🔄 **エラー自動修復**: 問題検出→解決策実行
- 📊 **進捗可視化**: リアルタイム進捗・完了確認

---

## 📚 参考ドキュメント

- [RELEASE_CHECKLIST.md](../RELEASE_CHECKLIST.md) - 全体フロー・進捗管理
- [PROGRESS_RULES.md](../PROGRESS_RULES.md) - 進捗管理システムルール

---

*これらのコマンドは、要件定義からリリースまでの開発プロセスを完全自動化し、開発者は設計・コードレビューに集中できるようになります。*
