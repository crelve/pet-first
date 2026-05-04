# 🚀 PR作成ガイド


## 目的
品質チェック結果を含む完全なPR作成・Issue自動連携

---

## PR作成前の最終確認

```
✅ すべての要件が実装完了している
✅ TODOコメントが0件である
✅ 仮データ・プレースホルダーが0件である
✅ エラーハンドリングがすべて実装済みである
✅ ユーザー向けUI/UXが完成している
✅ パフォーマンス最適化が実装済みである
✅ 本番環境で即座にリリース可能である
```

---

## PR作成コマンド

### 基本フロー

```bash
# 1. Issue番号の取得
ISSUE_NUMBER=$(gh issue list --state open --json number --jq '.[0].number')
echo "Found Issue #${ISSUE_NUMBER}"

# 2. PR作成（Open状態・Draft禁止）
gh pr create \
  --title "Issue #${ISSUE_NUMBER}: 機能名" \
  --body "$(cat <<'EOF'
## 概要
Issueの要件を実装

## 実装内容
- [x] 新機能のコア機能実装
- [x] UI/UX実装
- [x] 状態管理実装（Riverpod）
- [x] エラーハンドリング実装
- [x] Unit/Widget テスト実装

## 技術詳細
- **アーキテクチャ**: 既存プロジェクトパターンに準拠
- **状態管理**: Riverpod + Flutter Hooks
- **データモデル**: Freezed
- **テスト**: Unit/Widget/Integration

## 品質チェック結果
```bash
# 1. 静的解析チェック
✅ flutter analyze: 0 issues found

# 2. テスト実行
✅ flutter test: All tests passed! (23/23)
✅ Test coverage: 85.2% (target: 80%+)

# 3. コードフォーマット
✅ dart format: All files properly formatted

# 4. 依存関係チェック
✅ flutter doctor: No issues found

# 5. プロトタイプ検出チェック（本番環境準備度）
✅ TODOコメント: 0件
✅ 仮データ検出: 0件
✅ 未実装エラー: 0件
✅ プレースホルダー: 0件
```

## 本番環境準備度チェック
- ✅ エラーメッセージがユーザーフレンドリー
- ✅ ローディング状態が適切に表示される
- ✅ ネットワークエラー時の適切なフォールバック実装済み
- ✅ 空データ状態の適切なUI実装済み
- ✅ データ検証ロジックが実装済み
- ✅ パフォーマンス最適化実装済み

## 受け入れ基準チェック
- [x] Issue記載の要件を満たしている
- [x] 既存機能への影響なし
- [x] パフォーマンス問題なし

Closes #${ISSUE_NUMBER}
EOF
)"
```

---

## Issue-PR自動リンクの仕組み

### キーワードによる自動クローズ
PRマージ時にIssueを自動的にクローズするキーワード：
- `Closes #123` - Issue #123をクローズ
- `Fixes #123` - Issue #123を修正として扱い
- `Resolves #123` - Issue #123を解決として扱い

### 実装フロー
```bash
# 基本フロー
1. Issue番号でブランチ作成
2. 実装
3. PR作成時に"Closes #issue-number"自動挿入
4. PRマージ→Issue自動クローズ
```

---

## 安全なプッシュ（推奨）

```bash
# 品質チェック + git push を一括実行
make push
# 自動実行: check-ready → git push
```

---

## エラーハンドリング

### よくあるエラーと対処法

**Issue が見つからない**
```bash
❌ Error: Issue #99 not found
💡 Solution: Issue番号を確認してください
gh issue list --state open
```

**ブランチ作成失敗**
```bash
❌ Error: Branch feature/issue-12 already exists
💡 Solution: 既存ブランチを確認し、別名で作成してください
```

**テスト失敗**
```bash
❌ Error: Tests failed
💡 Solution: テストエラーを修正してから再実行してください
flutter test
```

---

## 🤖 Claude Code への指示

**トークン効率化:**
- PR本文テンプレートは固定（変数のみ置換）
- 品質チェック結果はメモリから参照（再実行不要）
- Issue情報もメモリから参照
- `gh pr create` の成功確認のみ（詳細ログ不要）

**必須:**
- PR作成は必ず Open状態（Draft使用禁止）
- `Closes #issue-number` の自動挿入
- 品質チェック結果の完全記載
