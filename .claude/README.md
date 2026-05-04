# flutter-template Claude Code Cookbook

最新の Flutter 開発向けに設計された Claude Code 専用の包括的なコマンドコレクション、AI エージェント役割、スキルシステム、および自動化システム。プロダクション品質のモバイルアプリを企画から App Store 配信まで 3-4 時間で実現します。

## Overview

この Claude Code Cookbook は Flutter/Dart 開発のための特殊ツールを提供し、プロジェクト分析用のカスタムコマンド、様々な開発観点に特化した AI エージェント役割、Apple Design準拠のUIスキル、そしてコード品質とプロジェクトガイドライン遵守のための自動化フックを含みます。

## Features

### 🎯 Custom Commands (87個の専門コマンド)

#### 🚀 リリース自動化システム（21個）
**企画からApp Store配信まで完全自動化** - 最新AI駆動開発システム

**📋 [完全リリースフロー](./commands/release/README.md)** - 3-4時間で本番リリース完了
- **自動実行コマンド** (15個): AI判断で完全自動実行
- **手動実行コマンド** (6個): 認証・外部サービス連携
- **所要時間**: 自動化40-60分 + 手動120-180分

#### 📋 開発支援コマンド

**Flutter専用最適化 (7個):**
- `/flutter-analyze` - 包括的 Flutter/Dart コード解析
- `/fix-error` - Flutter/Dart エラー解析・修正
- `/check-ready` - コード品質検証（必須チェック）
- `/safe-push` - 安全なgit push
- `/feature-spec` - 機能仕様書生成
- `/update-flutter-deps` - Flutter 依存関係管理
- `/implement-security` - セキュリティ実装

**Git/GitHub統合 (6個):**
- `/pr-review` - Flutter特化プルリク審査
- `/pr-create` - プルリクエスト自動作成
- `/pr-list` - プルリクエスト一覧
- `/pr-issue` - Issue連携
- `/pr-feedback` - PRフィードバック対応
- `/pr-auto-update` - PR自動更新

**ユーティリティ (7個):**
- `/quality-gate` - 品質ゲート検証
- `/test-coverage` - テストカバレッジ解析
- `/tech-debt` - 技術的負債分析
- `/serena` - Serena MCP統合ガイド
- `/design-patterns` - デザインパターン適用
- `/implementation-guard` - 実装ガード
- `/update-dart-doc` - Dart Doc更新

**分析 (3個):**
- `/conversion-funnel` - コンバージョン分析
- `/retention-analysis` - リテンション分析
- `/review-analysis` - レビュー分析

**マーケティング (3個):**
- `/aso-optimization` - ASO最適化
- `/user-acquisition` - ユーザー獲得戦略
- `/promotion-strategy` - プロモーション戦略

**AI支援 (1個):**
- `/role` - AI エージェント役割切り替え

### 🤖 AI エージェント役割システム（10役割）
**Flutter/モバイル開発特化:**
- `/role security` - Flutter/モバイルセキュリティ専門家
- `/role architect` - Flutter アプリアーキテクチャレビュアー
- `/role flutter` - Flutter/Dart ベストプラクティス専門家
- `/role mobile` - モバイルアプリ開発専門家
- `/role performance` - Flutter パフォーマンス最適化専門家

**品質保証特化:**
- `/role test` - Flutter テスト戦略（Widget/統合/Golden テスト）
- `/role analyzer` - Flutter エラー解析・デバッグ専門家
- `/role reviewer` - Flutter コードレビュー専門家
- `/role qa` - Flutter 品質保証・テスト専門家
- `/role release` - リリース管理・デプロイメント専門家

### 🎨 スキルシステム（2個）
**Apple Design準拠のUI開発:**
- **apple-design** - Apple Human Interface Guidelines準拠のUI設計
  - カラーシステム、タイポグラフィ、コンポーネント
  - アニメーション、レイアウト・余白の詳細リファレンス
- **claude-skill-creator** - カスタムスキル作成ガイド

### 🔧 自動化スクリプト
**コード品質自動維持:**
- **statusline.js** - ステータスライン管理

### 🌍 Multi-language Support
- Japanese (ja) - Default
- English (en)

## インストール

### オプション 1: グローバル Claude ディレクトリにインストール（推奨）
```bash
# 全プロジェクトで利用（~/.claude/ へ）
./.claude/scripts/install.sh --to-global

# 英語版を使用する場合
./.claude/scripts/install.sh --to-global -l en
```

### オプション 2: グローバルからプロジェクトへインストール
```bash
# グローバル Claude 設定をこのプロジェクトにコピー
./.claude/scripts/install.sh --from-global
```

### オプション 3: ローカルプロジェクトのみ
```bash
# このプロジェクトのみにインストール
./.claude/scripts/install.sh

# 全オプションを表示
./.claude/scripts/install.sh --help
```

## 使用方法

### コマンド実行
Claude Code でスラッシュコマンドを使用:
```
# 🚀 完全自動化リリースフロー
/01-project-init        # プロジェクト初期化
/05-project-deploy      # リポジトリ・Firebase構築
/18-release-ios         # iOS App Store 自動リリース

# 📋 開発支援
/flutter-analyze        # Flutter コード解析
/check-ready           # コード品質検証
/test-coverage         # テスト解析
/fix-error             # エラー修正
```

### AI エージェント役割
Claude を Flutter 専門家モードに切り替え:
```
/role security         # Flutter/モバイルセキュリティ解析
/role flutter          # Flutter ベストプラクティス
/role mobile           # モバイルアプリ開発
/role architect        # Flutter アーキテクチャレビュー
/role performance      # Flutter パフォーマンス最適化
/role test            # Flutter テスト戦略
/role analyzer        # Flutter エラー解析
/role reviewer        # Flutter コードレビュー
/role qa              # Flutter 品質保証
/role release         # リリース管理
```

### Hooks
Hooks automatically activate during Flutter development:
- **Dart file creation** → dartdoc comment prompts
- **Git commits** → Message quality validation
- **Code changes** → Flutter project compliance checks
- **Text editing** → Japanese formatting
- **Long sessions** → Break reminders

## Flutter テンプレート統合

この cookbook は本 Flutter テンプレートプロジェクト専用に最適化されています:

### テンプレート特化機能
- **Makefile 統合**: `make` ターゲットとの完全連携
- **Firebase 設定**: Firebase セットアップ完全自動化
- **マルチフレーバービルド**: 開発・本番環境サポート
- **Widget 設計**: Flutter Widget ベストプラクティス
- **状態管理**: Riverpod/Hooks 最適化
- **プロジェクト構造**: テンプレート規約準拠
- **リリース自動化**: App Store/Play Store 完全自動デプロイ
- **flutter_foundation統合**: 共通コンポーネント・ユーティリティの活用

### テンプレート専用コマンド
```bash
# 🚀 完全リリースフロー（最新版）
/01-project-init          # 企画→設計→要件定義（5-8分）
/05-project-deploy        # リポジトリ→Firebase構築（7-10分）
/18-release-ios           # iOS App Store 自動リリース（15-20分）

# 📋 開発・品質管理
/flutter-analyze          # 包括的コード解析
/check-ready             # コード品質検証（必須）
/quality-gate            # 品質ゲート検証
/test-coverage           # テストカバレッジ解析
```

## File Structure

```
.claude/
├── commands/                    # カスタムスラッシュコマンド（87個）
│   ├── release/                # 🚀 リリース自動化システム（21個）
│   │   ├── README.md           # 完全リリースフローガイド
│   │   └── step/               # 全ステップコマンド（19個）
│   │       ├── 01-project-init.md    # プロジェクト初期化
│   │       ├── 05-project-deploy.md  # 環境構築
│   │       ├── 09-requirements-check.md # 要件チェック
│   │       └── 18-release-ios.md     # iOS リリース
│   ├── flutter/                # Flutter開発コマンド（7個）
│   ├── git/                    # Git/GitHub統合（6個）
│   ├── utils/                  # ユーティリティコマンド（7個）
│   ├── analysis/               # 分析コマンド（3個）
│   ├── marketing/              # マーケティングコマンド（3個）
│   └── ai/                     # AI関連コマンド（1個）
├── agents/roles/               # AI エージェント役割（10個）
│   ├── security.md             # セキュリティ専門家
│   ├── architect.md            # アーキテクチャレビュアー
│   ├── flutter.md              # Flutter専門家
│   ├── performance.md          # パフォーマンス専門家
│   ├── test.md                 # テスト専門家
│   ├── mobile.md               # モバイル開発専門家
│   ├── analyzer.md             # エラー解析専門家
│   ├── reviewer.md             # コードレビュー専門家
│   ├── qa.md                   # 品質保証専門家
│   └── release.md              # リリース管理専門家
├── skills/                     # スキルシステム（2個）
│   ├── apple-design/           # Apple Design準拠UI
│   │   ├── SKILL.md            # メインスキルファイル
│   │   └── references/         # 詳細リファレンス
│   │       ├── colors.md       # カラーシステム
│   │       ├── typography.md   # タイポグラフィ
│   │       ├── components.md   # UIコンポーネント
│   │       ├── animations.md   # アニメーション
│   │       └── spacing.md      # レイアウト・余白
│   └── claude-skill-creator/   # スキル作成ガイド
│       └── SKILL.md
├── scripts/                    # 自動化スクリプト
├── docs/                       # 包括的ドキュメント
│   ├── README.md               # ドキュメントガイド
│   ├── rules/                  # コーディング規約・ルール
│   │   ├── project_rules.md    # プロジェクトルール（必読）
│   │   ├── coding_rule.md      # コーディング規約
│   │   ├── naming_conventions.md # 命名規則
│   │   └── import_ordering_guide.md # インポート順序
│   └── templates/              # プロジェクトテンプレート
├── settings.json               # プロジェクト固有設定
├── settings.local.json         # ローカル設定
├── statusline.js               # ステータスライン管理
└── README.md                   # このファイル

[プロジェクト構造]
├── docs/project/               # プロジェクト固有ドキュメント
│   ├── history.json            # プロジェクト履歴（自動生成）
│   ├── requirements.md         # 要件定義
│   ├── design.md               # 設計ドキュメント
│   ├── tasks.md                # 実装タスク
│   ├── app_branding.md         # ブランディング
│   └── tech_design.md          # 技術設計
└── lib/l10n/                   # Flutter アプリ多言語サポート（39言語）
    ├── app_ja.arb              # 日本語（デフォルト）
    ├── app_en.arb              # 英語
    ├── app_zh.arb              # 中国語
    ├── app_ko.arb              # 韓国語
    ├── app_es.arb              # スペイン語
    ├── app_fr.arb              # フランス語
    ├── app_it.arb              # イタリア語
    ├── app_de.arb              # ドイツ語
    ├── app_pt.arb              # ポルトガル語
    └── app_hi.arb              # ヒンディー語
```

## Project Configuration

### settings.json Features
- **Flutter/Dart permissions**: Allows `make`, `fvm flutter`, `fvm dart` commands
- **Firebase integration**: Supports Firebase CLI commands
- **Project-specific paths**: Configured for this template structure
- **Hook automation**: Pre/post tool execution hooks
- **Environment variables**: Flutter development paths

### Makefile Integration
The cookbook works seamlessly with the project's Makefile:
```bash
make setup              # Project initialization
make run-dev           # Development environment
make run-prod          # Production environment
make test              # Run tests
make build-ipa         # Build iOS
make check-ready       # Code quality check (required before PR)
```

## Management

### Backup and Restore
```bash
# Create backup before changes
./.claude/scripts/install.sh --backup

# Restore from backup
./.claude/scripts/install.sh --restore

# Uninstall completely (with backup)
./.claude/scripts/install.sh --uninstall
```

### Language Switching
```bash
# Switch to English
./.claude/scripts/install.sh --to-global -l en

# Switch to Japanese (default)
./.claude/scripts/install.sh --to-global -l ja
```

### Global vs Project Installation
```bash
# Install project configuration globally (for all projects)
./.claude/scripts/install.sh --to-global

# Install global configuration to project
./.claude/scripts/install.sh --from-global
```

## 開発ワークフロー

### 1. プロジェクト初期化（15-20分）
```bash
# Claude Code 初期化
./.claude/scripts/install.sh --to-global

# 🚀 完全自動化フロー
/01-project-init          # 企画・要件定義
/05-project-deploy        # リポジトリ・Firebase構築
```

### 2. 開発フェーズ
```bash
# コード品質解析
/flutter-analyze

# セキュリティレビュー
/role security

# パフォーマンス最適化
/role performance

# 要件整合性チェック
/09-requirements-check
```

### 3. コードレビュー・品質管理
```bash
# プルリクレビュー
/pr-review

# コード品質検証（必須）
/check-ready

# 品質ゲート
/quality-gate
```

### 4. テスト・リリース（15-20分）
```bash
# テストカバレッジ解析
/test-coverage

# アーキテクチャレビュー
/role architect

# 🚀 iOS App Store 自動リリース
/18-release-ios
```

## Serena MCP 統合

このプロジェクトは Serena MCP を活用したインテリジェントなコード操作をサポートします：

### 探索ツール（コード理解時）
- `mcp__serena__get_symbols_overview` - ファイル構造把握
- `mcp__serena__find_symbol` - シンボル検索
- `mcp__serena__find_referencing_symbols` - 参照検索
- `mcp__serena__search_for_pattern` - パターン検索

### 編集ツール（コード変更時）
- `mcp__serena__replace_symbol_body` - シンボル単位編集
- `mcp__serena__insert_after_symbol` / `insert_before_symbol` - コード挿入
- `mcp__serena__rename_symbol` - シンボル名一括変更

### メモリツール（知識永続化）
- `mcp__serena__read_memory` / `write_memory` - プロジェクト知識管理

詳細は `/utils:serena` コマンドを参照してください。

## Troubleshooting

### Common Issues

1. **Commands not found**
   - Restart Claude Code
   - Run: `./.claude/scripts/install.sh --to-global`
   - Verify: `ls ~/.claude/commands/`

2. **Hooks not working**
   - Check permissions: `ls -la .claude/scripts/`
   - Make executable: `chmod +x .claude/scripts/*.sh`
   - Verify settings: `cat .claude/settings.json`

3. **Project-specific issues**
   - Ensure in project root directory
   - Check Makefile exists: `ls Makefile`
   - Verify Flutter setup: `make check-env`

### Debug Commands
```bash
# Test installation
./.claude/scripts/install.sh --from-global

# Check global settings
cat ~/.claude/settings.json

# Test project hooks
./.claude/scripts/auto-comment.sh test.dart Write
```

## Contributing to Template

This cookbook is designed to grow with the Flutter template:

### Adding Template-Specific Commands
1. Create command in `.claude/commands/`
2. Add Makefile integration if needed
3. Update both language versions in `locales/`
4. Test with template project structure

### Customizing for Your Projects
1. Fork this template
2. Modify commands for your needs
3. Update hooks for your workflow
4. Customize roles for your domain

## Integration with Template Features

### Firebase Integration
- Commands understand dev/prod Firebase projects
- Hooks validate Firebase configuration changes
- Settings include Firebase CLI permissions

### State Management
- Flutter role includes Riverpod + Hooks best practices
- Architecture role evaluates state management patterns
- Performance role optimizes state updates

### Core Package (flutter_foundation)
- 共通コンポーネント（Button, Dialog, Snackbar等）
- ユーティリティ（Logger, Validator等）
- プロバイダー（Auth, Analytics, Purchase等）
- AI統合（GeminiService）

### Build System
- Build commands work with flavor system (dev/prod)
- Hooks validate environment configurations
- Settings allow platform-specific builds

### Testing Framework
- Test role includes Widget testing strategies
- Coverage commands understand template structure
- Hooks prompt for test updates

## 次のステップ

### 🚀 クイックスタート（推奨）
```bash
# 1. グローバルインストール
./.claude/scripts/install.sh --to-global

# 2. 完全自動化フロー実行
/01-project-init          # 企画・要件定義（5-8分）
/05-project-deploy        # 完全環境構築（7-10分）
/18-release-ios           # App Store リリース（15-20分）
```

### 📚 学習・探索
1. **コマンド試用**: `/flutter-analyze`, `/role flutter`
2. **役割探索**: 様々な専門家視点でコードレビュー
3. **スキル活用**: Apple Design準拠のUI実装
4. **カスタマイズ**: プロジェクト固有コマンド・フック追加

### ⚡ 開発効率
**結果**: 企画から App Store 配信まで **3-4時間** の効率的開発フロー
- 自動化: 40-60分
- 手動作業: 120-180分
- **総合効率**: 従来の 1/10 の時間でプロダクション品質達成

### 📊 プロジェクト統計
- **87個のカスタムコマンド** - 開発プロセス全体を網羅
- **10個のAIエージェント役割** - 専門的な視点でのサポート
- **2個のスキル** - Apple Design準拠UI & スキル作成ガイド
- **39言語対応** - グローバル展開対応
- **21個のリリースコマンド** - 完全自動化デプロイメント

この cookbook は Flutter テンプレート開発体験を革命的に向上させ、インテリジェントな支援、自動化された品質チェック、そしてモバイルアプリ開発の様々な側面に対する専門的知見を提供します。
