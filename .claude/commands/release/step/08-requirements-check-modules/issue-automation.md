# Issue自動操作

## 目的
GitHub Issueの自動作成・自動クローズ

---

## 1. Issue自動作成（--auto-create-issues）

### 実行条件
- 未実装の要件（REQ-XXX）が存在
- 対応するIssueが未作成

### 実行フロー
```bash
# 1. 未実装要件を特定
# （issue-mapping.mdのメモリから取得）

# 2. Issue作成
gh issue create \
  --title "REQ-XXX: 要件タイトル" \
  --body "$(cat <<'EOF'
## 要件概要
[requirements.mdから抽出]

## 受け入れ基準
- [ ] 基準1
- [ ] 基準2

## 関連ドキュメント
- docs/project/requirements.md#REQ-XXX
EOF
)" \
  --label "enhancement,requirement" \
  --assignee "@me"
```

---

## 2. Issue自動クローズ（--auto-close）

### ⚠️ 重要な注意事項
このオプションは**危険**です。以下の条件を満たす場合のみ実行：

### 実行条件（すべて満たす必要あり）
- 要件が完全実装済み
- 関連PRがすべてmerged
- テストが全合格
- 手動レビュー完了

### 実行フロー
```bash
# 1. 完了済み要件を特定
# （basic-checks.mdのメモリから取得）

# 2. Issue自動クローズ（確認プロンプト表示）
gh issue close <issue-number> \
  --comment "✅ 要件実装完了・テスト合格・PR merged確認済み"
```

---

## 🤖 Claude Code への指示

**トークン効率化:**
- Issue操作は必要な場合のみ実行
- 他モジュールのメモリから情報取得（再チェック不要）
- 自動クローズ前に必ずユーザー確認
