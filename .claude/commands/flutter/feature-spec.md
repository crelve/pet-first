# Feature Spec Generator

Flutter機能の詳細仕様書を生成するためのコマンドです。機能仕様書テンプレートを使用して、実装前の計画立案を支援します。

## 使い方

```bash
# 新機能の仕様書作成
「[機能名]の機能仕様書を作成して」

# 例
「ユーザー認証機能の機能仕様書を作成して」
「チャット機能の機能仕様書を作成して」
「プッシュ通知機能の機能仕様書を作成して」
```

## 実行内容

### 1. テンプレートコピー
```bash
cp .claude/docs/templates/feature_spec_template.md docs/project/[feature_name]_spec.md
```

### 2. テンプレート内容のカスタマイズ
- 機能名に基づいた項目の具体化
- Flutter/Firebase特化の実装検討事項を展開
- プロジェクト固有の要件に合わせた調整

### 3. 生成される仕様書の内容

**基本項目:**
- 機能概要・要件定義
- 実装概要・検討事項

**Flutter専用チェック項目:**
- 画面・UI実装（Screen/Widget分割）
- 状態管理（Riverpod実装方針）
- データ管理・永続化（SharedPreferences/Hive）
- ルーティング・画面遷移（GoRouter対応）
- API・外部サービス連携
- テスト実装（Widget/Unit/E2E）
- アナリティクス・ログ（Firebase Analytics等）
- パフォーマンス・最適化

**品質保証チェック:**
- 開発中チェック（`flutter analyze`, `dart format`）
- コミット・PR前チェック（lefthook, CI/CD）
- レビュー・マージ前チェック

## 使用例

### ユーザー認証機能
```bash
「ユーザー認証機能の機能仕様書を作成して」

# 生成ファイル: docs/project/user_auth_spec.md
# 内容: Firebase Auth + Google Sign-In特化の仕様書
```

### チャット機能
```bash
「リアルタイムチャット機能の機能仕様書を作成して」

# 生成ファイル: docs/project/realtime_chat_spec.md  
# 内容: Firestore + WebSocket特化の仕様書
```

## 特徴

**Flutter特化**
- このプロジェクトの技術スタック（Firebase、Riverpod、GoRouter）に最適化
- 実際の開発フローに沿ったチェックリスト

**実践的**
- 87個のコマンド体系と連携
- CI/CD、品質保証プロセスと統合
- 実装→テスト→デプロイまでの完全なワークフロー

**進捗管理**
- チェックボックス形式でタスク管理
- TodoWrite ツールとの連携
- 実装完了まで追跡可能

## 関連コマンド

- `/plan` - 実装計画立案時に機能仕様書作成を含む
- `/01-project-init` - プロジェクト初期化時にテンプレート配置
- `/flutter-analyze` - 仕様書の品質チェック項目を実行

## 注意事項

- 仕様書作成後は必ず内容をカスタマイズ
- チェックリストを活用した進捗管理を推奨
- 実装前の設計レビューを実施