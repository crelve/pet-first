# Templates（テンプレート）

このフォルダには、アプリ開発プロセスで使用する各種テンプレートが含まれています。

## ファイル一覧

### 分析テンプレート
- **app_analysis_template.md** - 既存アプリ分析用テンプレート
  - 基本情報、機能分析、ターゲットユーザー分析
  - 競合分析、強み・弱み分析、ユーザーフィードバック分析
  - 収益化モデル分析、技術的制約・機会、市場機会分析

### 戦略テンプレート
- **differentiation_strategy_template.md** - 差別化戦略策定用テンプレート
  - 差別化コンセプト、詳細差別化ポイント
  - 競合優位性、市場機会、リスク分析
  - 成功指標、実装優先度、実装スケジュール

### 要件定義テンプレート
- **requirements_template.md** - 機能要件定義用テンプレート
  - プロジェクト概要、ステークホルダー、機能要件
  - 非機能要件、制約事項、リスク分析
  - 成功指標、実装フェーズ、承認

### 機能仕様書テンプレート
- **feature_spec_template.md** - 機能仕様書用テンプレート
  - 機能概要、要件、実装概要
  - 実装検討事項、画面・UI実装、データフロー
  - データモデル、API仕様、テストケース
  - デプロイ手順、メンテナンス手順、バージョン管理

## 使用方法

### 1. 既存アプリ分析
```bash
# テンプレートをコピー
cp app_analysis_template.md my_app_analysis.md

# 分析対象のアプリ情報を記入
# アプリ名、URL、カテゴリを指定
```

### 2. 差別化戦略策定
```bash
# テンプレートをコピー
cp differentiation_strategy_template.md my_app_differentiation.md

# 分析結果を基に差別化戦略を策定
```

### 3. 要件定義作成
```bash
# テンプレートをコピー
cp requirements_template.md my_app_requirements.md

# 差別化戦略を基に要件定義を作成
```

### 4. 機能仕様書作成
```bash
# テンプレートをコピー
cp feature_spec_template.md my_app_feature_spec.md

# 要件定義を基に機能仕様書を作成
```   

## AI活用プロンプト

これらのテンプレートを使用する際は、`../implementation/ai_prompts.md`のプロンプトを活用してください。

## 次のステップ

テンプレートを使用して作成した分析・戦略・要件定義は、`../strategies/`フォルダに保存して管理します。 