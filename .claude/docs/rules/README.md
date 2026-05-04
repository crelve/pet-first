# Rules - プロジェクトルール・ガイドライン

プロジェクト開発における各種ルールとガイドラインです。

> **📚 ドキュメント階層**
> 1. **[/README.md](../../../README.md)** - プロジェクト概要（一般ユーザー向け）
> 2. **[/CLAUDE.md](../../../CLAUDE.md)** - 開発ワークフロー（Claude AI向け基本情報）
> 3. **[project_rules.md](./project_rules.md)** - プロジェクト全体のルール
> 4. **[coding_rule.md](./coding_rule.md)** - 実装時のコーディング規約（⚠️実装前必須）
> 5. 個別の専門ルール（下記参照）

## ファイル一覧

### 📋 コアルール（必読）
- **[project_rules.md](./project_rules.md)** - プロジェクト全体のルール・ディレクトリ構成・技術スタック
- **[coding_rule.md](./coding_rule.md)** - ⚠️実装前必須チェック・詳細コーディング規約・品質管理

### 💻 専門ルール
- **[naming_conventions.md](./naming_conventions.md)** - 命名規則ガイド（プロジェクト名・Firebase・パッケージ名）
- **[color_management_rule.md](./color_management_rule.md)** - 色管理ルール
- **[import_ordering_guide.md](./import_ordering_guide.md)** - インポート順序ガイド
- **[session_rule.md](./session_rule.md)** - セッション管理とワークフローのルール

### 🔄 開発フローRules
- **git_rule.md** - Git運用ルールとブランチ戦略
- **pull_request_rule.md** - プルリクエストの作成・レビュールール

### 🧠 知識管理ルール
- **knowledge_compliance_rule.md** - 知識ベース準拠とコンプライアンスルール

## 使用方法

### 新規開発者向け
1. `project_rules.md` でプロジェクト全体の方針を理解
2. `naming_conventions.md` で命名規則を確認（**Firebase制約必須**）
3. `coding_rule.md` でコーディング基準を確認（全規約統合済み）
4. `git_rule.md` と `pull_request_rule.md` で開発フローを把握

### 日常開発時
- **プロジェクト作成時**: `naming_conventions.md` を参照（Firebase制約遵守）
- コード作成時: `coding_rule.md` を参照（全規約統合済み）
- 色使用時: `color_management_rule.md` を参照
- インポート整理時: `import_ordering_guide.md` を参照
- ブランチ作成時: `git_rule.md` を参照
- PR作成時: `pull_request_rule.md` を参照
- セッション開始時: `session_rule.md` を参照

### 品質管理
- コードレビュー時にルール準拠をチェック
- 定期的なルール見直しと更新
- 新しいベストプラクティスの追加

## 注意事項

- 全てのルールは強制ではなく、ガイドラインとして活用
- プロジェクトの特性に応じて柔軟に適用
- チーム内での合意形成を重視
- 継続的な改善と更新を実施

これらのルールに従うことで、一貫性のある高品質なコードベースを維持できます。