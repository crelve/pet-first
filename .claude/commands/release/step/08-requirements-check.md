# 🚀 Step 08: 要件定義適合性チェック (GitHub Issue連携)

<!-- PROGRESS_COMMAND_ID: 08-requirements-check -->
<!-- PROGRESS_PHASE: phase3 -->
<!-- PROGRESS_NAME: 要件定義適合性チェック -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 3-5分 (構造検証含む場合: 5-8分)

GitHubのIssueステータスと実装内容を照合し、要件定義の受け入れ基準適合性を自動チェックします。
さらに、アプリケーション構造の完成度を包括的に検証し、Phase 3完了判定を行います。

---

## 使用方法

```bash
# 全要件一括チェック（デフォルト）
/release:step:08-requirements-check

# アプリ構造完成度検証を含む包括的チェック（Phase 3完了判定）
/release:step:08-requirements-check --verify-structure

# 特定要件のみチェック
/release:step:08-requirements-check --req-id=REQ-001

# 未実装要件のGitHub Issue自動作成（推奨）
/release:step:08-requirements-check --auto-create-issues
```

---

## 主要オプション

- `--verify-structure`: アプリ構造完成度検証を実施（Phase 3完了判定）
- `--req-id=REQ-XXX`: 特定要件のみチェック
- `--with-performance`: パフォーマンステスト実施
- `--auto-create-issues`: 未実装要件に対してGitHub Issueを自動作成（推奨）
- `--auto-close`: 完了済み要件のIssueを自動クローズ（注意: 危険なオプション）
- `--ci`: CI/CD環境での実行（JSON出力）

---

## 🔗 チェック内容（5カテゴリ）

このコマンドは**トークン効率化のため、5つのモジュールに分割**されています。

### 1. GitHub Issue連携チェック
詳細: [08-requirements-check-modules/issue-mapping.md](08-requirements-check-modules/issue-mapping.md)
- Issue-要件マッピング
- 実装状況判定ロジック

### 2. 基本適合性チェック
詳細: [08-requirements-check-modules/basic-checks.md](08-requirements-check-modules/basic-checks.md)
- コード品質チェック
- 実装完全性チェック

### 3. 機能特化チェック
詳細: [08-requirements-check-modules/feature-checks.md](08-requirements-check-modules/feature-checks.md)
- 認証・ユーザー管理系
- データ管理系
- UI/UX系
- 通知・連携系

### 4. アプリ構造完成度検証 (--verify-structure)
詳細: [08-requirements-check-modules/structure-verification.md](08-requirements-check-modules/structure-verification.md)
- 画面構造完成度チェック (25%)
- コア機能実装度チェック (35%)
- 技術基盤完成度チェック (20%)
- 品質・パフォーマンスチェック (15%)
- UI/UX基盤チェック (5%)
- **完成度スコア算出とPhase 3完了判定**

### 5. Issue自動操作
詳細: [08-requirements-check-modules/issue-automation.md](08-requirements-check-modules/issue-automation.md)
- Issue自動作成（--auto-create-issues）
- Issue自動クローズ（--auto-close）

---

## 🤖 Claude Code への実行指示

**重要: トークン効率化ルール（厳守）**

### ⚠️ モジュール別読み込み必須（全モジュール一括読み込み禁止）

**IMPORTANT:** 必要なモジュールのみ読み込むこと：

1. **GitHub Issue連携が必要な場合のみ**: `08-requirements-check-modules/issue-mapping.md` 読み込み
2. **基本チェック実行時**: `08-requirements-check-modules/basic-checks.md` 読み込み
3. **機能特化チェック実行時**: `08-requirements-check-modules/feature-checks.md` 読み込み
4. **アプリ構造検証実行時 (--verify-structure)**: `08-requirements-check-modules/structure-verification.md` 読み込み
5. **Issue自動操作実行時のみ**: `08-requirements-check-modules/issue-automation.md` 読み込み

**❌ 禁止:** 「全体を把握するため」として全モジュールを一度に読み込むこと
**✅ 正しい:** 実行するチェック内容に必要なモジュールのみ読み込む

---

### その他の効率化ルール

1. **Serena活用**: `docs/project/requirements.md` は章単位で読み込み
   ```bash
   mcp__serena__find_symbol name_path="REQ-001" include_body=true
   ```

2. **並列実行**: GitHub Issue取得と要件ファイル読み込みは並列実行可能

3. **メモリ活用**: Issue一覧をメモリに保存し、複数要件チェック時に再利用

---

## 📊 期待される成果

- ✅ 全要件の実装状況可視化
- ✅ GitHub Issueとの完全同期
- ✅ 未実装要件の自動Issue化
- ✅ リリース前の要件充足確認

---

**Assistant Instructions:**
- このコマンドを実行する際は、必ず日本語で回答してください
- **トークン効率化のため、必要なモジュールのみ読み込んでください**
- 各チェックの詳細手順は `.claude/commands/release/step/08-requirements-check-modules/` 配下のモジュールファイルを参照してください
- オプション指定がない場合は、基本チェックのみ実行してください

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:08-requirements-check`**
   ↓
   - [x] **`/release:step:08-requirements-check`**

2. セクションステータス更新:
   Auto02の全コマンドが完了したら: 🔄 進行中 → ✅ 完了
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
