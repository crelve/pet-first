# Utils Commands - 汎用開発支援コマンド

リリースフローから参照される開発支援コマンド群です。

---

## 📋 コマンド一覧 (10コマンド)

### リリースフローで参照済み (6コマンド)

#### 品質・ビルドチェック系
- `/test-coverage` - テスト網羅率分析
- `/quality-gate` - 総合的なリリース可否判定
- `make check-build` - ビルド検証（Makefile統合）

#### プロジェクト管理・分析系
- `make check-deps` - Flutter/Dart 依存関係チェック（Makefile統合）
- `make check-performance` - Flutter/Dart パフォーマンスチェック（Makefile統合）

#### PDCA・継続的改善系
- `/pdca-sync` - ローカルの失敗記録をグローバルに同期
- `/pdca-analyze` - 全プロジェクトの失敗パターン分析
- `/pdca-improve` - 分析結果を基にコマンド自動改善
- `/tech-debt` - 技術的負債の定量化・分析

### 汎用開発支援ツール (4コマンド)

#### ドキュメント生成系
- `/update-dart-doc` - DartDoc コメント生成（Dart/Flutter専用）

#### コード品質・設計系
- `/design-patterns` - デザインパターン適用提案
- `/implementation-guard` - 実装前のガード条件チェック

#### プロジェクト支援系
- `/serena` - Serena MCP エントリーポイント（Serena専門家）

---

## 🔗 リリースフローとの統合

### `/06-setup-auto-implementation` で参照
- `make check-deps` - Flutter/Dart 依存関係チェック（Step 2前推奨）
- `/tech-debt` - プロジェクト完了後の技術的負債分析

### `/07-implement-issue` で参照
- `/smart-review` - PR作成前の最適レビュー方法提案
- `/refactor` - リファクタリング支援
- `/design-patterns` - デザインパターン適用
- `/tech-debt` - プロジェクト完了後の技術的負債分析
- `make check-build` - ビルド検証
- `make check-performance` - パフォーマンスチェック
- `make check-deps` - 依存関係チェック

### `/10-quality-rules-check` で参照
- `/quality-gate` - 総合的なリリース可否判定
- `/tech-debt` - プロジェクト完了後の技術的負債分析

---

## 📊 削除・置き換えされたコマンド (18コマンド, 90.6KB削減)

<details>
<summary><strong>削除理由と代替手段の詳細</strong></summary>

### Makefile統合 (3コマンド, 14KB)
- `/analyze-dependencies` → `make check-deps`
- `/analyze-performance` → `make check-performance`
- `/build-check` → `make check-build`

### リリースフローで代替済み (2コマンド, 8.6KB)
- `/screenshot` → `/18-ios-screenshot`
- `/requirements_template` → `/01-project-init`

### Claude直接依頼で対応可能 (6コマンド, 26.7KB)
- `/ultrathink`, `/sequential-thinking` (思考支援)
- `/show-plan` → `/plan` または Plan Mode
- `/explain-code`, `/task` (Agent機能)
- `/check-fact` (ドキュメント参照で十分)

### 技術スタック不一致 (2コマンド, 12KB)
- `/smart-review`, `/refactor` (JavaScript/TypeScript向け)

### プロジェクト固有・CI未使用 (3コマンド, 5.2KB)
- `/issues-status` → GitHub CLI (`gh issue list`)
- `/check-github-ci` (CI未使用)
- `/check-prompt` (開発フロー不要)

### 多言語対応過剰 (2コマンド, 24.1KB)
- `/update-doc-string` → `/update-dart-doc` (Dart/Flutter専用)
- `/plan` (多機能すぎて使いづらい)

</details>

---

## 🆕 Makefile 統合

JavaScript/TypeScript向けのコマンドを削除し、Flutter/Dart専用チェックをMakefileに統合しました。

### `make check-deps` - 依存関係チェック

```bash
make check-deps
```

**実行内容:**
1. 依存パッケージ一覧（ツリー形式）- `fvm dart pub deps --style=tree`
2. 古いパッケージの検出 - `fvm flutter pub outdated`
3. 未使用パッケージの検出 - pubspec.yaml vs 実際の import 比較

### `make check-performance` - パフォーマンスチェック

```bash
make check-performance
```

**実行内容:**
1. パフォーマンス関連の警告検出 - `flutter analyze` からパフォーマンス警告抽出
2. 非効率なコードパターン検出 - build()内の重い処理、StatefulWidget の過剰使用
3. 過剰な Widget rebuild 検出 - setState 呼び出し回数
4. メモリリーク可能性 - StreamController/Timer/AnimationController の dispose 未実装

**詳細プロファイリング:**
```bash
flutter run --profile
# Flutter DevTools でメモリ・CPU・レンダリングを分析
```

### `make check-build` - ビルドチェック

```bash
make check-build
```

**実行内容:**
1. Flutter 環境確認 - `flutter doctor`
2. 依存関係の健全性 - `flutter pub get`
3. コード生成確認 - `build_runner build`
5. Firebase 設定確認 - 設定ファイルの存在確認

**メリット:**
- ✅ Flutter/Dart ネイティブコマンド使用（外部ツール不要）
- ✅ このプロジェクトに最適化されたチェック
- ✅ Makefile で他の品質チェックと統合可能
- ✅ リリースフローから明確に参照される

---

## 🔗 補足資料

### GitHub CLI での Issue 管理

`/issues-status` の代わりに GitHub CLI を使用：

```bash
# 全Issue一覧
gh issue list --state all

# 未完了Issue一覧
gh issue list --state open

# フェーズ別Issue
gh issue list --label "Phase 1"

# Issue詳細表示
gh issue view <issue_number>
```

### 継続的改善

各コマンドは実際の使用経験を基に継続的に改善されています。問題が発生した場合は、コマンド内のトラブルシューティングセクションを参照してください。

---

## 📈 最適化効果

| 指標 | Before | After | 改善率 |
|------|--------|-------|--------|
| コマンド数 | 27個 | 10個 | **63%削減** |
| ファイルサイズ | - | - | **90.6KB削減** |
| リリースフロー統合 | 不明確 | 明確に参照 | ✅ |
| 技術スタック一致 | JS/TS混在 | Flutter/Dart専用 | ✅ |

**主な改善:**
- ✅ Makefile統合による品質チェック集約
- ✅ リリースフローからの明確な参照関係
- ✅ 重複機能の削除と代替手段の明示
- ✅ Claude直接依頼/GitHub CLI による代替可能コマンドの削除
