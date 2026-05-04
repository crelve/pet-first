# 🚀 Step 06: 自動実装セットアップ

<!-- PROGRESS_COMMAND_ID: 06-setup-auto-implementation -->
<!-- PROGRESS_PHASE: phase2 -->
<!-- PROGRESS_NAME: 自動実装セットアップ -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 5-8分

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → MVP機能のP0/P1優先度をIssueに反映"
```

企画書が存在する場合、MVP機能リストと優先度を読み取り、Issue生成の順序・ラベル付けに反映する。

---

GitHub Issues自動生成・開発環境セットアップを一括実行します。

---

## 使用方法

```bash
# 自動実装セットアップ（全自動）
/release:step:06-setup-auto-implementation
```

---

## 🎯 実行内容（3ステップ）

このコマンドは**トークン効率化のため、3つのモジュールに分割**されています。

### Step 1: 要件からGitHub Issues生成
詳細: [07-modules/issue-generation.md](07-modules/issue-generation.md)
- `docs/project/requirements.md` 解析
- 自動Issue作成（priority/label付き）

### Step 2: 開発環境セットアップ
詳細: [07-modules/dev-setup.md](07-modules/dev-setup.md)
- 依存関係インストール
- コード生成実行
- ビルド検証

### Step 3: 初期実装準備
詳細: [07-modules/initial-impl.md](07-modules/initial-impl.md)
- テンプレートファイル生成
- ディレクトリ構造整備

---

## 🤖 Claude Code への実行指示

**重要: トークン効率化ルール（厳守）**

### ⚠️ 段階的読み込み戦略（Just-in-Time Loading）

**IMPORTANT:** 以下の順序で段階的に読み込むこと：

#### **初回（全体把握）**:
```bash
# README.mdで全体フロー把握（約500 tokens）
Read .claude/commands/release/step/07-modules/README.md
```

#### **Step実行前**:
実行するステップのモジュール**のみ**読み込み（1,000-2,000 tokens/step）

1. **Step 1実行前**: `07-modules/issue-generation.md` を読み込み
2. **Step 2実行前**: `07-modules/dev-setup.md` を読み込み
3. **Step 3実行前**: `07-modules/initial-impl.md` を読み込み

#### **エラー発生時**:
必要に応じて関連モジュールを参照

**❌ 禁止:** 全ステップのモジュールを最初に一度に読み込むこと
**✅ 正しい:** README.md読了後、各ステップ実行直前にモジュールを読み込む

---

### その他の効率化ルール

1. **Serena活用**: `requirements.md` は `search_for_pattern` でパターン検索（`restrict_search_to_code_files=false` 必須）
2. **並列実行の制限**: Issue生成は**3-5個ずつバッチ実行**（GitHub API制限考慮）
3. **メモリ活用**: Step間でメモリを活用（詳細は下記参照）

### メモリ活用の具体フロー

#### Step 1完了時（Issue生成完了後）
```bash
# 作成されたIssue一覧をメモリに保存
mcp__serena__write_memory \
  memory_file_name="issues_created_step1" \
  content="Phase別Issue一覧、Issue番号、見積もり時間など"
```

**保存内容**:
- Phase別Issue一覧
- 各IssueのID・番号・タイトル
- 依存関係情報
- 見積もり時間

#### Step 2-3実行時（環境セットアップ・初期実装時）
```bash
# メモリからIssue情報を取得
mcp__serena__read_memory memory_file_name="issues_created_step1"
```

**活用目的**:
- 実装する機能の全体像把握
- 実装順序の確認
- 依存関係の確認

**トークン削減効果**:
- `gh issue list` 実行不要（約1,500 tokens削減）
- Issue詳細の再読み込み不要（約5,000-10,000 tokens削減）
- **合計: 約6,500-11,500 tokens削減**

---

## 📊 期待される成果

- ✅ GitHub Issues自動生成完了
- ✅ 開発環境セットアップ完了
- ✅ 初期実装準備完了

---

## 関連コマンド

### 大規模実装前の事前確認
```bash
# Flutter/Dart 依存関係チェック
make check-deps

# Issue進捗の可視化（GitHub CLI）
gh issue list --state all
```

**`make check-deps` の特徴:**
- ✅ 依存パッケージ一覧（ツリー形式）
- ✅ 古いパッケージの検出（`flutter pub outdated`）
- ✅ 未使用パッケージの検出
- ✅ Flutter/Dart ネイティブコマンドで高速実行

**`gh issue list` の特徴:**
- ✅ 全Issue の状態を一覧表示
- ✅ ステータス別フィルタ: `--state open/closed/all`
- ✅ ラベル別フィルタ: `--label "Phase 1"`
- ✅ アサイン別フィルタ: `--assignee @me`
- ✅ GitHub標準コマンドで追加インストール不要

**推奨タイミング:**
- `make check-deps`: Step 2（開発環境セットアップ）前に実行推奨
- `gh issue list`: Issue生成後、定期的に実行して進捗確認

---

**Assistant Instructions:**
- このコマンドを実行する際は、必ず日本語で回答してください
- **トークン効率化のため、必要なステップのモジュールのみ読み込んでください**
- 各Stepの詳細手順は `.claude/commands/release/step/07-modules/` 配下のモジュールファイルを参照してください

---

## 🔄 PDCA - 実行後の振り返り（重要）

### ✅ 成功時
Issues生成・環境セットアップが正常に完了した場合は次のステップへ進みます。

### 🚨 問題発生時の対処

以下のような問題が発生した場合の対処法：

**Issue生成の問題**:
- サブタスク分割が不適切 → requirements.mdを見直し、タスク粒度を調整
- 要件が不明瞭 → requirements.mdを明確化してから再実行

**環境セットアップの問題**:
- GitHub API制限 → 1時間待機後に再実行
- Issue数の不一致 → 要件の複雑さを確認し、必要に応じて分割

**再発防止のポイント**:
- Issue生成時はrequirements.mdの明確さを確認
- サブタスクは1-3日で完了できる粒度に調整
- GitHub APIレート制限を考慮して実行タイミングを調整

---

### 📊 次のステップ

Issue生成とセットアップが完了したら、各Issueの実装を開始します：

```bash
# 次のコマンドで実装開始
/07-implement-issue
```

**重要**: Issue粒度が適切でないと、後続の実装フェーズで問題が発生する可能性があります。requirements.mdの明確さを確認してから進めてください

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:06-setup-auto-implementation`**
   ↓
   - [x] **`/release:step:06-setup-auto-implementation`**

2. セクションステータス更新（最初の完了時）:
   ### **Auto02: 実装環境構築・機能実装・品質確認・法務** (5コマンド) ⬜ 未着手
   ↓
   ### **Auto02: 実装環境構築・機能実装・品質確認・法務** (5コマンド) 🔄 進行中
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
