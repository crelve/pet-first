## Flutter Analyze

Flutter/Dartプロジェクトの包括的なコード分析と品質向上提案を行います。

### 使い方

```bash
# 基本的なコード分析
fvm dart analyze
「分析結果を詳細に解説し、各問題の修正方法を具体的に提案してください」

# 重要度別の問題分類
fvm dart analyze --format=json | jq '.diagnostics[] | select(.severity=="ERROR")'
「エラーレベルの問題を優先的に解決する手順を教えてください」

# 特定ディレクトリの分析
fvm dart analyze lib/provider/
「プロバイダー層の設計品質と改善点を評価してください」
```

### 分析カテゴリ

```
🔴 Errors (必須修正)
├─ 構文エラー
├─ 型エラー  
├─ 未定義参照
└─ インポートエラー

🟡 Warnings (推奨修正)
├─ Dead Code
├─ Unused Variables
├─ Deprecated APIs
└─ Performance Issues

🔵 Info (改善提案)
├─ Documentation
├─ Code Style
├─ Best Practices
└─ Refactoring Opportunities

💡 Lints (品質向上)
├─ Dart/Flutter Lints
├─ Custom Rules
├─ Team Conventions
└─ Accessibility
```

### Flutter特化分析

```bash
# Widget分析
grep -r "StatefulWidget\|StatelessWidget" lib/ --include="*.dart" | wc -l
「Widget設計の複雑度と最適化機会を分析してください」

# 状態管理分析
grep -r "setState\|Provider\|Riverpod\|BLoC" lib/ --include="*.dart"
「状態管理パターンの一貫性と効率性を評価してください」

# パフォーマンス分析
grep -r "ListView\|GridView\|PageView" lib/ --include="*.dart"
「リストとスクロール可能Widgetのパフォーマンスを確認してください」
```

### 高度な分析

```bash
# 循環依存の検出
fvm dart analyze --format=json | jq '.diagnostics[] | select(.code=="circular_dependency")'
「循環依存を解決するリファクタリング手順を提案してください」

# メモリリーク分析
grep -r "StreamController\|Animation.*Controller\|TextEditingController" lib/ --include="*.dart"
「リソース管理とdisposeパターンを確認してください」

# アクセシビリティ分析
grep -r "Semantics\|semantic" lib/ --include="*.dart"
「アクセシビリティ対応の改善点を指摘してください」
```

### 分析レポート形式

```markdown
## Flutter分析レポート

### 概要
- 分析ファイル数: X個
- 検出問題数: Y個
- 重要度分布: Error(A), Warning(B), Info(C)

### 優先修正項目

#### 🔴 Critical Issues (即座修正必要)
1. **[問題種別]** ファイル: `path/to/file.dart:行番号`
   - 問題: [具体的な問題]
   - 影響: [問題の影響範囲]
   - 修正: [具体的な修正方法]

#### 🟡 Important Warnings (推奨修正)
[同様の形式]

#### 🔵 Improvement Suggestions (改善提案)
[同様の形式]

### カテゴリ別分析

#### Widget設計
- 複雑なStatefulWidget: X個
- 最適化可能なWidget: Y個
- 推奨リファクタリング: [提案]

#### 状態管理
- setState使用箇所: X個
- Provider/Riverpod使用: Y個
- 状態管理の一貫性: [評価]

#### パフォーマンス
- 重いWidget: [特定]
- 不必要な再構築: [検出]
- 最適化機会: [提案]

### 修正優先度

1. **即座対応** (ビルドブロッカー)
   - [修正項目リスト]

2. **短期対応** (品質向上)
   - [修正項目リスト]

3. **中長期対応** (技術的負債)
   - [修正項目リスト]

### 推奨設定

#### analysis_options.yaml
```yaml
# 推奨lintルール
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
linter:
  rules:
    # 追加推奨ルール
    - avoid_print
    - prefer_const_constructors
    - use_build_context_synchronously
```

### 自動修正コマンド

```bash
# 自動修正可能な項目
dart fix --apply

# フォーマット統一
dart format lib/

# インポート整理
dart fix --apply lib/
```
```

### 継続的品質管理

```bash
# プリコミットフック
echo 'fvm dart analyze --fatal-infos' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# CI/CD統合
# .github/workflows/analyze.yml
name: Analyze
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart analyze --fatal-infos
```

### ベストプラクティス

```
✅ 定期実行
- 毎日の開発開始時
- PR作成前
- リリース前

✅ チーム統一
- analysis_options.yamlの共有
- Custom Lintルールの定義
- 修正ガイドラインの策定

✅ 段階的改善
- 新規コードは必須遵守
- 既存コードは段階的修正
- 技術的負債の計画的解消
```