# 🎯 トークン効率化ベストプラクティス

## 概要

このドキュメントは、Claude Code でのトークン消費を最小化するための実践的なテクニック集です。
スラッシュコマンド実行時、コード実装時に**必ず参照**してください。

---

## 📊 効果実績

### 最適化前
- 平均トークン消費: 20,000-30,000 tokens/コマンド
- リリースコマンド実行: 150,000-200,000 tokens

### 最適化後
- 平均トークン消費: 5,000-8,000 tokens/コマンド（**70-75%削減**）
- リリースコマンド実行: 40,000-60,000 tokens（**70%削減**）

---

## 🏆 トークン効率化の黄金ルール10選

### 1. **キャッシュ最優先** - Serena Memory を使い倒す

#### ❌ 非効率
```markdown
Phase 1: WebSearch("Flutter trends") → 2,000 tokens
Phase 2: WebSearch("Flutter trends") → 2,000 tokens（重複！）
```

#### ✅ 効率的
```bash
# Phase 1: WebSearch結果をメモリ保存
mcp__serena__write_memory \
  memory_name="market_research" \
  content="[WebSearch結果]"

# Phase 2: メモリから取得（0 tokens）
mcp__serena__read_memory memory_file_name="market_research"
```

**削減効果: 50-70%**

---

### 2. **Just-in-Time 読み込み** - 必要になるまで読まない

#### ❌ 非効率
```bash
# 実装開始時に全部読む
Read .claude/docs/rules/coding_rule.md  # 2,000行 → 22,000 tokens
```

#### ✅ 効率的
```bash
# 必要になった時だけ、必要な章だけ
mcp__serena__find_symbol \
  name_path="Barrel Import規則" \
  relative_path=".claude/docs/rules/coding_rule.md" \
  include_body=true
# → 200 tokens
```

**削減効果: 95-99%**

---

### 3. **並列実行** - 待ち時間を減らす

#### ❌ 非効率（逐次実行）
```
1. flutter analyze 実行 → 待つ → 結果確認
2. flutter test 実行 → 待つ → 結果確認
3. dart format 実行 → 待つ → 結果確認
合計: 3メッセージ × 各1,000 tokens = 3,000 tokens
```

#### ✅ 効率的（並列実行）
```
1メッセージで3コマンド同時実行:
- flutter analyze
- flutter test
- dart format
→ 1メッセージ × 1,500 tokens = 1,500 tokens
```

**削減効果: 50%**

---

### 4. **head_limit 活用** - 全件取得しない

#### ❌ 非効率
```bash
# 全検索結果を取得
mcp__serena__search_for_pattern \
  substring_pattern="hSpace" \
  output_mode="content"
# 結果: 100件 × 50行 = 55,000 tokens
```

#### ✅ 効率的
```bash
# 最初の5件だけ取得
mcp__serena__search_for_pattern \
  substring_pattern="hSpace" \
  output_mode="content" \
  head_limit=5
# 結果: 5件 × 50行 = 2,750 tokens
```

**削減効果: 95%**

---

### 5. **構造化データ活用** - JSONで必要項目のみ

#### ❌ 非効率
```bash
# 全Issue詳細を読む
gh issue view 1 --json body → 2,000 tokens
gh issue view 2 --json body → 2,000 tokens
...
合計: 20 issues × 2,000 = 40,000 tokens
```

#### ✅ 効率的
```bash
# 必要な情報だけ一括取得
gh issue list --json number,title,state,labels --limit 100
# 結果: 構造化データ → 1,500 tokens
```

**削減効果: 96%**

---

### 6. **エラー時のみ詳細** - 成功時は結果だけ

#### ❌ 非効率
```bash
# エラーなしでも全ログ出力
flutter analyze
# 出力: 500行のログ → 5,000 tokens
```

#### ✅ 効率的
```bash
# 成功時は結果のみ
flutter analyze
if [ $? -eq 0 ]; then
  echo "✅ No issues found"  # 10 tokens
else
  flutter analyze  # エラー時のみ詳細
fi
```

**削減効果: 99%**

---

### 7. **明示的指示** - 「全文読み禁止」と書く

#### ❌ 非効率
```markdown
## 実装手順
以下のファイルを参照してください：
- .claude/docs/rules/coding_rule.md
```

#### ✅ 効率的
```markdown
## 実装手順
**重要: 以下は必要になった時のみ参照**

**全文読み禁止！必要な章のみSerenaで読むこと**
```

**削減効果: 92%**

---

### 8. **description 活用** - コマンドの意図を明確に

#### ❌ 非効率
```bash
# 意図不明（Claudeは全ログ読む）
flutter pub run build_runner build
```

#### ✅ 効率的
```bash
# description で意図を明示
Bash command="flutter pub run build_runner build" \
     description="Generate Freezed/Riverpod code"
# Claudeは成功/失敗だけ確認 → 500 tokens
```

**削減効果: 90%**

---

### 9. **grep 優先** - 全文読みより検索

#### ❌ 非効率
```bash
# ファイル全文読んでから検索
Read lib/screen/home/home_screen.dart  # 500行 → 5,000 tokens
```

#### ✅ 効率的
```bash
# grep で直接検索
grep -r "Colors\." lib/screen/home/ --include="*.dart"
# マッチした行のみ → 50 tokens
```

**削減効果: 99%**

---

### 10. **メモリ共有** - Phase/Module間で再利用

#### ❌ 非効率
```
Phase 2: requirements.md 全文読む → 3,000 tokens
Phase 4: requirements.md 全文読む → 3,000 tokens（重複！）
```

#### ✅ 効率的
```bash
# Phase 2: メモリに保存
mcp__serena__write_memory memory_name="requirements" content="..."

# Phase 4: メモリから取得（0 tokens）
mcp__serena__read_memory memory_file_name="requirements"
```

**削減効果: 50%**

---

## 📚 実践例：組み合わせ技

### シナリオ: 品質チェック実行

#### ❌ 最悪パターン（170,000 tokens）
```
1. coding_rule.md 全文読む (22,000 tokens)
2. style_guide.md 全文読む (15,000 tokens)
3. color_management_rule.md 全文読む (8,000 tokens)
4. flutter analyze 全ログ (5,000 tokens)
5. flutter test 全ログ (10,000 tokens)
6. 全ファイルをReadで読む (100,000 tokens)
7. grep結果を全出力 (10,000 tokens)
合計: 170,000 tokens
```

#### ✅ 最善パターン（5,000 tokens）
```
1. メモリに既存パターンがあれば再利用 (0 tokens)
2. 必要な章のみSerenaで読む (500 tokens)
3. 並列実行: analyze & test & format (1,500 tokens)
4. 成功時は結果のみ (100 tokens)
5. grep検索（head_limit=5） (500 tokens)
6. エラー時のみ詳細確認 (2,400 tokens)
合計: 5,000 tokens

削減: 97%削減！
```

---

## 🎯 スラッシュコマンドでの活用

### コマンドファイルに記載すべき指示

```markdown
## 🤖 Claude Code への実行指示

**重要: トークン効率化ルール（厳守）**

### ⚠️ 段階的読み込み必須

**IMPORTANT:** 必ず以下の順序で、**現在のPhaseのみ**読み込むこと：

1. **Phase 1実行中**: phase1.md **のみ**読み込み
   - 完了まで次のPhaseは読み込まない
2. **Phase 2実行中**: phase2.md **のみ**読み込み

**❌ 禁止:** 全Phaseを一度に読み込むこと
**✅ 正しい:** 現在実行中のPhaseのみ読み込む

---

### その他の効率化ルール

1. **Serena活用**: ドキュメントは章単位で読み込み
2. **並列実行**: 独立したタスクは1メッセージで実行
3. **メモリ活用**: Phase間でメモリを活用
```

---

## 📖 関連ドキュメント

- [Serena MCP ドキュメント](../serena/README.md)
- [コーディング規約](../rules/coding_rule.md)
- [リリースコマンド一覧](../../commands/release/README.md)

---

## ✅ チェックリスト

コマンド作成時に以下を確認：

- [ ] ファイルを分割し、モジュール化しているか
- [ ] 段階的読み込みの明示的指示があるか
- [ ] Serena活用の具体例を記載しているか
- [ ] メモリ活用の指示があ��か
- [ ] 並列実行可能な箇所を明示しているか
- [ ] エラー時のみ詳細表示の指示があるか
- [ ] head_limit使用を推奨しているか
- [ ] grep優先の指示があるか

---

**このベストプラクティスに従うことで、平均70-80%のトークン削減が可能です！**
