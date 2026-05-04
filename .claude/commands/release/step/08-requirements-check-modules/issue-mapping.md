# GitHub Issue連携チェック

## 目的
GitHub IssueとREQUIREMENTS.mdの要件をマッピングし、実装状況を判定

---

## Issue-要件マッピングロジック

### 1. Issue一覧取得
```bash
gh issue list --state all --json number,title,state,labels --limit 100
```

### 2. 要件ファイル読み込み（ハイブリッド方式対応）
```bash
# Serena で効率的に読み込み（非コードファイル検索）
# Part 2: 機能要件（REQ-XXX）
mcp__serena__search_for_pattern \
  substring_pattern="^\*\*REQ-[0-9]+\*\*:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=5

# Part 3: 画面別実装仕様（SCR-XXX）
mcp__serena__search_for_pattern \
  substring_pattern="^### SCR-[A-Z0-9-]+:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=10

# Part 4: 共通機能（COMMON/BG/SYS-XXX）
mcp__serena__search_for_pattern \
  substring_pattern="^\*\*(COMMON|BG|SYS)-[0-9]+\*\*:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=5
```

**重要**: ハイブリッド方式では、Part 2-4の全要件をチェック対象とします。

### 3. マッピング実行（ハイブリッド方式）
- Issue title から要件ID（REQ-XXX, SCR-XXX, COMMON/BG/SYS-XXX）を抽出
- 要件ごとにIssue状態を確認
- 実装完了判定（Issue closed + PR merged）

**マッピング対象**:
- **REQ-XXX**: 機能要件Issue（親Issue扱い、主にトラッキング用）
- **SCR-XXX**: 画面実装Issue（実装の主体）
- **COMMON-XXX**: 共通Provider Issue
- **BG-XXX**: バックグラウンド処理Issue
- **SYS-XXX**: システム機能Issue

---

## 実装状況判定

### ✅ 実装完了
- Issue closed
- 関連PRがmerged
- テスト合格

### 🚧 実装中
- Issue open
- 関連PRがopen/draft

### ⚠️ 未実装
- Issue未作成
- または Issue open だが進捗なし

---

## 🤖 Claude Code への指示

**トークン効率化:**
- Issue一覧をメモリに保存
- 要件ファイルは Serena でパターン検索
- 結果を構造化してメモリ保存（他モジュールで再利用）
