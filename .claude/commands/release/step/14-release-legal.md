# 📋 Step 14: ランディングページ・法的文書生成・Firebase Hosting公開

<!-- PROGRESS_COMMAND_ID: 14-release-legal -->
<!-- PROGRESS_PHASE: phase4 -->
<!-- PROGRESS_NAME: LP・法的文書生成・Firebase Hosting公開 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 10-15分

**アプリの魅力を伝えるランディングページ（LP）**と、バイリンガル対応（日本語・英語切り替え）の法的文書（利用規約・プライバシーポリシー）を生成し、Firebase Hostingで公開します。

## 使い方

```bash
「LPと法的文書を作成してFirebase Hostingにデプロイしてください」
```

## 🌐 バイリンガル対応について

全ページは**日本語・英語の2言語切り替え**に対応しています：

- デフォルト表示: **英語**（グローバル対応）
- 言語切り替えボタン: ページ右上に `EN` / `日本語` ボタン
- 言語設定の保持: `localStorage` で選択言語を記憶
- ページ間で言語設定が引き継がれる

## 📧 固定開発者情報

**以下の情報は全プロジェクトで固定値として使用：**

| 項目 | 値 |
|------|-----|
| 事業形態 | 個人事業（Sole Proprietor） |
| 屋号（英語/日本語） | crelve |
| 連絡先メールアドレス | w4cd2017@gmail.com |

---

## 🤖 処理フロー

### Phase 1: 情報収集

`docs/project/requirements.md` または `lib/utility/const/product_config.dart` から以下を抽出:
- アプリ名（英語名・日本語名）
- アプリの絵文字アイコン
- キャッチコピー（日英）
- 主要機能リスト（4-6個）
- 使用しているFirebaseサービス（Analytics, Crashlytics, AdMob等）
- アプリのブランドカラー（colors.xmlまたはcolors.gen.dartから）

**⚠️ 重要: 課金情報の確認**

料金プランは必ずユーザーに確認してください：
- 課金形態: サブスクリプション（月額/年額）or 買い切り
- 価格: 月額○○円、年額○○円、買い切り○○円
- プレミアム特典: 広告なし、機能解放など

### Phase 2: public/ フォルダ構成

```bash
mkdir -p public
```

必要なファイル：
```
public/
├── index.html      # ★ ランディングページ（日英バイリンガル）
├── terms.html      # 利用規約（日英バイリンガル）
├── privacy.html    # プライバシーポリシー（日英バイリンガル）
├── contact.html    # お問い合わせ（mailto形式、日英バイリンガル）
├── 404.html        # エラーページ
├── icon.png        # ★ アプリアイコン（favicon・LP hero・OGP用）
└── app-ads.txt     # AdMob用（AdMob使用時のみ）
```

**🖼️ アプリアイコンのコピー（必須）**

```bash
# assets/image/logoIcon.png を public/icon.png にコピー
cp assets/image/logoIcon.png public/icon.png
```

Firebase Hostingは `public/` 配下のみ配信するため、`assets/image/logoIcon.png` は
Webページから直接参照できません。必ず `public/icon.png` にコピーすること。

---

## 🌟 Part 1: ランディングページ（LP）作成

### LP必須要素

| セクション | 内容 | 必須 |
|-----------|------|------|
| **ヒーロー** | アプリアイコン、名前、キャッチコピー、App Storeバッジ | ✅ |
| **機能紹介** | 4-6個の特徴をカード形式で表示 | ✅ |
| **プレミアム** | 価格、特典リスト（課金がある場合） | ⭕ |
| **法的リンク** | 利用規約・プライバシーポリシー・お問い合わせ | ✅ |
| **フッター** | © 年 crelve. All rights reserved. | ✅ |
| **言語切り替え** | EN/日本語ボタン + localStorage保存 | ✅ |

### テンプレート

`.claude/templates/legal/index.html` を参照して作成。

### LP構造

```
┌─────────────────────────────────────────┐
│  [EN] [日本語]                    ← 言語切替 │
│                                         │
│    [icon.png / {{APP_EMOJI}}]           │  ← icon.png があれば画像優先
│       {{APP_NAME_EN}}                   │
│     {{TAGLINE_EN/JA}}                   │
│    [Download on App Store]              │
│                                         │
├─────────────────────────────────────────┤
│  Why {{APP_NAME}}? / 〇〇の特徴         │
│                                         │
│  ┌─────┐  ┌─────┐  ┌─────┐             │
│  │ 👆  │  │ 📅  │  │ 📊  │  ...        │
│  │機能1│  │機能2│  │機能3│             │
│  └─────┘  └─────┘  └─────┘             │
├─────────────────────────────────────────┤
│  ⭐ Premium / プレミアム                 │
│  {{PREMIUM_PRICE}}                      │
│  ✓ 特典1  ✓ 特典2  ✓ 特典3             │
├─────────────────────────────────────────┤
│  [Terms] [Privacy] [Contact]            │
├─────────────────────────────────────────┤
│  © 2026 crelve. All rights reserved.    │
└─────────────────────────────────────────┘
```

### カラー設定

アプリのブランドカラーに合わせる：

| 変数 | 用途 | 例（Habit Flow） |
|------|------|------------------|
| `PRIMARY_COLOR` | ヒーロー背景、ボタン | `#4CAF50` (緑) |
| `ACCENT_COLOR` | グラデーション終点 | `#8BC34A` |
| `PREMIUM_COLOR` | プレミアムセクション | `#FFCC00` (ゴールド) |

### 機能カードHTMLフォーマット

```html
<div class="feature">
  <div class="feature-icon">{{EMOJI}}</div>
  <h3>{{TITLE}}</h3>
  <p>{{DESCRIPTION}}</p>
</div>
```

**日本語例:**
```html
<div class="feature">
  <div class="feature-icon">👆</div>
  <h3>ワンタップ記録</h3>
  <p>タップ1回で習慣を記録。シンプルさを追求しました。</p>
</div>
```

**英語例:**
```html
<div class="feature">
  <div class="feature-icon">👆</div>
  <h3>One-Tap Recording</h3>
  <p>Track your habits with a single tap. Pure simplicity.</p>
</div>
```

### プレミアム特典HTMLフォーマット

```html
<div class="premium-feature">
  <span class="check">✓</span> {{FEATURE_TEXT}}
</div>
```

---

## 🔒 Part 2: 法的文書作成

### terms.html カスタマイズポイント

| セクション | 英語 | 日本語 | カスタマイズ内容 |
|-----------|------|--------|----------------|
| サービス内容 | Article 2 | 第2条 | アプリ固有の機能説明 |
| 料金 | Article 4 | 第4条 | 価格、課金形態 |
| 禁止事項 | Article 5 | 第5条 | アプリ固有の禁止事項 |
| 免責事項 | Article 7 | 第7条 | AI/健康/金融等の免責 |

### privacy.html カスタマイズポイント

| セクション | 英語 | 日本語 | カスタマイズ内容 |
|-----------|------|--------|----------------|
| 収集情報 | Section 1 | 第1条 | カメラ、位置情報、健康データ等 |
| 第三者サービス | Section 1.3 | 1.3 | Firebase, AdMob, RevenueCat等 |
| データ保存 | Section 3 | 第3条 | ローカル/クラウド |

### contact.html

mailto形式でシンプルに実装：
- カテゴリ選択（バグ報告、機能要望、その他）
- メッセージ入力
- 送信 → メーラーが開く

---

## 📝 置換変数一覧

### LP用変数

| 変数 | 説明 | 例 |
|-----|------|---|
| `{{APP_NAME_EN}}` | アプリ名（英語） | Habit Flow |
| `{{APP_NAME_JA}}` | アプリ名（日本語） | ハビットフロー |
| `{{APP_EMOJI}}` | アプリを表す絵文字 | ✅ |
| `{{TAGLINE_EN}}` | メインキャッチ（英語） | Beat the 3-Day Slump. |
| `{{TAGLINE_JA}}` | メインキャッチ（日本語） | 3日坊主を克服。 |
| `{{TAGLINE_SUB_EN}}` | サブキャッチ（英語） | Build lasting habits with just one tap. |
| `{{TAGLINE_SUB_JA}}` | サブキャッチ（日本語） | ワンタップで習慣を記録。 |
| `{{IOS_APP_STORE_URL}}` | App Store URL | https://apps.apple.com/jp/app/id6755484720 |
| `{{PRIMARY_COLOR}}` | メインカラー | #4CAF50 |
| `{{ACCENT_COLOR}}` | アクセントカラー | #8BC34A |
| `{{PREMIUM_COLOR}}` | プレミアムカラー | #FFCC00 |
| `{{PREMIUM_COLOR_ALT}}` | プレミアムグラデ | #FFD700 |
| `{{PREMIUM_PRICE}}` | プレミアム価格 | ※ユーザー確認必須 |
| `{{PREMIUM_NOTE_EN}}` | 課金形態（英語） | ※ユーザー確認必須 |
| `{{PREMIUM_NOTE_JA}}` | 課金形態（日本語） | ※ユーザー確認必須 |

**課金形態別の例:**

| 形態 | PREMIUM_PRICE | PREMIUM_NOTE_EN | PREMIUM_NOTE_JA |
|------|---------------|-----------------|-----------------|
| サブスク | ¥500/月 | or ¥4,000/year (Save 33%) | または ¥4,000/年（33%お得） |
| 買い切り | ¥370 | One-time purchase. No subscription. | 買い切り。サブスクなし。 |

| 変数 | 説明 | 例 |
|-----|------|---|
| `{{FEATURES_EN}}` | 機能カードHTML（英語） | `<div class="feature">...` |
| `{{FEATURES_JA}}` | 機能カードHTML（日本語） | `<div class="feature">...` |
| `{{PREMIUM_FEATURES_EN}}` | 特典HTML（英語） | `<div class="premium-feature">...` |
| `{{PREMIUM_FEATURES_JA}}` | 特典HTML（日本語） | `<div class="premium-feature">...` |
| `{{CURRENT_YEAR}}` | 現在の年 | 2026 |

### 法的文書用変数

| 変数 | 説明 | 例 |
|-----|------|---|
| `{{DEVELOPER_EMAIL}}` | 連絡先（固定） | w4cd2017@gmail.com |
| `{{EFFECTIVE_DATE_EN}}` | 施行日（英語） | January 1, 2026 |
| `{{EFFECTIVE_DATE_JA}}` | 施行日（日本語） | 2026年1月1日 |

---

## 🚀 Phase 3: デプロイ

### Firebase Hosting設定（統合プロジェクト multi-site方式）

> ⚠️ **2026-04-14〜**: GCPプロジェクトクォータ制約のため、新規Firebaseプロジェクトは作らず、
> Step 05で統合された overflow project 配下に **hosting site** を作成して相乗りする。
> 旧方式（`firebase deploy --project {PROJECT_ID}-prod` 固定）は quota エラーで失敗する。

```bash
# 1. 実体プロジェクトIDを .firebaserc から取得（Step 05で統合先が書かれてる）
FIREBASE_PROJECT=$(python3 -c "import json; print(json.load(open('.firebaserc'))['projects']['prod'])")
echo "Actual Firebase project: $FIREBASE_PROJECT"

# 2. hosting site 作成（サイト名は {PROJECT_ID}-prod で固定 / URL互換性のため）
firebase hosting:sites:create ${PROJECT_ID}-prod --project $FIREBASE_PROJECT
# エラー "already exists" は無視OK（再実行時）

# 3. firebase.json に site フィールドを追加
python3 -c "
import json
p='firebase.json'
d=json.load(open(p))
d['hosting']['site']='${PROJECT_ID}-prod'
json.dump(d, open(p,'w'), indent=2)
"

# 4. デプロイ（--project は実体プロジェクト、site は firebase.json で指定）
firebase deploy --only hosting --project $FIREBASE_PROJECT
```

`firebase.json` 最終形:
```json
{
  "hosting": {
    "public": "public",
    "site": "{PROJECT_ID}-prod",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
  }
}
```

### アプリ内URL更新

URL体系は旧方式と互換（site名 = `{PROJECT_ID}-prod` なので `.web.app` ドメインも同じ）:

`lib/utility/product/product_config.dart`:
```dart
static const legal = 'https://{PROJECT_ID}-prod.web.app/terms.html';
static const privacyPolicy = 'https://{PROJECT_ID}-prod.web.app/privacy.html';
static const contact = 'https://{PROJECT_ID}-prod.web.app/contact.html';
```

**⚠️ 重要: Fastlane メタデータとの統合**

`/release:step:10-appstore-metadata` コマンドは、Fastlaneメタデータ生成時に以下の優先順位でURLを取得します：

1. **第一優先**: `lib/utility/product/product_config.dart` から `legal`, `privacyPolicy`, `contact` を読み取る
2. **フォールバック**: `.firebaserc` から Firebase プロジェクトIDを取得してURLを生成

**そのため、このコマンドで `product_config.dart` のURLを更新した後は、必ず `/release:step:10-appstore-metadata` を再実行してFastlaneメタデータを更新してください。**

---

## ✅ 完了確認チェックリスト

### アプリアイコン
- [ ] `assets/image/logoIcon.png` → `public/icon.png` コピー済み
- [ ] `public/icon.png` が Firebase Hosting で 200 OK 確認

### ランディングページ
- [ ] ヒーローセクション（`icon.png` 画像 or 絵文字、名前、キャッチコピー、App Storeバッジ）
- [ ] 機能紹介セクション（4-6個のカード）
- [ ] プレミアムセクション（価格、特典）※課金がある場合
- [ ] 法的リンクセクション
- [ ] フッター（コピーライト）
- [ ] 言語切り替え動作（EN ⇔ 日本語）
- [ ] ブランドカラーがアプリと統一
- [ ] `<link rel="icon">` および `og:image` に `icon.png` 設定済み

### 法的文書
- [ ] `terms.html` - 利用規約（バイリンガル）＋ favicon
- [ ] `privacy.html` - プライバシーポリシー（バイリンガル）＋ favicon
- [ ] `contact.html` - お問い合わせ（mailto形式）＋ favicon
- [ ] `404.html` - エラーページ ＋ favicon

### デプロイ
- [ ] `firebase hosting:sites:create {PROJECT_ID}-prod` 完了（統合先プロジェクト上）
- [ ] `firebase.json` に `"site": "{PROJECT_ID}-prod"` 追加済み
- [ ] `firebase deploy --only hosting --project $FIREBASE_PROJECT` 成功
- [ ] https://{PROJECT_ID}-prod.web.app/ 動作確認
- [ ] `product_config.dart` URL更新済み

---

## ✅ 完了時アクション（必須）

### RELEASE_CHECKLIST.md を更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:14-release-legal`**
   ↓
   - [x] **`/release:step:14-release-legal`**

2. セクションステータス更新（Auto02の最後のコマンド）:
   ### **Auto02: ...** 🔄 進行中
   ↓
   ### **Auto02: ...** ✅ 完了
```
