# Step 3: 初期実装準備

## 目的
プロジェクト固有のテンプレートファイル生成・ディレクトリ構造整備

---

## 実行フロー

### 1. ディレクトリ構造確認
```bash
# 必須ディレクトリの存在確認
required_dirs=(
  "lib/screen"
  "lib/component"
  "lib/provider"
  "lib/model"
  "lib/utility"
  "lib/hook"
  "lib/route"
  "test/unit"
  "test/widget"
  "test/integration"
)

for dir in "${required_dirs[@]}"; do
  mkdir -p "$dir"
done
```

### 2. テンプレートファイル生成
```bash
# Serena で既存パターンを確認
mcp__serena__list_dir relative_path="lib/screen" recursive=false

# 既存パターンに従ってテンプレート作成
# （プロジェクト固有の命名規則・構造を維持）
```

### 3. import/export整備
```bash
# barrel importファイル確認
ls -la lib/import/

# 不足している場合は作成
# - lib/import/model.dart
# - lib/import/component.dart
# - lib/import/utility.dart
```

### 4. 最終確認
```bash
# プロジェクト構造確認
tree lib/ -L 2

# 静的解析最終チェック
flutter analyze

# Expected: ✅ Project structure ready
```

---

## 🤖 Claude Code への指示

**トークン効率化:**
- Serena で既存ディレクトリ構造を効率的に確認
- テンプレート生成は最小限（既存パターンに従う）
- Step 1のメモリから要件情報を参照（必要に応じて）
