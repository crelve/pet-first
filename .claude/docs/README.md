# Documentation（ドキュメント）

このフォルダには、アプリ開発プロジェクトに関する包括的なドキュメントが含まれています。

> **📚 主要ドキュメント**
> - **[/README.md](../../README.md)** - プロジェクト概要・クイックスタート
> - **[/CLAUDE.md](../../CLAUDE.md)** - 開発ワークフロー・基本構造
> - **[rules/project_rules.md](./rules/project_rules.md)** - プロジェクト全体のルール
> - **[rules/coding_rule.md](./rules/coding_rule.md)** - 実装時のコーディング規約
> - **[/Claude Code Cookbook](../README.md)** - 87個のコマンド・10個のAIエージェント

## フォルダ構成

### 📊 Analysis（分析）
既存アプリの分析結果と差別化戦略
- `[app_name]_analysis.md` - [アプリ名]の詳細分析
- `[app_name]_differentiation.md` - 差別化戦略

### 📋 Templates（テンプレート）
アプリ開発プロセスで使用する各種テンプレート
- `app_analysis_template.md` - 既存アプリ分析用テンプレート
- `differentiation_strategy_template.md` - 差別化戦略策定用テンプレート
- `requirements_template.md` - 機能要件定義用テンプレート

### 🎯 Strategies（戦略・要件定義）
アプリの戦略・要件定義・コンセプト
- `[project_name]_concept.md` - アプリコンセプト
- `[project_name]_requirements.md` - 機能要件定義
- `[project_name]_technical_requirements.md` - 技術要件定義
- `[project_name]_monetization_strategy.md` - 収益化戦略
- `[project_name]_marketing_strategy.md` - マーケティング戦略

### 🛠️ Implementation（実装ガイド）
アプリ開発の実装プロセスに関するガイド
- `ai_prompts.md` - AI活用プロンプト集
- `process_guide.md` - 差別化開発プロセスガイド

### 📏 Rules（ルール・ガイドライン）
プロジェクト開発における各種ルールとガイドライン
- `coding_rule.md` - コーディングルール
- `git_rule.md` - Git運用ルール
- `style_guide.md` - スタイルガイド
- `translation_rule.md` - 翻訳ルール

### 🏗️ Design（設計ドキュメント）
システム設計とアーキテクチャの仕様
- `project_history_management.md` - プロジェクト履歴管理システム設計

### 🚀 Release（リリース）
アプリのリリースプロセスに関するガイド
- `01_clone_repository.md` - リポジトリの複製
- `02_create_firebase_project.md` - Firebaseプロジェクトの作成
- `03_replace_content.md` - リポジトリ内の固有部分置換
- その他リリース関連ファイル（04-22）

## 開発フロー

### 1. プロジェクトセットアップ（AI主導）
```bash
# Release Setup コマンド実行
/release-setup

# AI探索型ワークフローで以下を自動実行：
# - 市場分析・競合調査
# - アプリコンセプト策定
# - 技術要件定義
# - Firebase プロジェクト作成
# - リポジトリセットアップ
```

### 2. MVP開発開始（自動移行）
```bash
# Release Setup完了後、自動的に実装フェーズに移行
# 以下のコマンドが順次実行される：

# Phase 1: 基盤構築（Week 1-4）
/flutter:implement-mvp-foundation
# - 認証システム実装
# - 基本UI/UX構築
# - データモデル作成
# - Firebase統合

# Phase 2: AI機能実装（Week 5-8）  
/flutter:implement-ai-features
# - AI推薦エンジン
# - TensorFlow Lite統合
# - 学習・分析機能

# Phase 3: 収益化・最終調整（Week 9-12）
/monetization-complete
# - サブスクリプション
# - 最終UI調整
# - テスト・リリース準備
```

### 3. 段階的リリース（並行実行）
```bash
# iOS準備（Phase 2と並行）
/release-ios

# 収益化設定（Phase 3で統合）
/release-monetization

# 法的要件（Phase 3で統合）
/release-legal
```

### 4. 継続的改善
```bash
# リリース後の分析・改善
/flutter:analytics-review
/flutter:performance-optimization
/flutter:feature-enhancement
```

## 使用方法

### 新規プロジェクト開始時
1. `templates/`フォルダのテンプレートを使用
2. `implementation/ai_prompts.md`のプロンプトを活用
3. `implementation/process_guide.md`に従って開発を進める

### 既存プロジェクトの継続時
1. `analysis/`フォルダの分析結果を確認
2. `strategies/`フォルダの戦略・要件定義を確認
3. `release/`フォルダでリリースプロセスを実行

### 品質管理
1. `rules/`フォルダのルール・ガイドラインを遵守
2. 各段階で品質チェックを実施
3. 継続的な改善を実施

## 主要ファイル

### プロジェクト概要
- `strategies/[project_name]_concept.md` - アプリの全体像
- `strategies/[project_name]_requirements.md` - 機能要件
- `strategies/[project_name]_technical_requirements.md` - 技術仕様

### 開発ガイド
- `implementation/process_guide.md` - 開発プロセス
- `implementation/ai_prompts.md` - AI活用方法
- `templates/` - 各種テンプレート

### リリースガイド
- `release/README.md` - リリースプロセス概要
- `release/01_clone_repository.md` - プロジェクト開始
- `release/18_submit_review.md` - ストア申請

## プロジェクト固有の設定

### ファイル名の置換
以下のプレースホルダーを実際のプロジェクト名に置換してください：

- `[app_name]` → 分析対象のアプリ名（例：google_translate）
- `[project_name]` → プロジェクト名（例：specialized_translation）

### 例
```
# 分析ファイル
google_translate_analysis.md
google_translate_differentiation.md

# 戦略ファイル
specialized_translation_concept.md
specialized_translation_requirements.md
specialized_translation_technical_requirements.md
specialized_translation_monetization_strategy.md
specialized_translation_marketing_strategy.md
```

## 注意事項

### 依存関係
- 分析 → 戦略策定 → 要件定義 → 実装 → リリースの順序で進める
- 各段階で品質チェックを実施
- ルール・ガイドラインを遵守

### 更新管理
- ドキュメントの更新は適切にバージョン管理する
- 変更履歴を記録する
- チーム内で共有・確認する

## サポート

ドキュメントに関する質問や改善提案がある場合は、プロジェクトチームまでお問い合わせください。 