# 🛠️ release:step:07-implement-issue モジュール構成

## トークン効率化のためのモジュール分割構造

`/release:step:07-implement-issue` コマンドは、トークン消費を最小化するため、3つのモジュールに分割されています。

---

## 📁 ファイル構造

```
08-modules/
├── README.md                # このファイル
├── implementation-guide.md  # 実装ガイド（コード例・パターン）
├── quality-check.md         # 品質チェック（プロトタイプ検出含む）
└── pr-creation.md           # PR作成（テンプレート・Issue連携）
```

---

## 🎯 モジュール別責務

### 1. implementation-guide.md
- **目的**: 本番環境品質での完全実装
- **内容**:
  - モデル実装（Freezed）
  - Provider実装（Riverpod）
  - コンポーネント実装（HookConsumerWidget）
  - エラーハンドリング実装
  - テスト実装
- **トークン削減**: コード例を参照時のみ読み込み

### 2. quality-check.md
- **目的**: 本番環境準備度の完全検証
- **内容**:
  - 統合品質チェック（`make check-ready`）
  - プロトタイプ検出チェック（TODO/仮データ/未実装検出）
  - 個別チェック（analyze/test/format）
  - 本番環境準備度チェックリスト
- **トークン削減**: チェック実行時のみ読み込み

### 3. pr-creation.md
- **目的**: 品質チェック結果を含む完全なPR作成
- **内容**:
  - PR作成前の最終確認
  - PR作成コマンド（テンプレート）
  - Issue-PR自動リンク
  - エラーハンドリング
- **トークン削減**: PR作成時のみ読み込み

---

## 🤖 Claude Code への指示（トークン効率化）

### 1. モジュール別読み込み
```
# ❌ 非効率: 全モジュール一度に読む
Read .claude/commands/release/step/release:step:07-implement-issue.md (461行)

# ✅ 効率的: 必要なモジュールのみ読む
実装時: Read .claude/commands/release/step/08-modules/implementation-guide.md (150行)
品質チェック時: Read .claude/commands/release/step/08-modules/quality-check.md (120行)
PR作成時: Read .claude/commands/release/step/08-modules/pr-creation.md (150行)
```

### 2. Serena活用（コーディング規約）
```bash
# coding_rule.md の効率的読み込み
mcp__serena__get_symbols_overview \
  relative_path=".claude/docs/rules/coding_rule.md"

# 必要な章のみ取得
mcp__serena__find_symbol \
  name_path="実装前必須チェック" \
  relative_path=".claude/docs/rules/coding_rule.md" \
  include_body=true
```

### 3. メモリ活用
```
Issue情報取得 → メモリ保存
実装中 → メモリから参照（再取得不要）
品質チェック → メモリから参照
PR作成 → メモリから品質チェック結果取得
```

### 4. 並列実行
```bash
# 品質チェックを並列実行
flutter analyze & flutter test & dart format --set-exit-if-changed .
→ 1メッセージで実行
```
---

## 🔍 各モジュールの詳細

各モジュールの詳細な実行内容は、該当ファイルを参照してください：
- [implementation-guide.md](implementation-guide.md)
- [quality-check.md](quality-check.md)
- [pr-creation.md](pr-creation.md)
