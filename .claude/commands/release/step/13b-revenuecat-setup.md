# 💎 Step 13: RevenueCat In-App Purchase セットアップ

<!-- PROGRESS_COMMAND_ID: 13-revenuecat-setup -->
<!-- PROGRESS_PHASE: phase4 -->
<!-- PROGRESS_NAME: RevenueCat In-App Purchase セットアップ -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 30-45分

---

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → 月額基準価格を取得"
```

企画書が存在する場合、月額基準価格を読み取る。年額・買い切りはPhase 4ルールで算出済み（`docs/project/business_design.md` に記載）。

---

## 📋 前提条件

- Apple Developer Program 登録済み
- App Store Connect でアプリ作成済み
- 有料アプリ契約完了済み
- **`/release:step:01-project-init` 完了済み**（価格は `docs/project/business_design.md` を参照）

---

## 🔍 Phase 1: プロジェクトカテゴリーの自動判定

以下のファイルを読み込み、アプリのジャンルを把握する。

```bash
[ -f docs/project/requirements.md ]    && cat docs/project/requirements.md
[ -f docs/project/business_design.md ] && cat docs/project/business_design.md
# アプリ名・説明をpubspec.yamlからも確認
grep -E "^(name|description):" pubspec.yaml
```

読み込んだ情報をもとに、以下のRevenueCatカテゴリー一覧から最も適切なものを1つ選んでユーザーに提案する。

| カテゴリー | 代表的なアプリ例 |
|-----------|----------------|
| `Books` | 電子書籍、読書ログ |
| `Business` | 業務効率化、請求書、CRM |
| `Developer Tools` | 開発補助、コード管理 |
| `Education` | 学習、語学、問題集 |
| `Entertainment` | 動画、コンテンツ閲覧 |
| `Finance` | 家計簿、投資、節約 |
| `Food & Drink` | レシピ、カロリー管理 |
| `Games` | ゲーム全般 |
| `Graphics & Design` | 画像編集、デザイン |
| `Health & Fitness` | 運動、瞑想、健康管理 |
| `Lifestyle` | 習慣管理、日記、趣味 |
| `Medical` | 医療、症状チェック |
| `Music` | 音楽再生、楽器練習 |
| `Navigation` | 地図、経路案内 |
| `News` | ニュース、RSS |
| `Photo & Video` | カメラ、写真編集 |
| `Productivity` | タスク管理、メモ、TODO |
| `Reference` | 辞書、マニュアル |
| `Shopping` | EC、価格比較 |
| `Social Networking` | SNS、コミュニティ |
| `Sports` | スポーツ記録、観戦 |
| `Travel` | 旅行計画、ホテル予約 |
| `Utilities` | ツール、ユーティリティ |
| `Weather` | 天気予報 |

**提案形式:**

```
## 📂 RevenueCat カテゴリー提案

アプリ概要: [分析した内容の要約]

推奨カテゴリー: **[カテゴリー名]**
理由: [選定理由を1〜2文で]

よろしければ Phase 2 に進みます。変更する場合はお知らせください。
```

ユーザーの確認後、Phase 2 に進む。

---

## 🚀 Phase 2: RevenueCat ダッシュボード設定

### 2.1 アカウント・プロジェクト作成

1. https://app.revenuecat.com/ でアカウント作成（GitHub/Google）
2. 「Create new project」→ プロジェクト名を入力、**Category は Phase 1 で提案したものを選択**
3. プロジェクトID を記録

### 2.2 iOS アプリ追加

1. Apps & providers → 「+ New」→「App Store」
2. 設定:
   - App name: [App Store Connect のアプリ名]
   - App Bundle ID: [Bundle ID] ⚠️ Xcodeと完全一致必須
3. **Public API Key を記録**（`appl_XXX` または `test_XXX` 形式）

---

## 🔗 Phase 3: App Store Connect 連携

### ⚡ 自動セットアップ（推奨）

以下の条件が揃っている場合、スクリプトで Phase 3〜4 を自動化できます:

| 条件 | 確認方法 |
|------|---------|
| `ios/fastlane/.env` に `ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_KEY_CONTENT` 設定済み | `cat ios/fastlane/.env` |
| RevenueCat プロジェクト作成済み（Phase 2 完了） | ダッシュボードで確認 |
| RevenueCat V2 Secret Key を手元に用意 | ダッシュボード → Project Settings → API keys |

```bash
# 前提: jq インストール
brew install jq

# 実行（モード選択・価格・RevenueCat情報を対話入力）
bash scripts/iap/setup_iap.sh
```

**自動化される内容:**
- ✅ サブスクリプショングループ「Premium」作成
- ✅ 月額・年額サブスクリプション作成
- ✅ 英語ローカライズ設定
- ✅ RevenueCat Products / Entitlement / Offering / Packages 作成

**⚠️ 自動化できない内容（手動必須）:**
- ❌ 月額・年額の**価格設定** → ASC APIが`MISSING_METADATA`状態で拒否するため
- ❌ 月額・年額の**無料トライアル設定** → 同上
- ❌ **買い切り（Non-Consumable）商品作成** → Apple APIが`CREATE`を禁止（`GET_INSTANCE`のみ許可）

> スクリプト実行後も **3.2〜3.3（価格・無料トライアル・買い切り）** と **3.4 In-app purchase key (P8) 設定** は手動対応が必要です。

---

### 3.1 サブスクリプション設定（無料トライアル必須）

1. App Store Connect → マイApp → [アプリ] → 配信 → サブスクリプション
2. サブスクリプショングループ作成: 参照名「Premium」、グループID「premium」
3. サブスクリプション追加:

| プラン | 参照名 | 製品ID | 期間 | 価格 |
|--------|--------|--------|------|------|
| 月額 | Monthly Premium | `[app_id]_premium_monthly` | 1ヶ月 | business_design.md参照 |
| 年額 | Yearly Premium | `[app_id]_premium_yearly` | 1年 | business_design.md参照 |

⚠️ 製品ID: **英数字とアンダースコアのみ**（ピリオド・ハイフン不可）

#### 🎁 無料トライアル設定（必須）

各サブスクリプション商品に無料トライアル期間を設定する。

1. 各サブスクリプション商品を選択 → 「サブスクリプション価格」セクション
2. 「価格を追加」→「キャンペーン価格」→「無料トライアル」を選択
3. 推奨トライアル期間:

| プラン | 推奨トライアル期間 |
|--------|-----------------|
| 月額 | 3日 または 7日 |
| 年額 | 7日 または 14日 |

4. 地域: 「全ての地域に適用」を選択
5. 開始日: 即日

> ⚠️ トライアル期間は**新規ユーザーのみ**に適用される（App Storeの仕様）。
> RevenueCat側は自動でトライアル状態を検出するため、追加設定は不要。

### 3.2 買い切りプラン設定

1. App Store Connect → マイApp → [アプリ] → 配信 → **App内課金**（サブスクリプションとは別メニュー）
2. 「+」ボタン → **「非消耗型」**（Non-Consumable）を選択
3. 商品情報入力:

| 項目 | 値 |
|------|-----|
| 参照名 | Lifetime Premium |
| 製品ID | `[app_id]_premium_lifetime` |
| 価格 | business_design.md参照（例: $29.99） |

4. ローカリゼーション → 英語(US) → 表示名・説明入力
5. 審査用スクリーンショット: 640x920px をアップロード
6. 「保存」→「審査に登録」

> 💡 Non-Consumableは購入後に永続的に有効。デバイス変更後も「購入を復元」で再有効化可能。

### 3.3 メタデータ設定（各サブスクリプション）

- **価格**: 基準国(USD)選択 → 価格入力
- **ローカリゼーション**: 英語(US) → 表示名・説明(55文字以内)
- **審査用スクリーンショット**: 640x920px

### 3.4 In-app purchase key (P8) 設定

1. App Store Connect → ユーザとアクセス → 統合 → アプリ内課金
2. キー生成 → **Issuer ID, Key ID, P8ファイル** を記録
3. RevenueCat → iOS アプリ → P8アップロード → **「Valid credentials」確認**

---

## 📦 Phase 4: プロダクト設定

### 4.1 Products 登録

1. Product catalog → Products → [アプリ] の「+ New」
2. 以下の Product Identifier をすべて登録（App Store Connectと完全一致）:

| 種別 | Product Identifier |
|------|-------------------|
| 月額サブスクリプション | `[app_id]_premium_monthly` |
| 年額サブスクリプション | `[app_id]_premium_yearly` |
| 買い切り（Non-Consumable） | `[app_id]_premium_lifetime` |

### 4.2 Entitlement 作成・紐付け

1. Entitlements → 「+ New Entitlement」→ Identifier: `[アプリ名] Pro`
2. Products → **3商品すべて**の「Attach」→ 同じEntitlementに紐付け

> 💡 月額・年額・買い切りを同一Entitlementに紐付けることで、`isPremium`判定が統一される。

### 4.3 Offering 作成

1. Offerings → 「+ New」→ Identifier: `default`
2. Packages設定:
   - Monthly (`$rc_monthly`): `[app_id]_premium_monthly`
   - Yearly (`$rc_annual`): `[app_id]_premium_yearly`
   - Lifetime (`$rc_lifetime`): `[app_id]_premium_lifetime`

> RevenueCat の `$rc_lifetime` は買い切り（Non-Consumable）用の予約済みPackage Type。

---

## ⚙️ Phase 5: 環境変数更新

### 5.1 API キー設定

```bash
# dart_env/dev.env & dart_env/prod.env
revenueCatAppleApiKey=test_XXXXXXXXXXXXXXXXXXXXXXXXX
```

### 5.2 動作確認

```bash
make run-dev
# → サブスクリプション画面でOfferings取得・価格表示・Sandbox購入を確認
```

---

## ✅ Phase 6: 買い切りプラン対応（flutter_foundation 実装済み）

flutter_foundation はすでに買い切りプランに対応済み。アプリ側で `showLifetimePlan: true` を設定するだけで動作する。

### 6.1 実装済みの内容（flutter_foundation）

| ファイル | 実装内容 |
|---------|---------|
| `SubscriptionScreenConfig` | `showLifetimePlan`（デフォルト: false）、`lifetimePlanName`、`lifetimeBadgeText` フィールド実装済み |
| `SubscriptionScreen` | `showLifetimePlan: true` で買い切りカードを自動表示（価格サフィックスなし） |
| `SubscriptionType` | `lifetime` enum値、`isLifetime` ゲッター実装済み |
| `_parseSubscriptionType()` | productId に `lifetime` / `onetime` / `one_time` / `once` / `permanent` / `forever` を含む場合を判定（優先度: lifetime > annual > monthly） |
| `SubscriptionService.purchase()` | `Package` を渡すだけで買い切りも処理できる汎用実装 |

### 6.2 アプリ側でやること

```dart
// lib/screen/setting/subscription_setting_screen.dart
SubscriptionScreen(
  apiKey: Env.revenueCatAppleApiKey,
  flavor: Env.flavor,
  config: SubscriptionScreenConfig(
    // ... 既存設定 ...
    showLifetimePlan: true,          // 買い切りプランを表示
    lifetimePlanName: '買い切り',     // 省略時は l10n を使用
    lifetimeBadgeText: '永久利用',   // 省略時は l10n を使用
  ),
);
```

### 6.3 状態チェックの使い方

```dart
final type = ref.watch(subscriptionTypeProvider);

type.isPremium   // true: 月額・年額・買い切りすべてで true
type.isLifetime  // true: 買い切りユーザーのみ true
```

> 💡 RevenueCat 側のプロダクトID命名が `*_lifetime` / `*_onetime` 等であれば自動判定される（Phase 4 の設定通りであれば問題なし）。

---

## ✅ チェックリスト

| Phase | 確認項目 |
|-------|----------|
| 1 | [ ] カテゴリー選定完了 |
| 2 | [ ] アカウント・プロジェクト作成、[ ] iOS アプリ追加、[ ] API Key取得 |
| 3 | [ ] サブスクリプション作成（月額・年額）、[ ] **無料トライアル設定（必須）**、[ ] 買い切り商品（Non-Consumable）作成、[ ] 価格・ローカリゼーション、[ ] P8設定（Valid credentials） |
| 4 | [ ] Products登録（月額・年額・買い切り）、[ ] Entitlement作成・全商品紐付け、[ ] Offering設定（`$rc_lifetime`含む） |
| 5 | [ ] 環境変数更新、[ ] Sandbox購入テスト完了（トライアル・月額・年額・買い切り） |
| 6 | [ ] `showLifetimePlan: true` をアプリ側に設定済み |

---

## 🆘 トラブルシューティング

| 問題 | 原因・対処 |
|------|-----------|
| Bundle ID不一致 | Xcode Bundle IDとRevenueCatを完全一致させる |
| P8が「Valid credentials」にならない | Bundle ID、Key ID、Issuer ID、P8ファイルを再確認 |
| Products Import不可 | App Store Connectでメタデータ完了、または手動追加 |
| Offerings取得失敗 | API Key、Product ID一致、Offering紐付けを確認 |
| Sandbox購入失敗 | Sandboxテスター使用、有料アプリ契約完了を確認 |
| トライアルが表示されない | App Store Connectで「キャンペーン価格」→「無料トライアル」が保存済みか確認。Sandboxでは新規テスターアカウントのみトライアル対象 |
| 買い切りPackageが取得できない | OfferingにPackage Type `$rc_lifetime`が追加されているか確認。App Store ConnectでNon-Consumableが審査登録済みか確認 |
| 買い切り後にisPremiumがfalseのまま | lifetimeProductがEntitlementに「Attach」されているか確認 |
| 購入復元で買い切りが復元されない | Non-ConsumableはRevenueCat経由で自動復元される。`Purchases.restorePurchases()`を呼び出しているか確認 |

---

## 📚 参考リンク

- [RevenueCat ダッシュボード](https://app.revenuecat.com/)
- [RevenueCat iOS クイックスタート](https://www.revenuecat.com/docs/getting-started/installation/ios)
- [App Store Connect ヘルプ](https://help.apple.com/app-store-connect/)

---

## 🌍 IAP 39言語ローカライズ（必須）

App Store Connect でサブスクリプション商品名を **39言語すべてにローカライズ**する。
en-US のみだと、日本語・中国語など非英語ユーザーに英語名がそのまま表示される。

### 自動実行スクリプト

`petal-pages` リポジトリに共通スクリプトがある：

```bash
# petal-pagesのスクリプトを使って実行
python3 /path/to/petal-pages/ios/fastlane/add_iap_localizations_all.py
```

または、下記の手順で新アプリ用スクリプトを実行する：

```bash
# 必要パッケージ（初回のみ）
pip3 install PyJWT cryptography requests

# スクリプト実行（App IDを引数で渡すか、スクリプト内のAPPS配列に追加）
python3 ios/fastlane/add_iap_localizations_all.py
```

### 翻訳対応表（39言語）

| 言語 | ロケール | グループ名 | 月額名 | 年額名 |
|------|---------|-----------|-------|-------|
| 日本語 | ja | プレミアム | 月額プレミアム | 年額プレミアム |
| 中国語（簡体字） | zh-Hans | 高级版 | 月度高级版 | 年度高级版 |
| 中国語（繁体字） | zh-Hant | 進階版 | 月費進階版 | 年費進階版 |
| 韓国語 | ko | 프리미엄 | 월간 프리미엄 | 연간 프리미엄 |
| ドイツ語 | de-DE | Premium | Monatliches Premium | Jährliches Premium |
| フランス語 | fr-FR | Premium | Premium mensuel | Premium annuel |
| スペイン語 | es-ES | Premium | Premium mensual | Premium anual |
| （他33言語は `add_iap_localizations_all.py` 内の TRANSLATIONS 参照） | | | | |

### 完了確認

```python
# 件数確認（39/39になればOK）
python3 -c "
import jwt, time, requests
# ... (スクリプト内の確認コードを使用)
"
```

> **⚠️ 注意**: サブスク商品を App Store Connect で作成した直後に実行すること。
> App Store Connect API の Key ID / Issuer ID は `ios/fastlane/.env` に設定済み。

---

## ✅ 完了時アクション

`RELEASE_CHECKLIST.md` の該当コマンドをチェック済み `[x]` に更新
