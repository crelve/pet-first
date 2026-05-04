# 🎨 Step 02: ブランドカラー設定

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->
<!-- AUTO_EXECUTE: false -->

<!-- PROGRESS_COMMAND_ID: 02-brand-color-setup -->
<!-- PROGRESS_PHASE: phase1 -->
<!-- PROGRESS_NAME: ブランドカラー設定 -->
<!-- PROGRESS_TYPE: auto -->
<!-- PROGRESS_ESTIMATED_TIME: 3-5 -->
<!-- PROGRESS_DEPENDENCIES: ["01-project-init"] -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_EXECUTION_START: -->
<!-- PROGRESS_EXECUTION_END: -->
<!-- PROGRESS_DURATION_MINUTES: -->
<!-- PROGRESS_RESULT: -->
<!-- PROGRESS_LOGS: [] -->

**実行時間**: 3-5分

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → コンセプト・ターゲットに合った色選定を行う"
```

企画書が存在する場合、コンセプトとターゲット層を読み取り、カラー選定の判断材料にする。

---

## 概要

アプリのブランドカラーを決定・設定するための戦略的プロセスです。色は **第一印象・ブランド認知・ユーザー体験** に大きく影響するため、競合分析と心理効果を考慮した選定が重要です。

**⚠️ 重要**: アプリアイコン作成前に必ず確定すること（後の変更は60-120分のコスト）

## 📋 目的

アプリのブランドアイデンティティを確立するため、競合分析と心理効果を考慮したカラー選定を行います。

**デフォルト設定（変更推奨）:**
- メインカラー: `#2196F3` (Material Blue 500)
- 印象: 信頼感・プロフェッショナル
- ⚠️ このままだと競合と差別化できない可能性があります

---

## 🎨 ブランドカラー決定プロセス

### Step 1: アプリ目的の分析

```markdown
# アプリの目的・ターゲット・求められる印象を明確化

例：
- 目的: [アプリの主な目的・機能]
- ターゲット: [想定ユーザー層]
- 印象: [与えたいブランドイメージ]
```

### Step 2: 競合アプリのカラー分析

**分析テンプレート:**

| アプリ | ブランドカラー | カラーコード | 印象 | 差別化 |
|--------|--------------|-------------|------|--------|
| **競合A** | [色名] | `#XXXXXX` | [印象] | [差別化判定] |
| **競合B** | [色名] | `#XXXXXX` | [印象] | [差別化判定] |
| **競合C** | [色名] | `#XXXXXX` | [印象] | [差別化判定] |
| **自アプリ** | **[色名]** | `#XXXXXX` | **[印象]** | **[差別化判定]** |

**差別化判定基準:**
- ✅ 色相が完全に異なる（推奨）
- ⚠️ 類似色だが濃度・彩度が異なる（要検討）
- ❌ 競合と重複（変更推奨）

### Step 3: 色の心理効果を考慮

| 色 | 心理効果 | 適したアプリ |
|----|---------|-------------|
| **Blue** | 信頼・安定・ビジネス | 生産性・時間管理・ビジネスツール |
| **Green** | 成長・健康・リラックス | フィットネス・健康・フィナンシャル |
| **Red** | 緊急・エネルギー・情熱 | タスク管理・緊急性重視 |
| **Orange** | 創造性・楽しさ・活力 | SNS・エンタメ・クリエイティブ |
| **Purple** | 高級・創造性・神秘 | ライフスタイル・プレミアム |
| **Yellow** | 明るさ・注意・幸福 | メモ・学習・ポジティブ |

### Step 4: ブランドカラーパレット設計

**標準カラーパレットテンプレート:**

| 色名 | カラーコード | 用途 | 使用例 |
|-----|-------------|------|--------|
| **main** | `#2196F3` | メインブランド | ボタン、ハイライト、CTA |
| **primary** | `#212121` | プライマリテキスト | 本文、アイコン、主要UI |
| **backGround** | `#FFFFFF` | 基本背景 | 画面背景、カード背景 |
| **error** | `#F44336` | エラー・警告 | エラーメッセージ、警告 |
| **success** | `#4CAF50` | 成功・完了 | 成功メッセージ、完了状態 |
| **accent** | `#FF9800` | アクセント | 通知、重要情報 |
| **secondary** | `#757575` | セカンダリテキスト | サブタイトル、説明文 |
| **progress** | `#2196F3` | プログレス | ローディング、進捗 |

**サブスクリプション画面カラーテンプレート:**

| 色名 | カラーコード | 用途 | 使用例 |
|-----|-------------|------|--------|
| **subscriptionPrimary** | `#E88B8B` | サブスクプライマリ | アイコン、アクセント |
| **subscriptionAccent** | `#D35D6E` | サブスクアクセント | ボタン、価格表示、選択枠 |
| **subscriptionBadge** | `#4A7C59` | バッジ | 「おすすめ」「無料トライアル」 |
| **subscriptionGradientStart** | `#F5E6E8` | グラデーション開始 | 画面背景 |
| **subscriptionGradientMiddle** | `#FDF8F8` | グラデーション中間 | 画面背景 |
| **subscriptionGradientEnd** | `#E8D4D4` | グラデーション終了 | 画面背景 |
| **subscriptionText** | `#4A4A4A` | テキスト | タイトル、プラン名 |

**⚠️ 重要**: サブスクリプション画面は課金に直結するため、ブランドに合ったプレミアム感のある色を選定すること

**アプリ機能別カラー戦略のカスタマイズ例:**
- 主要アクション: `main` - アクション開始の明確な視覚的フィードバック
- 重要な警告: `error` - 緊急性・重要性を強調
- 正常状態: `success` - 安心感の提供
- 補足情報: `secondary` - 視覚的階層の構築

---

## 🔧 実行手順

### Step 1: ブランドカラーを決定

AIが以下を分析・提案します：
1. アプリの目的・ターゲット・印象の分析
2. 競合アプリ（3-5個）のカラー調査
3. 色の心理効果の考慮
4. メインブランドカラー・パレットの決定

### Step 2: colors.xml を更新

AIが `assets/color/colors.xml` を編集します：
```xml
<!-- メインブランドカラー -->
<color name="main">#YOUR_MAIN_COLOR</color>
<color name="primary">#YOUR_PRIMARY_COLOR</color>
<color name="accent">#YOUR_ACCENT_COLOR</color>

<!-- サブスクリプション画面カラー（プロダクトごとにカスタマイズ） -->
<color name="subscriptionPrimary">#YOUR_SUBSCRIPTION_PRIMARY</color>
<color name="subscriptionAccent">#YOUR_SUBSCRIPTION_ACCENT</color>
<color name="subscriptionBadge">#YOUR_SUBSCRIPTION_BADGE</color>
<color name="subscriptionGradientStart">#YOUR_GRADIENT_START</color>
<color name="subscriptionGradientMiddle">#YOUR_GRADIENT_MIDDLE</color>
<color name="subscriptionGradientEnd">#YOUR_GRADIENT_END</color>
<color name="subscriptionText">#YOUR_SUBSCRIPTION_TEXT</color>
```

**💡 サブスクリプション画面のカラー選定ポイント:**
- プライマリ/アクセント: ブランドカラーに合わせた暖色系が課金率向上に効果的
- グラデーション: 柔らかいパステル調でプレミアム感を演出
- バッジ: 視認性の高い補色系でお得感をアピール

### Step 3: ドキュメント作成

AIが `docs/project/brand_colors.md` を作成します：
- カラー選定理由
- 競合分析結果
- 色の心理効果
- 使用ガイドライン

### Step 4: コード生成・検証

```bash
# ColorName 自動生成
make generate-colors

# 色使用状況の検証（必要に応じて）
make check-color-usage
```

---

## 📊 カラー設定例

### ✅ デフォルト設定（Material Blue）

```xml
<color name="main">#2196F3</color>  <!-- Material Blue 500 -->
<color name="primary">#212121</color>
<color name="accent">#FF9800</color>
```

**印象**: 信頼感・安定感・プロフェッショナル
**適用例**:
- ビジネスツール・生産性アプリ
- 20-35歳のビジネスパーソン向け
- Material Design準拠・アクセシビリティ基準クリア

### 🔄 カラーバリエーション例

#### オプション1: ダークブルー（プロフェッショナル強化）

```xml
<color name="main">#1976D2</color>  <!-- Material Blue 700 -->
```

**用途**: エンタープライズ・B2B向けアプリ

#### オプション2: グリーン（健康・成長）

```xml
<color name="main">#4CAF50</color>  <!-- Material Green 500 -->
```

**用途**: フィットネス・健康管理・フィナンシャルアプリ

#### オプション3: パープル（プレミアム・創造性）

```xml
<color name="main">#9C27B0</color>  <!-- Material Purple 500 -->
```

**用途**: ライフスタイル・クリエイティブツール

**⚠️ 重要**: Step 03（アプリアイコン作成）前の変更を推奨

---

## 📁 カラー設定ファイル

### 1. assets/color/colors.xml

現在の設定を確認:
```bash
cat assets/color/colors.xml
```

**デフォルト主要カラー:**
- `main`: #2196F3（Material Blue 500）
- `primary`: #212121（テキスト）
- `backGround`: #FFFFFF（背景）
- `error`: #F44336（エラー・警告）
- `success`: #4CAF50（成功・完了）
- `accent`: #FF9800（アクセント）

### 2. docs/project/brand_colors.md

詳細なブランドカラーガイドライン:
```bash
cat docs/project/brand_colors.md
```

**記載内容:**
- メインブランドカラー選定理由
- 競合アプリ分析結果
- 色の心理効果とアプリへの適用
- 機能別カラー戦略
- アクセシビリティ基準
- 使用ガイドライン

---

## ✅ カラー設定完了チェックリスト

### Phase 1: 現状確認（所要時間: 1-2分）
- [ ] ブランドカラー分析（アプリの目的・ターゲット・印象）
- [ ] 競合アプリ分析（主要競合3-5アプリ）
- [ ] 色の心理効果検証
- [ ] 差別化戦略確認

### Phase 2: 実装確認（所要時間: 1-2分）
- [ ] `assets/color/colors.xml` メインブランドカラー設定
- [ ] `assets/color/colors.xml` サブスクリプション画面カラー設定
- [ ] ColorName 自動生成
- [ ] `make check-color-usage` で検証（必要に応じて）
- [ ] 全画面で色を確認（必要に応じて）

### Phase 3: ドキュメント（所要時間: 1-2分）
- [ ] `docs/project/brand_colors.md` 作成
- [ ] カラーガイドライン記載
- [ ] 競合分析・差別化ポイント記載
- [ ] 機能別カラー戦略記載

### Phase 4: 変更判断（必要な場合のみ）
- [ ] アイコン作成（Step 03）
- [ ] カラー変更の必要性評価
- [ ] 変更する場合: 新カラーコード決定
- [ ] 変更する場合: `assets/color/colors.xml` 更新

---

## 🚨 注意事項

### Step 03以降の色変更は避ける

**理由:**
1. **アプリアイコン再作成**: 既に作成したアイコンを全て作り直し
2. **スクリーンショット再撮影**: App Store/Play Store用画像の再作成
3. **デザイン不整合**: 既存UI要素との不整合リスク

**コスト比較:**
- **Phase 1-2で設定**: 0分（自動生成）
- **Phase 3で設定**: 5分（手動設定）
- **Step 14前**: 10分（確認・修正）
- **Step 03以降**: 60-120分（アイコン・画像再作成）

---

## 📚 関連ドキュメント

- [色管理ルール](.claude/docs/rules/color_management_rule.md)
- [スタイルガイド](.claude/docs/rules/style_guide.md)
- [アプリアイコン作成ガイド](.claude/commands/release/step/03-app-icons-images-guide.md)

---

**Assistant Instructions:**
- このコマンドを実行する際は、必ず日本語で回答してください
- `/release:step:01-project-init` 完了後の新規プロジェクトで実行することを前提とします

### 実行フロー

1. **アプリの目的・ターゲット・印象を分析**
   - `docs/project/requirements.md` から情報を抽出
   - アプリのコンセプト・ターゲットユーザーを確認

2. **競合アプリ（3-5個）のカラーを調査**
   - `docs/project/design.md` や `docs/project/app_concept.md` から競合情報を取得
   - 各競合のブランドカラーを分析
   - 差別化ポイントを特定

3. **色の心理効果を考慮**
   - アプリの目的に合った色を選定
   - ターゲット層への訴求力を評価

4. **メインブランドカラー・パレットを決定**
   - 複数の候補をユーザーに提示
   - ユーザーの選択に基づき確定

5. **`assets/color/colors.xml` を更新**
   - Edit tool で main, accent カラーを変更

6. **`docs/project/brand_colors.md` を作成**
   - カラー選定理由
   - 競合分析結果
   - 色の心理効果
   - 使用ガイドライン

7. **ColorName を生成**
   ```bash
   make generate-colors
   ```

8. **完了報告**
   - 設定したブランドカラーを提示
   - 次のステップ（`/05-project-deploy`）を案内

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:02-brand-color-setup`**
   ↓
   - [x] **`/release:step:02-brand-color-setup`**

2. セクションステータス更新:
   Auto01の全コマンドが完了したら: 🔄 進行中 → ✅ 完了
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
