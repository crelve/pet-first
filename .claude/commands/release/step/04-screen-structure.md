# 📱 Step 04: 画面構成設計

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->
<!-- AUTO_EXECUTE: true -->
<!-- NO_USER_INPUT: true -->

<!-- PROGRESS_COMMAND_ID: 04-screen-structure -->
<!-- PROGRESS_PHASE: phase1 -->
<!-- PROGRESS_NAME: 画面構成設計 -->
<!-- PROGRESS_TYPE: auto -->
<!-- PROGRESS_ESTIMATED_TIME: 5-10 -->
<!-- PROGRESS_DEPENDENCIES: ["01-project-init"] -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_EXECUTION_START: -->
<!-- PROGRESS_EXECUTION_END: -->
<!-- PROGRESS_DURATION_MINUTES: -->
<!-- PROGRESS_RESULT: -->
<!-- PROGRESS_LOGS: [] -->

**実行時間**: 5-10分

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → MVP機能リストに基づく画面構成"
```

企画書が存在する場合、MVP機能リスト（P0/P1）を読み取り、画面構成の優先順位に反映する。

---

要件定義ベースで画面構成・遷移設計を自動生成します。

### 🎨 必須参照スキル（UXデザイン品質）
- **[Apple Design SKILL](../../../skills/apple-design/SKILL.md)** - iOS HIG準拠・Apple風UI設計
- **[UX Psychology](../../../skills/apple-design/references/ux-psychology.md)** - 47個のUX心理学コンセプト

画面設計時に必ず以下を考慮してください：
- ドハティの閾値（400ms以内の応答）
- ヒックの法則（選択肢5-7個以下）
- 系列位置効果（重要項目を最初と最後に）
- フィッツの法則（44pt以上のタップターゲット）

---

## 🤖 AI自動実行フロー

### Phase 1: 要件分析・画面抽出
📋 **要件定義から必要画面を抽出・分類**

**分析項目:**
1. **📄 要件定義解析** - docs/project/requirements.md の機能要件解析
2. **🎯 ユーザーストーリー抽出** - 主要ユーザーフロー特定
3. **📱 必要画面リスト** - Core画面・Sub画面・Modal画面の分類
4. **🔗 画面間関係性** - 遷移の必要性・頻度・重要度分析
5. **👤 ユーザー体験設計** - 直感的操作・迷わないナビゲーション

### Phase 2: 画面構成設計
🏗️ **実装しやすい画面構成を設計**

**設計アプローチ:**
1. **📱 Flutter標準パターン活用** - AppBar, BottomNavigationBar, Drawer等
2. **🎨 Material Design準拠** - Google推奨UI/UXパターン
3. **📐 レスポンシブ対応** - iPhone SE〜iPad Pro対応
4. **♿ アクセシビリティ** - 基本的なaccessibility対応
5. **⚡ パフォーマンス考慮** - 軽量・高速表示設計

### Phase 3: 画面遷移フロー設計
🗺️ **直感的なナビゲーション設計**

**遷移設計原則:**
1. **🧭 明確な階層構造** - 論理的画面階層・パンくずリスト
2. **↩️ 戻る操作統一** - Back button・ジェスチャー対応
3. **🏠 ホーム復帰** - 常にホーム画面への復帰経路確保
4. **⚠️ エラー時対応** - ネットワークエラー・権限エラー時の画面遷移
5. **🔄 状態管理考慮** - 画面間データ共有・状態保持設計

### Phase 4: UI設計指針作成
🎨 **統一感のあるUI設計ガイドライン**

**設計ガイドライン:**
1. **🎨 カラーパレット** - Primary/Secondary/Surface色の選定
2. **🔤 タイポグラフィ** - 見出し・本文・キャプションの階層設計
3. **📏 間隔・サイズ** - Margin, Padding, Icon size統一
4. **🖼️ 画像・アイコン** - 必要素材リスト・サイズ指定
5. **⚡ アニメーション** - 画面遷移・ローディング・フィードバック

### Phase 5: 技術仕様定義
⚙️ **実装に必要な技術情報を整理**

**技術項目:**
1. **📂 画面ファイル構成** - lib/screen/ 以下のディレクトリ設計
2. **🎛️ 状態管理方針** - Riverpod Provider設計指針
3. **🗺️ ルーティング設計** - GoRouter ルート定義
4. **🔌 API連携設計** - Firebase Firestore スキーマ連携
5. **📱 プラットフォーム対応** - iOS固有対応項目

---

## 📝 成果物

### 1. 画面構成一覧 (screen_structure.md)
```markdown
# 画面構成一覧

## Core画面 (5-8画面)
- ホーム画面 (主要機能アクセス)
- 機能A画面 (メイン機能)
- 機能B画面 (サブ機能)
- 設定画面 (アプリ設定・ユーザー設定)
- プロフィール画面 (ユーザー情報)

## Sub画面 (3-5画面)
- 詳細画面群
- 入力・編集画面群
- 結果・一覧画面群

## Modal/Dialog (2-3画面)
- 確認ダイアログ
- エラー表示
- ローディング画面
```

### 2. 画面遷移フロー図 (navigation_flow.md)
```markdown
# 画面遷移フロー

## メイン遷移フロー
ホーム → 機能A → 詳細A → 編集A → ホーム

## サブ遷移フロー
設定 → プロフィール編集 → 保存確認 → 設定

## エラー時フロー
任意画面 → エラー表示 → ホーム復帰
```

### 3. UI設計ガイドライン (ui_guidelines.md)
```markdown
# UI設計ガイドライン

## カラーパレット
- Primary: #2196F3 (Blue)
- Secondary: #FF9800 (Orange)
- Surface: #FFFFFF (White)
- Error: #F44336 (Red)

## タイポグラフィ
- H1: 24sp, Bold
- H2: 20sp, Medium
- Body: 16sp, Regular
- Caption: 12sp, Regular
```

### 4. 実装仕様書 (implementation_spec.md)
```markdown
# 実装仕様書

## ファイル構成
```
lib/screen/
├── home/
│   ├── home_screen.dart
│   └── home_provider.dart
├── feature_a/
│   ├── feature_a_screen.dart
│   └── feature_a_provider.dart
└── settings/
    ├── settings_screen.dart
    └── settings_provider.dart
```

## ルーティング設計
```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/feature-a', builder: (context, state) => FeatureAScreen()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
  ],
);
```
```

---

## ✅ 完了条件

### 必須条件
- [ ] 📱 **画面構成一覧完成**: 主要画面5-8画面の明確な定義
- [ ] 🗺️ **画面遷移フロー完成**: 主要フロー・エラーフロー・戻るフロー設計
- [ ] 🎨 **UI設計指針完成**: 色・フォント・間隔・アイコンガイドライン
- [ ] ⚙️ **実装仕様書完成**: ファイル構成・ルーティング・状態管理方針

### 品質基準
- [ ] **🎯 一貫性**: 全画面で統一されたUI/UX設計
- [ ] **📱 Flutter準拠**: Material Design・Flutter標準Widget活用
- [ ] **♿ アクセシビリティ**: 基本的なaccessibility対応
- [ ] **⚡ パフォーマンス**: 軽量・高速表示を考慮した設計
- [ ] **🔄 拡張性**: 今後の機能追加に対応可能な設計

### 実装準備完了
- [ ] **📂 ファイル構成明確化**: 各画面のファイルパス・ファイル名確定
- [ ] **🎛️ 状態管理設計**: Riverpod Provider設計方針確定
- [ ] **🗺️ ルーティング準備**: GoRouter設定内容確定
- [ ] **🔌 データ連携準備**: Firebase Firestore連携部分の設計確定

### テンプレート更新（必須）
- [ ] **🏠 base_screen.dart更新**: 設計に基づいてタブ構成を更新
  - `lib/screen/base_screen.dart`の`IndexedStack`内の画面を要件に合わせて変更
  - プレースホルダーの`SettingScreen`を適切な画面に置き換え
  - 不要なタブがあれば削除、必要なタブがあれば追加
  - `BottomNavigationBarItem`のアイコン・ラベルを適切に更新

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:04-screen-structure`**
   ↓
   - [x] **`/release:step:04-screen-structure`**

2. セクションステータス更新:
   Auto01の全コマンドが完了したら: 🔄 進行中 → ✅ 完了
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**

