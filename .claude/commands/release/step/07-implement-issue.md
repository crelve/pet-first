# 🚀 Step 07: GitHub Issues自動実装コマンド

<!-- PROGRESS_COMMAND_ID: 07-implement-issue -->
<!-- PROGRESS_PHASE: phase3 -->
<!-- PROGRESS_NAME: Issue自動実装 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

GitHub Issuesから要件を取得し、自動実装・PR作成を行います。

---

## 🚫 絶対禁止（最優先）

| 禁止事項 | 理由 |
|---------|------|
| `flutter build` の実行 | ユーザーが手動確認する。CI/CDで検証される |

⚠️ **品質チェックは `flutter analyze` と `flutter test` のみ実行**

---

## 🎨 必須参照（実装前）

| 参照先 | 用途 |
|--------|------|
| [coding_rule.md](../../../docs/rules/coding_rule.md) | **必須読み込み** → 「コーディングルールを確認しました。」出力 |
| [CLAUDE.md 実装前チェックリスト](../../../../CLAUDE.md#実装前チェックリスト必須) | 画面遷移・コンポーネント・色ルール |
| [Apple Design SKILL](../../../skills/apple-design/SKILL.md) | iOS HIG準拠・UI設計 |
| [UX Psychology](../../../skills/apple-design/references/ux-psychology.md) | UX心理学コンセプト |

---

## 🚨 実装品質の原則

### 🔴 コミット前に必ず実行（スキップ厳禁）
```bash
make check-quality-rules-full   # コンポーネント・色・l10n・import全チェック
```
このチェックが全て通るまでコミットしてはいけない。

### ❌ 絶対禁止事項
- プロトタイプ・部分実装（「後で実装」前提のコード）
- `flutter build` の実行（ユーザーが手動確認）
- **ハードコード文字列**（`Text('保存')` → `ThemeText(text: l10n.save)`）
- **禁止コンポーネント**（`AlertDialog` → `ActionDialog`、`ElevatedButton`/`FilledButton` → `PrimaryButton`）
- **禁止カラー**（`Colors.white` → `AppleSemanticColors`、`Color(0xFF...)` → `ColorName`）

### ✅ 求められるレベル
**App Storeに即座にリリース可能な本番環境品質**

---

## 使用方法

```bash
/release:step:07-implement-issue
```

---

## 実行フロー

| Phase | 内容 | 詳細 |
|-------|------|------|
| 0 | ブランチ準備 | `git checkout main && git pull origin main` で最新状態に同期 |
| 1 | Issue選択 | Priority・labelベースで最優先Issue自動選択 |
| 2 | ルール確認 | `coding_rule.md` 必須読み込み |
| 3 | ブランチ作成 | `feature/issue-{番号}-{機能名}` 形式 |
| 4 | 実装 | [implementation-guide.md](07-modules/implementation-guide.md) |
| 5 | 品質チェック | [quality-check.md](07-modules/quality-check.md) → `/release:step:09-quality-rules-check` |
| 6 | PR作成 | [pr-creation.md](07-modules/pr-creation.md) |

### Phase 0: ブランチ準備（必須）

実装開始前に必ず以下を実行:

```bash
# 1. mainブランチに切り替え
git checkout main

# 2. 最新のmainをpull
git pull origin main
```

⚠️ **注意**: この手順をスキップすると、古いコードベースで実装してしまいコンフリクトの原因になります。

---

## 🤖 実行指示

### ⚠️ 段階的読み込み（一括禁止）

| Phase | 読み込むファイル |
|-------|-----------------|
| 実装時 | `implementation-guide.md` のみ |
| 品質チェック時 | `quality-check.md` のみ |
| PR作成時 | `pr-creation.md` のみ |

### 効率化ルール

| ルール | 内容 |
|--------|------|
| Serena活用 | ファイル全文読みを回避（`coding_rule.md`は例外で全文必須） |
| 並列実行 | analyze/test は並列実行可（`flutter build`は禁止） |
| メモリ活用 | Issue情報・品質チェック結果をメモリ保存 |
| 品質チェック必須 | 全12項目が✅になるまでコミット・Push禁止 |

---

## 関連コマンド

```bash
/release:step:09-quality-rules-check  # 包括的品質チェック（コミット前必須）
/flutter-analyze                       # コード品質解析
/update-dart-doc                       # DartDocコメント生成
```

---

## ✅ 完了時アクション

`RELEASE_CHECKLIST.md` の該当コマンドをチェック済み `[x]` に更新
