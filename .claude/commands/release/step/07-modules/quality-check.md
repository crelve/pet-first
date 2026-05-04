# ✅ 品質チェックガイド


## 目的
本番環境準備度の完全検証（プロトタイプ検出含む）

---

## 必須品質チェック

### 🚀 推奨：包括的品質ルールチェック（コミット前必須）

**コミット前に `make check-quality-rules-full` を必ず実行してください。**

```bash
# 包括的品質ルールチェック実行（12項目の詳細チェック）
make check-quality-rules-full

# 自動実行内容:
# Step 1: 色管理ルールチェック & 即修正
# Step 2: 既存パターン確認
# Step 3: 統合品質チェック & 即修正
# Step 4: 静的解析詳細チェック & 即修正
# Step 5: 詳細品質ルールチェック & 即修正
#   - Barrel Import規則
#   - コンポーネント使用規則
#   - 色管理ルール
#   - ルート定義一元化
#   - Snackbar使用規則
#   - 例外処理規則
#   - Switch文規則
#   - ログ出力規則
#   - テーマアクセス規則
#   - 多言語化対応（日本語・英語ハードコード禁止）
#   - Import順序
#   - const修飾子

# Expected: ✅ すべてのチェック完了、coding_rule.md完全準拠
```

### 📋 最小限チェック（緊急時のみ）

緊急時や軽微な修正時は、以下の最小限チェックでも可：

```bash
# ワンコマンドで基本チェック実行
make check-ready

# 自動実行内容:
# 1. check-production-ready（プロトタイプ検出）
# 2. dart format（コードフォーマット）
# 3. flutter analyze（静的解析）
# 4. flutter test（テスト実行）

# Expected: ✅ All checks passed! Ready to push.
```

**⚠️ 注意**: `make check-ready` は最小限のチェックです。
**本番環境品質担保のため、通常は `make check-quality-rules-full` を使用してください。**

---

## プロトタイプ検出チェック

### 🚨 本番環境準備度チェック（すべて0件必須）

```bash
# 1. TODOコメント検出（0件必須）
grep -r "TODO\|FIXME\|XXX\|HACK" lib/ --include="*.dart"
# Expected: (検索結果なし)

# 2. 仮データ検出（0件必須）
grep -r "dummy\|mock\|fake\|test\|sample" lib/ --include="*.dart" -i
# Expected: (変数名・クラス名に仮データ用の命名がないこと)

# 3. 未実装エラーハンドリング検出（0件必須）
grep -r "UnimplementedError\|throw Exception('Not implemented" lib/ --include="*.dart"
# Expected: (検索結果なし)

# 4. プレースホルダーテキスト検出（0件必須）
grep -r "Lorem ipsum\|placeholder\|TBD\|coming soon" lib/ --include="*.dart" -i
# Expected: (検索結果なし)
```

または

```bash
# 統合スクリプト実行
make check-production-ready

# Expected: 🎉 本番環境準備完了！
```

---

## 個別チェック（トラブルシューティング時）

### 1. コードフォーマット（統一必須）
```bash
make format
# Expected: 🎨 Formatting code...
```

### 2. 静的解析チェック（エラー0件必須）
```bash
make analyze
# Expected: 🔍 Running static analysis... No issues found!
```

### 3. テスト実行（全合格必須）
```bash
make test
# Expected: All tests passed!
```

### 4. 依存関係確認（環境問題時）
```bash
flutter doctor
# Expected: No issues found
```

---

## 本番環境準備度チェックリスト

すべて✅必須:

- [ ] エラーメッセージがユーザーフレンドリーか
- [ ] ローディング状態が適切に表示されるか
- [ ] ネットワークエラー時の適切なフォールバック実装済みか
- [ ] 空データ状態の適切なUI実装済みか
- [ ] データ検証ロジックが実装済みか
- [ ] パフォーマンス最適化実装済みか（大量データ対応等）

---

## 🤖 Claude Code への指示

**品質チェックの実行順序:**

### ステップ1: 包括的品質ルールチェック実行（必須）
```bash
# コミット前に必ず実行
make check-quality-rules-full
```

このコマンドは以下を自動実行：
1. **色管理ルールチェック** - ColorName/theme.appColors使用確認
2. **既存パターン確認** - プロジェクト固有のコーディングパターン把握
3. **統合品質チェック** - format/analyze/test一括実行
4. **静的解析詳細チェック** - flutter analyzeの詳細確認
5. **詳細品質ルールチェック** - 12項目の品質ルール完全準拠確認
   - **特に重要**: 多言語化対応（日本語・英語ハードコード禁止）

### ステップ2: チェック結果の確認
- `make check-quality-rules-full` が全て✅になるまで修正を繰り返す
- エラーが0件になったことを確認

### ステップ3: 最終確認
```bash
# 最終的に make check-ready でも確認
make check-ready

# Expected: ✅ All checks passed! Ready to push.
```

---

**トークン効率化:**
- `make check-quality-rules-full` は高速（1-2分で完了）
- エラー出力のみ詳細確認（成功時は簡潔に）
- チェック結果をメモリに保存（PR作成時に再利用）

**品質担保の重要性:**
- **各Issue実装後に必ず `make check-quality-rules-full` を実行**
- 12項目のコーディング規約完全準拠を確保
- 違反を早期発見・修正することで、Step 10の工数をほぼゼロに
- 特に多言語化対応は厳密にチェック（日本語・英語両方）
