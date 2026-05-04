# 基本適合性チェック

## 目的
コード品質・実装完全性の基本チェック

---

## チェック項目

### 1. コード品質チェック
```bash
# 静的解析
flutter analyze

# Expected: No issues found
```

### 2. 実装完全性チェック
```bash
# TODOコメント検出
grep -r "TODO\|FIXME" lib/ --include="*.dart"

# 未実装関数検出
grep -r "throw UnimplementedError" lib/ --include="*.dart"

# Expected: 0件（本番環境準備完了）
```

### 3. テストカバレッジ
```bash
flutter test --coverage
```

---

## 要件との照合

各要件（REQ-XXX）に対して：
- 対応するコードが実装されているか
- テストが書かれているか
- ドキュメントが更新されているか

---

## 🤖 Claude Code への指示

**トークン効率化:**
- チェックコマンドは並列実行可能
- エラーなしの場合、詳細出力不要
- Issue-mappingモジュールのメモリから要件一覧を参照
