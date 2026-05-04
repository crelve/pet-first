# 📊 Module: アプリ構造完成度検証

**対象:** `/release:step:08-requirements-check --verify-structure`

このモジュールは、アプリケーション構造の完成度を包括的に検証し、Phase 3完了判定を行います。

---

## 🎯 検証目的

- **Phase 3完成の公式確認**
- **アプリ構造100%完成の検証**
- **要件定義との完全適合性チェック**
- **次フェーズ移行の可否判定**
- **完成度スコアの算出**

---

## 📋 検証項目

### 1. 画面構造完成度チェック (25%)

#### ✅ 必須画面の実装確認

```bash
# Serena活用で効率的にチェック
mcp__serena__find_file file_mask="*_screen.dart" relative_path="lib/screen"
```

**確認すべき画面:**
- [ ] 認証系: `LoginScreen`, `SignupScreen`
- [ ] オンボーディング: `WalkThroughScreen`
- [ ] メインハブ: `BaseScreen` (タブナビゲーション)
- [ ] コア機能画面: 要件定義の主要機能に対応する画面
- [ ] 設定: `SettingScreen`

**チェック方法:**
```bash
# 各画面の存在確認
mcp__serena__find_symbol name_path="/LoginScreen" relative_path="lib/screen" include_kinds=[5]

# 画面数カウント
find lib/screen -name "*_screen.dart" -type f | wc -l
```

#### ✅ 画面遷移の完全性

**確認方法:**
```bash
# ルート定義の確認
mcp__serena__get_symbols_overview relative_path="lib/route/route.dart"

# GoRouter設定の確認
mcp__serena__find_symbol name_path="router" relative_path="lib/route/route.dart" include_body=true
```

**チェックポイント:**
- [ ] 全画面がルート定義に登録されている
- [ ] 認証フロー: Login → 目標設定 → Dashboard
- [ ] メインフロー: タブナビゲーション動作
- [ ] 設定フロー: 各設定画面への遷移・復帰

---

### 2. コア機能実装度チェック (35%)

#### ✅ 要件定義の主要機能実装状況

**確認方法:**
```bash
# docs/project/requirements.md から主要機能を抽出
mcp__serena__search_for_pattern \
  substring_pattern="## REQ-\d{3}:" \
  relative_path="docs/project/requirements.md" \
  output_mode="content"

# 各機能に対応するプロバイダー・モデルの存在確認
mcp__serena__find_file file_mask="*_provider.dart" relative_path="lib/provider"
mcp__serena__find_file file_mask="*.dart" relative_path="lib/model"
```

**チェックポイント:**
- [ ] 認証・ユーザー管理機能 (REQ-001)
- [ ] コアビジネスロジック (REQ-003~REQ-010)
- [ ] データ管理機能 (REQ-006~REQ-008)
- [ ] 分析・レポート機能 (REQ-012~REQ-013)

#### ✅ Firebase統合状況

**確認方法:**
```bash
# Firebase設定ファイルの存在確認
test -f lib/firebase_options.dart && echo "✅ Firebase設定OK"

# Firebase初期化コードの確認
mcp__serena__search_for_pattern \
  substring_pattern="Firebase\.initializeApp" \
  relative_path="lib" \
  restrict_search_to_code_files=true
```

**チェックポイント:**
- [ ] Firebase Auth連携
- [ ] Firestore データベース
- [ ] Firebase Analytics
- [ ] その他必要なFirebaseサービス

---

### 3. 技術基盤完成度チェック (20%)

#### ✅ 状態管理の一貫性

**確認方法:**
```bash
# Riverpod プロバイダーの確認
mcp__serena__search_for_pattern \
  substring_pattern="Provider<|StateProvider<|FutureProvider<|StreamProvider<" \
  relative_path="lib/provider" \
  output_mode="count"

# HookConsumerWidget使用状況
mcp__serena__search_for_pattern \
  substring_pattern="extends HookConsumerWidget" \
  relative_path="lib" \
  restrict_search_to_code_files=true \
  output_mode="count"
```

**チェックポイント:**
- [ ] グローバル状態管理の一貫性
- [ ] HookConsumerWidget の適切な使用
- [ ] プロバイダー間の依存関係

#### ✅ ナビゲーション基盤

**確認方法:**
```bash
# GoRouter設定の包括性チェック
mcp__serena__find_symbol \
  name_path="router" \
  relative_path="lib/route/route.dart" \
  include_body=true \
  depth=1
```

**チェックポイント:**
- [ ] GoRouter の一元管理
- [ ] リダイレクト処理の実装
- [ ] エラーハンドリング

---

### 4. 品質・パフォーマンス (15%)

#### ✅ 静的解析・テスト

**確認方法:**
```bash
# 自動テスト実行
flutter analyze --no-fatal-infos
flutter test --coverage

# テストカバレッジ確認
lcov --summary coverage/lcov.info 2>/dev/null || echo "⚠️ カバレッジデータなし"
```

**チェックポイント:**
- [ ] `flutter analyze` エラー0件
- [ ] テストが存在する
- [ ] クリティカルバグなし

#### ✅ ビルド検証

**確認方法:**
```bash
# デバッグビルドの成功確認
flutter build ios --debug --simulator --quiet && echo "✅ iOS Debug Build OK"
```

**チェックポイント:**
- [ ] iOS デバッグビルド成功

---

### 5. UI/UX基盤 (5%)

#### ✅ テーマシステム

**確認方法:**
```bash
# テーマ定義の確認
mcp__serena__find_symbol \
  name_path="lightTheme|darkTheme" \
  relative_path="lib/theme" \
  substring_matching=true

# ColorName使用状況
test -f lib/gen/colors.gen.dart && echo "✅ ColorName生成済み"
```

**チェックポイント:**
- [ ] ライト/ダークテーマ定義
- [ ] ColorName による色管理
- [ ] Material Design 3対応

---

## 📊 完成度スコア算出

### スコア計算式

```javascript
// 各カテゴリのスコア (0-100)
const screenScore = (実装画面数 / 必須画面数) * 100;
const featureScore = (実装機能数 / 要件機能数) * 100;
const navigationScore = (実装ルート数 / 必須ルート数) * 100;
const technicalScore = (チェック通過数 / チェック項目数) * 100;
const qualityScore = (品質基準達成数 / 品質基準数) * 100;

// 総合完成度スコア
const completionScore = (
  screenScore * 0.25 +           // 画面実装 (25%)
  featureScore * 0.35 +          // コア機能 (35%)
  navigationScore * 0.20 +       // ナビゲーション (20%)
  technicalScore * 0.15 +        // 技術基盤 (15%)
  qualityScore * 0.05            // 品質指標 (5%)
);

// Phase 3完成基準: 95%以上
const isPassed = completionScore >= 95;
```

---

## 🎯 Phase 3完成基準

### ✅ 合格条件 (completionScore >= 95%)

1. **画面構造**: 全必須画面の実装と連携完成
2. **コア機能**: 要件定義の主要機能85%以上実装
3. **ナビゲーション**: 完全な画面遷移フロー
4. **技術基盤**: 安定したアーキテクチャ基盤
5. **品質**: クリティカルバグなし・基本パフォーマンス達成

### ⚠️ 不合格の場合

1. **不足項目の詳細リスト作成**
2. **追加実装タスクの定義**
3. **Phase 3延長の判定**
4. **優先度別対応方針策定**

---

## 📝 検証レポート形式

### 実行結果

```markdown
# Phase 3アプリ構造完成度検証結果

## 総合完成度スコア: XX.X%

### 詳細スコア
- 🖥️ 画面実装: X/X画面 (XX%) [25%加重]
- ⚙️ コア機能: X/X機能 (XX%) [35%加重]
- 🔀 ナビゲーション: X/Xルート (XX%) [20%加重]
- 🏗️ 技術基盤: X/X項目 (XX%) [15%加重]
- ✅ 品質指標: X/X基準 (XX%) [5%加重]

## Phase 3完成判定: [✅ 合格 (95%以上) / ❌ 要追加実装]

## 実装済み項目
- ✅ [項目名]: [詳細]
- ✅ ...

## 未実装・不足項目
- ❌ [項目名]: [詳細・対応方針]
- ⚠️ ...

## 次のアクション
1. [Phase 4移行] または [追加実装タスク]
2. 残存課題の優先度付け
3. リリース予定への影響評価
```

---

## 🤖 Claude Code への実行指示

### 実行手順

1. **画面構造チェック (25%)**
   ```bash
   # 画面ファイル一覧取得
   find lib/screen -name "*_screen.dart" -type f

   # 各画面の実装確認 (Serena活用)
   mcp__serena__find_symbol name_path="/LoginScreen" ...
   ```

2. **コア機能チェック (35%)**
   ```bash
   # 要件定義から主要機能抽出
   mcp__serena__search_for_pattern substring_pattern="## REQ-\d{3}:" ...

   # 各機能の実装状況確認
   mcp__serena__find_file file_mask="*_provider.dart" ...
   ```

3. **技術基盤チェック (20%)**
   ```bash
   # 状態管理パターン確認
   mcp__serena__search_for_pattern substring_pattern="Provider<" ...

   # ルート定義確認
   mcp__serena__get_symbols_overview relative_path="lib/route/route.dart"
   ```

4. **品質チェック (15%)**
   ```bash
   # 静的解析・テスト実行
   flutter analyze --no-fatal-infos
   flutter test
   ```

5. **UI/UX基盤チェック (5%)**
   ```bash
   # テーマ・色管理確認
   mcp__serena__find_symbol name_path="lightTheme" ...
   test -f lib/gen/colors.gen.dart
   ```

6. **スコア算出・レポート作成**
   - 各カテゴリのスコア計算
   - 総合完成度スコア算出
   - Phase 3完成判定
   - 詳細レポート生成

### トークン効率化ポイント

- ✅ **Serena優先**: 全ファイル読み込みを避ける
- ✅ **並列実行**: 独立したチェックは並列実行
- ✅ **結果キャッシュ**: 同じ情報の重複取得を避ける
- ✅ **段階的詳細化**: 問題がある箇所のみ詳細調査

---

## 📊 期待される成果

- ✅ アプリ構造の客観的な完成度評価
- ✅ Phase 3完了の明確な判定基準
- ✅ 不足項目の具体的なリスト化
- ✅ Phase 4移行の判断材料提供
- ✅ トークン効率的な検証プロセス
