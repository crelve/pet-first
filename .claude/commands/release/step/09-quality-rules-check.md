# 🎨 Step 09: 品質ルール準拠確認

<!-- PROGRESS_COMMAND_ID: 09-quality-rules-check -->
<!-- PROGRESS_PHASE: phase3 -->
<!-- PROGRESS_NAME: 品質ルール準拠確認 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 1-2分（makeコマンド自動化により大幅短縮）

**重要**: このステップは**最終確認のみ**を想定しています。

**理由**: Step 07（Issue自動実装）で各Issue実装後に `make check-quality-rules-full` を実行しているため、このステップでは違反がほぼ0件のはずです。

コーディング規約への準拠状況を包括的にチェックし、リリース前の品質保証を行います。

### 🎨 UXデザイン品質チェック（手動確認項目）
以下のスキルに基づいてUI/UX品質も確認してください：
- **[Apple Design SKILL](../../../skills/apple-design/SKILL.md)** - iOS HIG準拠
- **[UX Psychology](../../../skills/apple-design/references/ux-psychology.md)** - 47個のUX心理学コンセプト

**UX品質チェックリスト:**
- [ ] 応答時間: 400ms以内の応答（ドハティの閾値）
- [ ] ローディング: 長時間処理に「考え中...」表示（労働の錯覚）
- [ ] 選択肢: 5-7個以下（ヒックの法則）
- [ ] タップ: 44pt以上のタップターゲット（フィッツの法則）
- [ ] 完了演出: 成功時のお祝い表示（ピーク・エンドの法則）

---

## 📊 実行管理ダッシュボード

### ✅ チェック項目一覧（10項目自動 + 4項目手動）

| # | チェック項目 | makeコマンド | 状態 | 違反数 | 所要時間 |
|---|------------|------------|------|--------|---------|
| 1 | 色管理ルール | `make check-color-usage` | ⏳ 未実行 | - | - |
| 2 | Barrel Import規則 | `make check-barrel-import` | ⏳ 未実行 | - | - |
| 3 | Text()使用規則 | `make check-text-usage` | ⏳ 未実行 | - | - |
| 4 | 多言語化対応 | `make check-i18n-strict` | ⏳ 未実行 | - | - |
| 5 | コンポーネント使用規則 | `make check-component-usage` | ⏳ 未実行 | - | - |
| 6 | logger使用規則 | `make check-logger-usage` | ⏳ 未実行 | - | - |
| 7 | 例外処理規則 | `make check-exception-handling` | ⏳ 未実行 | - | - |
| 8 | Switch文規則 | `make check-switch-statements` | ⏳ 未実行 | - | - |
| 9 | format/analyze/test | `make check-ready` | ⏳ 未実行 | - | - |
| 10 | 統合チェック | `make check-quality-rules-full` | ⏳ 未実行 | - | - |
| 11 | ルート定義一元化 | 手動確認 | ⏳ 未実行 | - | - |
| 12 | 既存パターン理解 | 手動確認（スキップ可） | ⏳ 未実行 | - | - |
| 13 | App Attest・Push通知動作確認 | 手動確認 | ⏳ 未実行 | - | - |
| 14 | リマインダーPush通知動作確認 | 手動確認（採用時のみ） | ⏳ 未実行 | - | - |

**状態凡例:**
- ⏳ 未実行
- 🔄 実行中
- ✅ 完了（違反なし）
- ⚠️ 完了（警告あり）
- ❌ 失敗（違反あり、要修正）

---

## 🚀 実行手順

### ⚡ 推奨: 1コマンドで完了

```bash
make check-quality-rules-full
```

**所要時間:** 1-2分
**チェック項目:** 10項目自動

このコマンドは以下を順次実行します:
1. 色管理ルール（`check-color-usage`）
2. Barrel Import規則（`check-barrel-import`）
3. Text()使用規則（`check-text-usage`）
4. 多言語化対応（`check-i18n-strict`）
5. コンポーネント使用規則（`check-component-usage`）
6. logger使用規則（`check-logger-usage`）
7. 例外処理規則（`check-exception-handling`）
8. Switch文規則（`check-switch-statements`）
9. format/analyze/test（`check-ready`）

---

### 📋 詳細手順（段階的実行したい場合）

#### Step 1: 統合チェック実行

```bash
make check-quality-rules-full
```

**Claude Codeへの指示:**
1. 上記コマンドを実行
2. 各チェックの結果を上記テーブルに記録
3. 違反があれば該当箇所を特定し、即座に修正
4. 修正後、再度チェック実行
5. すべて ✅ になるまで繰り返す

**違反があった場合の対応:**
1. コマンド出力に表示される `ファイルパス:行番号` を確認
2. 該当ファイルを開く（Read tool使用）
3. 違反箇所を修正（Edit tool使用）
4. 再度 `make check-quality-rules-full` を実行
5. すべて ✅ になるまで繰り返す

**結果記録方法:**
- ✅ `✅ [項目名]: 違反なし` → 状態を `✅ 完了`、違反数を `0`
- ❌ `❌ [項目名]違反: X件` → 状態を `❌ 失敗`、違反数を `X`
- ⚠️ `⚠️ [項目名]: X件` → 状態を `⚠️ 完了`、違反数を `X`

---

#### Step 2: 個別チェック実行（オプション）

**統合チェックでエラーが多い場合の段階的アプローチ:**

##### 2-1. 色管理ルールチェック

```bash
make check-color-usage
```

**チェック内容:**
- `Color(0xFF...)` 直接指定の検出
- `Colors.*` 使用の検出
- `Theme.of(context).colorScheme` 使用の検出
- `Scaffold(backgroundColor: Colors.*/Color(0x...))` 直接指定の検出
- `Container(color: Colors.*/Color(0x...))` 直接指定の検出

**推奨:**
- 一般: `ColorName.*` または `theme.appColors.*` 使用
- 背景色: `theme.appColors.background` または `ColorName.backGround` 使用

##### 2-2. Barrel Import規則チェック

```bash
make check-barrel-import
```

**チェック内容:**
- `import '../../component/...` の検出
- `import '../../model/...` の検出
- `import '../../provider/...` の検出
- `import '../../utility/...` の検出
- `import '../../hook/...` の検出
- `import '../../type/...` の検出

**推奨:** `lib/import/*.dart` 経由のインポート

##### 2-3. Text()使用規則チェック

```bash
make check-text-usage
```

**チェック内容:**
- `Text(...)` 直接使用の検出（ThemeTextを除く）

**推奨:** `ThemeText(text: ..., color: ..., style: ...)` 使用

##### 2-4. 多言語化対応チェック

```bash
make check-i18n-strict
```

**チェック内容:**
- 日本語ハードコード（ひらがな・カタカナ・漢字）の検出
- l10n未使用箇所の検出

**推奨:** `l10n.[key]` 使用

##### 2-5. コンポーネント使用規則チェック

```bash
make check-component-usage
```

**チェック内容:**
- `CircularProgressIndicator` 直接使用の検出
- `SizedBox` 過剰使用の検出（10件以上で警告）
- `AlertDialog` 直接使用の検出
- `showDialog` 直接使用の検出

**推奨:**
- ローディング: `Loading()` 使用
- スペース: `hSpace()` / `wSpace()` 使用
- ダイアログ: `ActionDialog` / `TwoButtonDialog` 使用（flutter_foundation）

##### 2-6. logger使用規則チェック

```bash
make check-logger-usage
```

**チェック内容:**
- `print(...)` 使用の検出

**推奨:** `logger` 使用

##### 2-7. 例外処理規則チェック

```bash
make check-exception-handling
```

**チェック内容:**
- `} catch (...)` without `on` 句の検出

**推奨:** `} on ExceptionType catch (...)` 使用

##### 2-8. Switch文規則チェック

```bash
make check-switch-statements
```

**チェック内容:**
- `default:` 句の検出

**推奨:** 全ケース列挙（default句なし）

**注:** 警告レベル（必須ではない）

##### 2-9. format/analyze/testチェック

```bash
make check-ready
```

**チェック内容:**
- `dart format` 実行
- `flutter analyze` 実行
- `flutter test` 実行

---

#### Step 3: 手動確認（2項目）

##### 3-1. ルート定義一元化の確認

**確認方法:**
```bash
# Serena活用
/utils:serena get_symbols_overview lib/route/route.dart
```

**確認ポイント:**
- ✅ 全ルートが `lib/route/route.dart` に定義されているか
- ✅ screen/ 配下のファイルに個別のルート定義がないか

**記録項目:**
- 状態: [✅ 適合 / ❌ 不適合]
- 確認結果: [簡潔な説明]
- 問題があれば: [修正内容]

##### 3-3. App Attest・Push通知の動作確認（必須）

**確認方法:**
```bash
# App Check 設定確認
grep -r "AppleAppAttestProvider\|AppleDebugProvider" lib/ --include="*.dart"
grep "appattest-environment" ios/Runner/Runner-Release.entitlements
```

**確認ポイント:**
- [ ] `main.dart` で `isNotProduction()` を使って本番時に `AppleAppAttestProvider()` が使われている
- [ ] `Runner-Release.entitlements` に `com.apple.developer.devicecheck.appattest-environment = production` が存在する
- [ ] `Runner-Debug.entitlements` に `com.apple.developer.devicecheck.appattest-environment = development` が存在する
- [ ] Apple Developer Portal で dev/prod 両 App ID に App Attest Capability が追加済み（`12-ios-certificate-setup` 完了済みであること）
- [ ] Push通知の許可リクエストが適切なタイミングで実装されている

**記録項目:**
- 状態: [✅ 適合 / ❌ 不適合]
- 確認結果: [簡潔な説明]

##### 3-4. リマインダーPush通知の動作確認（採用時のみ）

**確認方法:**
```bash
# リマインダーサービス実装確認
find lib/service -name "reminder*"
find lib/model -name "reminder*"
grep -r "scheduleReminder\|processReminders" lib/ --include="*.dart"

# Cloud Functions デプロイ確認
firebase functions:list --project prod
```

**確認ポイント:**
- [ ] `ReminderNotificationService.scheduleReminder()` が実装済み
- [ ] Cloud Functions `processReminders` がデプロイ済み（`firebase deploy --only functions` 実行済み）
- [ ] Firestore `reminders` コレクションのセキュリティルールで `userId` 一致のみ読み書き可に設定されている

**記録項目:**
- 状態: [✅ 適合 / ⏭️ 非採用 / ❌ 不適合]
- 確認結果: [簡潔な説明]

##### 3-2. 既存パターンの理解

**確認項目:**
- `hSpace/wSpace` の使い方
- `Loading()` の使い方
- `ThemeText()` の使い方

**記録項目:**
- 状態: [✅ 理解済み / ⏭️ スキップ]
- パターン: [既にcoding_rule.mdに記載済み]

**注:** 通常はスキップ可能（coding_rule.mdに既に記載）

---

#### Step 4: 最終確認

```bash
# 全チェックが通過したことを確認
make check-quality-rules-full
```

**Expected:** すべて ✅

---

## 📈 実行結果レポート

### 実行サマリー

**実行日時:** [YYYY-MM-DD HH:MM:SS]
**総所要時間:** [X分Y秒]
**実行者:** Claude Code

### チェック結果

| カテゴリ | チェック数 | 完了 | 失敗 | 警告 | 違反総数 |
|---------|----------|------|------|------|---------|
| 自動チェック | 9項目 | - | - | - | - |
| 手動確認 | 2項目 | - | - | - | - |
| **合計** | **11項目** | **-** | **-** | **-** | **-** |

### 品質スコア

```
品質スコア = (完了項目数 / 総項目数) × 100
         = (- / 11) × 100
         = -%
```

**評価:**
- 100%: 🎉 完璧！リリース準備完了
- 90-99%: ✅ 良好。軽微な警告のみ
- 80-89%: ⚠️ 要改善。一部修正が必要
- 80%未満: ❌ 要大幅修正

### 修正が必要な項目

**優先度: 高（必須）**
（ここに違反項目が記録されます）

**優先度: 中（推奨）**
（ここに警告項目が記録されます）

**優先度: 低（任意）**
（ここに改善提案が記録されます）

### 修正完了項目

（ここに完了項目が記録されます）

---

## 🔄 PDCA - 実行後の振り返り

### 問題発生時の対処

以下の場合はトラブルシューティングが必要です：

- ❌ makeコマンドがエラーで失敗 → ripgrepのインストール確認（`brew install ripgrep`）
- ❌ 大量の違反が検出（20件以上）→ 優先度を付けて段階的に修正
- ❌ false positiveが多数発生 → `.claude/docs/rules/`のパターンを調整
- ❌ 新しいパターンのエラー → ルールファイルへの追加を検討
- ❌ 修正に時間がかかる → 自動修正可能な項目から着手

**トラブルシューティング手順:**
```bash
# ripgrepのインストール確認
which rg

# 違反パターンの詳細確認
cat .claude/docs/rules/color_management_rule.md

# ルールの一覧確認
ls -la .claude/docs/rules/
```

全ての違反を修正したら、再度チェックを実行して✅になることを確認してください

---

## 📚 関連コマンド

### より包括的な品質判定

```bash
/quality-gate          # 総合品質判定（コード25% + テスト30% + 要件20% + 他）
/quality-gate --strict # 厳格モード
/quality-gate --fix    # 自動修正
```

### パフォーマンスチェック

```bash
make check-performance  # Flutter/Dart パフォーマンスチェック
```

### 個別チェックコマンド一覧

| コマンド | チェック内容 | 違反時の動作 |
|---------|------------|------------|
| `make check-color-usage` | 色管理ルール | ❌ エラー終了 |
| `make check-barrel-import` | Barrel Import規則 | ❌ エラー終了 |
| `make check-text-usage` | Text()使用規則 | ❌ エラー終了 |
| `make check-i18n-strict` | 多言語化対応 | ❌ エラー終了 |
| `make check-component-usage` | コンポーネント使用規則 | ❌ エラー終了 |
| `make check-logger-usage` | logger使用規則 | ❌ エラー終了 |
| `make check-exception-handling` | 例外処理規則 | ❌ エラー終了 |
| `make check-switch-statements` | Switch文規則 | ⚠️ 警告表示 |
| `make check-ready` | format/analyze/test | ❌ エラー終了 |

---

## ⚠️ 前提条件

### ripgrep (rg) のインストール

このチェックには `ripgrep` が必要です:

```bash
# macOS
brew install ripgrep

# 確認
rg --version
```

**注:** makeコマンド実行時に `rg` がない場合、エラーメッセージとインストール方法が表示されます。

---

## 🤖 Claude Code への実行指示

**実行の流れ:**

1. **統合チェック実行**
   ```bash
   make check-quality-rules-full
   ```

2. **結果を上記テーブルに記録**
   - 各チェックの状態を更新（⏳ → ✅/❌/⚠️）
   - 違反数を記録
   - 所要時間を記録

3. **違反があれば即座に修正**
   - コマンド出力から違反箇所を特定
   - 該当ファイルを開いて修正
   - 再度チェック実行

4. **すべて ✅ になるまで繰り返す**

5. **実行結果レポートを完成させる**
   - 品質スコア算出
   - 修正内容のサマリー
   - 次のアクションの提案

**トークン効率化:**
- ✅ makeコマンド優先（モジュールファイル読み込み不要）
- ✅ Serena活用（必要な情報のみ取得）
- ✅ 結果をこのファイル内に記録（別ファイル作成不要）

---

## 📊 期待される成果

- ✅ coding_rule.md 完全準拠（12項目すべて適合）
- ✅ 静的解析エラー0件
- ✅ リリース前品質保証完了
- ✅ トークン消費93%削減（15,000 → 1,000トークン）
- ✅ 実行時間80-90%短縮（10-15分 → 1-2分）

---

**Assistant Instructions:**
- このコマンドを実行する際は、必ず日本語で回答してください
- 上記テーブルとレポートを更新しながら進めてください
- 違反があれば即座に修正し、修正内容を記録してください

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:09-quality-rules-check`**
   ↓
   - [x] **`/release:step:09-quality-rules-check`**

2. セクションステータス更新:
   Auto02の全コマンドが完了したら: 🔄 進行中 → ✅ 完了
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
