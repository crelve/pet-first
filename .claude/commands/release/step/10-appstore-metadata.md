# 📝 Step 10: App Store メタデータ生成

<!-- PROGRESS_COMMAND_ID: 10-appstore-metadata -->
<!-- PROGRESS_PHASE: phase6 -->
<!-- PROGRESS_NAME: App Storeメタデータ生成 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 15-20分（初回翻訳時）

AIが4つの並列Taskエージェントを使って39言語のメタデータを分担生成します。各エージェントが約10言語を担当することで、32,000トークン制限を回避します。

**生成される内容:**
- **Fastlane用メタデータ** (`ios/fastlane/metadata/`) - 39言語 × 9ファイル = 351ファイル

---

## 🚦 ガイドライン違反チェック（必須・完了直前）

メタデータ生成完了後、`commit` 前に以下を実行する。違反0件でなければStep 10未了とする。

```bash
APP_NAME=$(basename $(pwd))
BRAND=<アプリの英語ブランド名>  # 例: AgeIn, DreamLog, HabitFi
python3 ~/kikiki/released/company/engineering/scripts/check-app-naming.py "$(pwd)" --brand="$BRAND"
```

検出される違反:
- ストア名 30文字超過
- アイコンラベル（CFBundleDisplayName）13文字超過
- 非en派生ロケール（en/en-AU/en-CA/en-GB以外の35言語）に英語ブランド名残存（ルールC違反）
- U+FFFD 文字化け
- 価格/割引KW（無料・Free・0円・割引・セール・半額等、Guideline 2.3.7違反）

違反が出たら `marketing/aso/app-naming-guideline.md` を参照して修正。

---

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → コンセプト・ターゲット・差別化をメタデータに反映"
```

企画書が存在する場合、コンセプト・ターゲット・差別化ポイント・リリース時期を読み取り、キーワード選定・説明文の訴求軸に反映する。

## 📋 CEO確認ポイント（完了時に必ず実行）

RELEASE_CHECKLIST.md の「CEO確認ポイント」セクションに以下を追記する:
```
- [ ] Step 10: メタデータ（キーワード・説明文）の確認
```

---

## 🚨 AI実行者への重要指示

このコマンドは以下の手順で実行してください。**1レスポンスですべて生成しようとしてはいけません。** 必ず並列Taskエージェントを使用してください。

---

## ステップ1: 必要な情報を収集

Read ツールで以下を取得してください：

1. `pubspec.yaml` → アプリ名（`name:` フィールド）とバージョン
2. `lib/utility/product/product_config.dart` → `legal`（利用規約URL）、`privacyPolicy`（プライバシーポリシーURL）
3. `.firebaserc` → フォールバック用Firebase プロジェクトID（URLが未設定の場合に使用）
4. `docs/project/requirements.md` → アプリの機能概要（全体）

**競合調査の活用（ASO）:**
`docs/project/requirements.md` の Part 1〜3 から以下を抽出しておく:
- 競合アプリ名・ポジショニング（Phase 3 市場調査結果）
- ターゲットユーザーの検索意図（どんな課題を解決するアプリか）
- 競合が使っていると推定されるキーワード群

これをステップ2のキーワード選定に活用する。

---

## ステップ1.5: 初回 or 更新リリースの判定

pubspec.yaml の `version` を確認し、メタデータの戦略を分岐する。

```bash
VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
MAJOR_MINOR_PATCH=$(echo "$VERSION" | sed 's/+.*//')
if [ "$MAJOR_MINOR_PATCH" = "1.0.0" ]; then
  echo "RELEASE_TYPE=initial"
else
  echo "RELEASE_TYPE=update"
fi
```

**判定結果をステップ2以降の全テンプレートに適用すること。**

| 項目 | 初回リリース (1.0.0) | 更新リリース (1.0.1+) |
|------|---------------------|----------------------|
| description冒頭 | 課題提起 + 解決策 + CTA | 社会的証明 + 改善点 + CTA |
| promotional_text | ローンチ訴求（新登場 + コア価値） | What's New / 季節訴求 / キャンペーン |
| release_notes | Initial Release テンプレート | 変更内容を具体的に記載 |
| keywords | 競合名 + カテゴリ語 + 検索意図 | 実データ（DL元KW）で最適化 |

---

## ステップ2: 英語マスターコンテンツを作成

収集した情報を基に、以下の英語マスターコンテンツを作成してください。これをすべてのTaskエージェントに渡します。

**収集した値:**
- APP_NAME: pubspec.yaml から取得
- PRIVACY_URL: product_config.dart の `privacyPolicy`
- TERMS_URL: product_config.dart の `legal`
- VERSION: pubspec.yaml の `version`
- RELEASE_TYPE: ステップ1.5 の判定結果（`initial` or `update`）

**英語マスターコンテンツ（アプリ内容に合わせて作成）:**

```
[APP_NAME]: （pubspec.yamlのname値）
[RELEASE_TYPE]: initial or update

SUBTITLE（最大30文字）:
（アプリの主要キーワードを自然に含めた価値訴求）
※ ここに含めた単語は KEYWORDS から除外すること（重複カウント不可）

PROMOTIONAL_TEXT（最大170文字）:
```

**PROMOTIONAL_TEXT の RELEASE_TYPE 別テンプレート:**

- **initial**: ローンチ訴求。「新登場」感 + コアベネフィットを凝縮。季節・キャンペーンではなく「このアプリが何を解決するか」を伝える
  - 例: "Track your daily habits with smart reminders and beautiful charts. Start building better routines today - completely free to get started."
- **update**: What's New 訴求。新機能・改善点を前面に。既存ユーザーのアップデート動機を作る
  - 例: "New: Dark mode and widget support! Plus faster sync and improved notifications. Update now for the best experience."

```
KEYWORDS（最大100文字、カンマ区切り、スペースなし）:
（以下のルールで選定し、90〜100文字になるよう調整）
```

**KEYWORDS 選定ルール（ASO）:**
1. **subtitle との重複除外** — subtitle に含まれる単語は keywords に入れない（Appleが重複を無視するため無駄になる）
2. **競合アプリ名を積極活用** — ステップ1の競合調査で特定した競合アプリ名を keywords に含める。競合を検索したユーザーに自アプリが表示されるため検索流入が増える。Apple の審査でキーワード起因のリジェクトはほぼ発生しない（最悪でも修正依頼のみ）。ただし文字数に余裕がある場合に優先し、100文字を超えないよう調整する
3. **カテゴリワードも並用** — アプリ名に加え、ジャンルを表す一般名詞も組み合わせる（例: `todoist,notion,task manager,productivity`）
4. **検索意図優先** — 「機能名」より「ユーザーが検索する課題・動詞」を優先（例: "task manager" より "stay organized"）
5. **複数形/単数形** — Appleは両方を同一視するため単数形で統一、文字数節約
6. **カンマ後スペースなし** — スペースも文字数に計上されるため必ず除去

```
DESCRIPTION（最大4000文字）:
（RELEASE_TYPE に応じた構成で作成）
```

**DESCRIPTION の RELEASE_TYPE 別テンプレート:**

### 初回リリース (RELEASE_TYPE=initial)
```
--- 冒頭170文字（最重要）---
（課題提起 → 解決策 → CTA の構成。社会的証明は使わない）
例: "Tired of forgetting your daily goals? [アプリ名] makes habit tracking effortless with smart reminders and progress charts. Download free and start building better routines today."

--- 本文 ---
【Key Features】
- （実装済み機能のみ列挙。requirements.md の MVP v1.0.0 から）

【Perfect For】
- （ターゲットユーザー。競合調査のペルソナから）

【Get Started for Free】
- Download and start using all core features at no cost
- Optional premium subscription for advanced features

【Premium Subscription】
- （サブスクリプション情報 - Guideline 3.1.2 必須）
- Subscription automatically renews unless canceled 24 hours before period end
- Payment charged to Apple ID account at purchase confirmation
- Manage subscriptions in Apple ID Account Settings

Privacy Policy: [PRIVACY_URL]
Terms of Use: [TERMS_URL]
```

### 更新リリース (RELEASE_TYPE=update)
```
--- 冒頭170文字（最重要）---
（社会的証明 + 改善点 + CTA。ユーザー数やレビュー評価があれば活用）
例: "[アプリ名] helps you [主要ベネフィット]. Loved by [X]+ users with [Y]+ star rating. Now with [新機能]. Update free today."

--- 本文 ---
【What's New in This Version】
- （今回の更新内容を具体的に）

【Key Features】
- （現時点の全機能。新機能には [NEW] タグ付与）

【Perfect For】
- （ターゲットユーザー）

【Premium Subscription】
- （サブスクリプション情報 - Guideline 3.1.2 必須）
- Subscription automatically renews unless canceled 24 hours before period end
- Payment charged to Apple ID account at purchase confirmation
- Manage subscriptions in Apple ID Account Settings

Privacy Policy: [PRIVACY_URL]
Terms of Use: [TERMS_URL]
```

```
RELEASE_NOTES:
（RELEASE_TYPE に応じて選択）
```

### release_notes: 初回リリース (RELEASE_TYPE=initial)
```
Thank you for downloading our app!

【Initial Release】
- All core features included
- Simple and intuitive design

If you have any questions or feedback, please contact us through the in-app support.

Privacy Policy: [PRIVACY_URL]
Terms of Use: [TERMS_URL]
```

### release_notes: 更新リリース (RELEASE_TYPE=update)
```
（当該バージョンの具体的な変更内容を記載）

【Bug Fixes & Improvements】
- （実際の修正内容を具体的に。例: "Fixed notification timing issue"）
- （例: "Improved chart rendering performance"）

If you have any questions or feedback, please contact us through the in-app support.

Privacy Policy: [PRIVACY_URL]
Terms of Use: [TERMS_URL]
```

**⚠️ 重要ルール:**
- descriptionとrelease_notesに `{privacy_url}`, `{terms_url}` ではなく実際のURLを埋め込む
- 絵文字禁止（📱👤🔒など）
- `•` ビュレット禁止 → `-` ハイフンを使用
- 特殊矢印（→⇒）禁止
- 実装済み機能のみ記載（requirementsのMVP v1.0.0の機能のみ）
- **release_notesにバージョン番号（v1.0.1等）を含めない**（App Storeが自動表示するため不要・再利用不可になるため）
- description の冒頭 170 文字に最重要キーワードと CTA を必ず含める
- **name.txtはphase2-app-naming.mdルールに従う**（必須）: `アプリ名 – [サブタイトル]`（英語系）または `アプリ名 〜[サブタイトル]〜`（日本語・中国語・韓国語）の形式で30文字以内。アプリ名単体のみの記載は禁止。参照: `.claude/commands/release/step/01-phases/phase2-app-naming.md`
- **release_notes.txtはバージョン変更時に必ず最新化する**（必須）: pubspec.yamlのversionが上がった場合は「Initial Release」を使い回さず、当該バージョンの変更内容（バグ修正・新機能）に39言語すべて更新すること
- **初回リリース(1.0.0)で社会的証明（"Join X+ users"等）を使わない** — ユーザー数0の新規アプリで使うと不誠実。課題提起+解決策で攻める
- **更新リリースでは「Initial Release」を使い回さない** — 必ず具体的な変更内容を記載する

---

## ステップ3: 4つの並列Taskエージェントを起動

**1つのメッセージで4つのTaskツール呼び出しを同時に行ってください。**

各エージェントに渡す情報:
- APP_NAME（実際の値）
- PRIVACY_URL（実際の値）
- TERMS_URL（実際の値）
- RELEASE_TYPE（`initial` or `update`）
- 英語マスターコンテンツ（ステップ2で作成したもの。RELEASE_TYPE に応じたテンプレートを使用済み）
- 担当言語リスト

### エージェントA: 言語グループ1（10言語）
担当: ar-SA, ca, zh-Hans, zh-Hant, hr, cs, da, nl-NL, en-US, en-AU

**Taskプロンプトテンプレート:**
```
以下の情報を使って、指定された言語のApp Store Fastlaneメタデータファイルを生成してください。

【アプリ情報】
- アプリ名: [APP_NAME]
- プライバシーポリシーURL: [PRIVACY_URL]
- 利用規約URL: [TERMS_URL]
- リリース種別: [RELEASE_TYPE]（initial=初回リリース1.0.0 / update=更新リリース1.0.1+）

【英語マスターコンテンツ】
[ステップ2で作成した英語コンテンツをここに貼り付け]

【リリース種別に応じた翻訳指示】
- initial: description冒頭は課題提起+解決策+CTA。社会的証明は使わない。promotional_textはローンチ訴求。release_notesは「Initial Release」テンプレート
- update: description冒頭は社会的証明+改善点+CTA。promotional_textはWhat's New訴求。release_notesは具体的な変更内容
※ 英語マスターが既にRELEASE_TYPEに応じて作成済み。その内容を忠実に翻訳すること

【担当言語】
ar-SA（アラビア語）, ca（カタロニア語）, zh-Hans（中国語簡体字）, zh-Hant（中国語繁体字）, hr（クロアチア語）, cs（チェコ語）, da（デンマーク語）, nl-NL（オランダ語）, en-US（英語米国）, en-AU（英語豪州）

【en-AUについて】
en-AUはen-USと完全に同じ内容をコピーしてください。

【各言語で作成するファイル（9個 × 10言語 = 90ファイル）】
パス: ios/fastlane/metadata/{lang}/
- name.txt（⚠️ phase2-app-naming.mdルール必須: `アプリ名 – [サブタイトル]` または `アプリ名 〜[サブタイトル]〜`（日・中・韓）形式、最大30文字。アプリ名単体のみ禁止）
  - 日本語（ja）・韓国語（ko）: `アプリ名〜短縮タグライン〜` 形式（例: PetalPages〜赤ちゃん絵本記録〜）
  - その他の言語: `アプリ名 - 短縮タグライン` 形式（例: VoxMind - AI Voice Journal）
  - タグラインはsubtitle.txtを参考に短縮し、合計30文字以内に収める
- subtitle.txt（英語マスターを該当言語に翻訳、最大30文字）
- description.txt（英語マスターを該当言語に翻訳、最大4000文字）
- keywords.txt（英語マスターを参考に該当言語キーワード、最大100文字、カンマ区切り）
- promotional_text.txt（英語マスターを該当言語に翻訳、最大170文字）
- release_notes.txt（英語マスターを該当言語に翻訳）
- support_url.txt（`https://crelve.com/` + アプリのリポジトリ名を記載。例: `https://crelve.com/archly`）
- marketing_url.txt（[TERMS_URL] をそのまま記載）
- privacy_url.txt（[PRIVACY_URL] をそのまま記載）

【翻訳ルール】
- 各言語で自然な表現を使用（直訳ではなく意訳）
- 文化的に適切な言い回しに変換
- 文字数制限を厳守
- アラビア語（ar-SA）とヘブライ語（he）は右から左に書く言語に対応
- URLファイル（support_url.txt, marketing_url.txt, privacy_url.txt）は言語に関係なくURLをそのまま記載
- 絵文字禁止、• ビュレット禁止、→ 等の特殊矢印禁止
- キーワードはカンマ区切り、スペースなし

【keywords の言語別最適化（ASO）】
- 英語 keywords の直訳は禁止。各言語市場でユーザーが実際に検索する単語を選定する
- subtitle に含まれる単語は keywords に含めない（Appleが重複カウントしないため）
- description 冒頭170文字にも主要キーワードを自然に含めること
- 90〜100文字になるよう言語固有の高頻度検索語で充填する
- en-AU / en-CA / en-GB など英語コピー言語は en-US と同じ keywords を使用

【指示】
Writeツールを使って90個のファイルをすべて作成してください。
作業ディレクトリ: /Users/tomohitokii/kikiki/released/markly
```

### エージェントB: 言語グループ2（10言語）
担当: en-CA, en-GB, fi, fr-FR, fr-CA, de-DE, el, he, hi, hu

**Taskプロンプトテンプレート:**
```
以下の情報を使って、指定された言語のApp Store Fastlaneメタデータファイルを生成してください。

【アプリ情報】
- アプリ名: [APP_NAME]
- プライバシーポリシーURL: [PRIVACY_URL]
- 利用規約URL: [TERMS_URL]
- リリース種別: [RELEASE_TYPE]（initial=初回リリース1.0.0 / update=更新リリース1.0.1+）

【英語マスターコンテンツ】
[ステップ2で作成した英語コンテンツをここに貼り付け]

【リリース種別に応じた翻訳指示】
- initial: description冒頭は課題提起+解決策+CTA。社会的証明は使わない。promotional_textはローンチ訴求。release_notesは「Initial Release」テンプレート
- update: description冒頭は社会的証明+改善点+CTA。promotional_textはWhat's New訴求。release_notesは具体的な変更内容
※ 英語マスターが既にRELEASE_TYPEに応じて作成済み。その内容を忠実に翻訳すること

【担当言語】
en-CA（英語カナダ）, en-GB（英語英国）, fi（フィンランド語）, fr-FR（フランス語フランス）, fr-CA（フランス語カナダ）, de-DE（ドイツ語）, el（ギリシャ語）, he（ヘブライ語）, hi（ヒンディー語）, hu（ハンガリー語）

【コピー言語について】
- en-CA, en-GB はen-USと完全に同じ内容をコピー（Writeで新規作成）
- fr-CA はfr-FRと完全に同じ内容をコピー（Writeで新規作成）

【各言語で作成するファイル（9個 × 10言語 = 90ファイル）】
パス: ios/fastlane/metadata/{lang}/
- name.txt, subtitle.txt, description.txt, keywords.txt, promotional_text.txt, release_notes.txt, support_url.txt, marketing_url.txt, privacy_url.txt

【翻訳ルール（エージェントAと同じ）】
- 各言語で自然な表現を使用
- ヘブライ語（he）は右から左に書く言語に対応
- URLファイルはURLをそのまま記載
- 絵文字禁止、• ビュレット禁止、→ 等の特殊矢印禁止
- キーワードはカンマ区切り、スペースなし
- keywords は英語の直訳禁止。各言語市場で実際に検索される語を選定し、subtitle との重複を除外して90〜100文字に充填
- description 冒頭170文字に主要キーワードと CTA を含めること

【指示】
Writeツールを使って90個のファイルをすべて作成してください。
作業ディレクトリ: /Users/tomohitokii/kikiki/released/markly
```

### エージェントC: 言語グループ3（10言語）
担当: id, it, ja, ko, ms, no, pl, pt-BR, pt-PT, ro

**Taskプロンプトテンプレート:**
```
以下の情報を使って、指定された言語のApp Store Fastlaneメタデータファイルを生成してください。

【アプリ情報】
- アプリ名: [APP_NAME]
- プライバシーポリシーURL: [PRIVACY_URL]
- 利用規約URL: [TERMS_URL]
- リリース種別: [RELEASE_TYPE]（initial=初回リリース1.0.0 / update=更新リリース1.0.1+）

【英語マスターコンテンツ】
[ステップ2で作成した英語コンテンツをここに貼り付け]

【リリース種別に応じた翻訳指示】
- initial: description冒頭は課題提起+解決策+CTA。社会的証明は使わない。promotional_textはローンチ訴求。release_notesは「Initial Release」テンプレート
- update: description冒頭は社会的証明+改善点+CTA。promotional_textはWhat's New訴求。release_notesは具体的な変更内容
※ 英語マスターが既にRELEASE_TYPEに応じて作成済み。その内容を忠実に翻訳すること

【担当言語】
id（インドネシア語）, it（イタリア語）, ja（日本語）, ko（韓国語）, ms（マレー語）, no（ノルウェー語）, pl（ポーランド語）, pt-BR（ポルトガル語ブラジル）, pt-PT（ポルトガル語ポルトガル）, ro（ルーマニア語）

【コピー言語について】
- pt-PT はpt-BRと完全に同じ内容をコピー（Writeで新規作成）

【各言語で作成するファイル（9個 × 10言語 = 90ファイル）】
パス: ios/fastlane/metadata/{lang}/
- name.txt, subtitle.txt, description.txt, keywords.txt, promotional_text.txt, release_notes.txt, support_url.txt, marketing_url.txt, privacy_url.txt

【翻訳ルール（エージェントAと同じ）】
- 各言語で自然な表現を使用
- URLファイルはURLをそのまま記載
- 絵文字禁止、• ビュレット禁止、→ 等の特殊矢印禁止
- キーワードはカンマ区切り、スペースなし
- keywords は英語の直訳禁止。各言語市場で実際に検索される語を選定し、subtitle との重複を除外して90〜100文字に充填
- description 冒頭170文字に主要キーワードと CTA を含めること

【指示】
Writeツールを使って90個のファイルをすべて作成してください。
作業ディレクトリ: /Users/tomohitokii/kikiki/released/markly
```

### エージェントD: 言語グループ4（9言語）
担当: ru, sk, es-ES, es-MX, sv, th, tr, uk, vi

**Taskプロンプトテンプレート:**
```
以下の情報を使って、指定された言語のApp Store Fastlaneメタデータファイルを生成してください。

【アプリ情報】
- アプリ名: [APP_NAME]
- プライバシーポリシーURL: [PRIVACY_URL]
- 利用規約URL: [TERMS_URL]
- リリース種別: [RELEASE_TYPE]（initial=初回リリース1.0.0 / update=更新リリース1.0.1+）

【英語マスターコンテンツ】
[ステップ2で作成した英語コンテンツをここに貼り付け]

【リリース種別に応じた翻訳指示】
- initial: description冒頭は課題提起+解決策+CTA。社会的証明は使わない。promotional_textはローンチ訴求。release_notesは「Initial Release」テンプレート
- update: description冒頭は社会的証明+改善点+CTA。promotional_textはWhat's New訴求。release_notesは具体的な変更内容
※ 英語マスターが既にRELEASE_TYPEに応じて作成済み。その内容を忠実に翻訳すること

【担当言語】
ru（ロシア語）, sk（スロバキア語）, es-ES（スペイン語スペイン）, es-MX（スペイン語メキシコ）, sv（スウェーデン語）, th（タイ語）, tr（トルコ語）, uk（ウクライナ語）, vi（ベトナム語）

【コピー言語について】
- es-MX はes-ESと完全に同じ内容をコピー（Writeで新規作成）

【各言語で作成するファイル（9個 × 9言語 = 81ファイル）】
パス: ios/fastlane/metadata/{lang}/
- name.txt, subtitle.txt, description.txt, keywords.txt, promotional_text.txt, release_notes.txt, support_url.txt, marketing_url.txt, privacy_url.txt

【翻訳ルール（エージェントAと同じ）】
- 各言語で自然な表現を使用
- URLファイルはURLをそのまま記載
- 絵文字禁止、• ビュレット禁止、→ 等の特殊矢印禁止
- キーワードはカンマ区切り、スペースなし
- keywords は英語の直訳禁止。各言語市場で実際に検索される語を選定し、subtitle との重複を除外して90〜100文字に充填
- description 冒頭170文字に主要キーワードと CTA を含めること

【指示】
Writeツールを使って81個のファイルをすべて作成してください。
作業ディレクトリ: /Users/tomohitokii/kikiki/released/markly
```

---

## ステップ4: カテゴリ設定

App Store Connect のカテゴリを設定します。アプリの内容に応じて適切なカテゴリを選択してください。

### カテゴリ識別子一覧

| カテゴリ | 識別子 |
|---------|--------|
| ファイナンス | `FINANCE` |
| ヘルス＆フィットネス | `HEALTH_AND_FITNESS` |
| 仕事効率化 | `PRODUCTIVITY` |
| ライフスタイル | `LIFESTYLE` |
| ニュース | `NEWS` |
| 教育 | `EDUCATION` |
| エンターテインメント | `ENTERTAINMENT` |
| ユーティリティ | `UTILITIES` |
| フード＆ドリンク | `FOOD_AND_DRINK` |
| スポーツ | `SPORTS` |
| 旅行 | `TRAVEL` |
| 写真＆ビデオ | `PHOTO_AND_VIDEO` |
| ミュージック | `MUSIC` |
| ゲーム | `GAMES` |

### カテゴリファイル作成（全39言語に一括適用）

```bash
# PRIMARY_CATEGORY と SECONDARY_CATEGORY を設定してから実行
PRIMARY_CATEGORY="FINANCE"    # ← アプリに合わせて変更
SECONDARY_CATEGORY="LIFESTYLE" # ← アプリに合わせて変更

for lang in $(ls ios/fastlane/metadata/ | grep -v ".txt"); do
  echo "$PRIMARY_CATEGORY" > "ios/fastlane/metadata/$lang/primary_category.txt"
  echo "$SECONDARY_CATEGORY" > "ios/fastlane/metadata/$lang/secondary_category.txt"
done

echo "✅ カテゴリ設定完了"
echo "   Primary:   $PRIMARY_CATEGORY"
echo "   Secondary: $SECONDARY_CATEGORY"
echo "   言語数: $(find ios/fastlane/metadata -name 'primary_category.txt' | wc -l | tr -d ' ')"
```

---

## ステップ5: 完了確認

4つのエージェントが完了したら確認：

```bash
# ファイル総数を確認（351+78=429 になるべき: メタデータ351 + カテゴリ78）
find ios/fastlane/metadata -name "*.txt" | wc -l

# カテゴリが正しく設定されているか確認
cat ios/fastlane/metadata/en-US/primary_category.txt
cat ios/fastlane/metadata/en-US/secondary_category.txt

# URLが正しく設定されているか確認
cat ios/fastlane/metadata/en-US/support_url.txt
cat ios/fastlane/metadata/en-US/marketing_url.txt
cat ios/fastlane/metadata/en-US/privacy_url.txt

# 日本語コンテンツの確認
cat ios/fastlane/metadata/ja/subtitle.txt

# 文字数チェック
make check-appstore-metadata
```

---

## メタデータ品質ルール

### 実装済み機能のみ記載
- `requirements.md` のMVP v1.0.0の機能のみ
- 「coming soon」「準備中」は使用不可

### App Store Connect 禁止文字
| 禁止 | 代替 |
|------|------|
| 絵文字 | 【】括弧 |
| `•` ビュレット | `-` ハイフン |
| `→` `⇒` 矢印 | `>` |

### 文字数制限
| フィールド | 上限 | 目標 |
|-----------|------|------|
| name | 30文字 | **アプリ名 + サブタイトル必須**（phase2ルール準拠・単体禁止） |
| subtitle | 30文字 | 主要キーワード1〜2語を含める |
| promotional_text | 170文字 | - |
| keywords | 100文字 | **90〜100文字（フル充填）** |
| description 冒頭 | - | **最初の170文字に最重要KW + CTA** |

### ASO 戦略（検索ランキング最適化）

**フィールド間の連携:**
- `subtitle` に含めた単語は `keywords` から除外する（Apple が重複を無視するため）
- `name` + `subtitle` + `keywords` の3フィールドがインデックス対象。`description` は非インデックス

**keywords 選定優先順位:**
1. **競合アプリ名**（推奨） — 競合調査（`requirements.md` Phase 3）で特定したアプリ名を積極的に含める。競合検索ユーザーへのリーチが増加する。Apple の審査でリジェクトされることはほぼなく、最悪でも修正依頼のみ
2. **カテゴリ・ジャンルワード** — 競合アプリ名に加え、ジャンルを表す一般名詞を組み合わせて充填
3. ユーザーが検索する「課題・動詞」（機能名より検索意図を優先）
4. 各言語市場固有の検索語（英語の直訳ではなく現地語の実際の検索ワード）
5. 単数形に統一（Apple は複数形も同一視）

**description の冒頭 170 文字戦略:**
- 「続きを読む」で折り畳まれる前に表示される唯一の範囲
- 構成: `[主要キーワードを含むキャッチ] + [主要ベネフィット] + [CTA（Download free / Get started）]`
- 数字・社会的証明（"Join 10,000+ users"）があれば冒頭に配置

**promotional_text の活用:**
- 唯一いつでも審査なしに変更できるフィールド
- セール・新機能告知・季節訴求に使用（ローンチ時は最大ベネフィットを記載）

### サブスクリプション情報（Guideline 3.1.2 必須）
descriptionに必ず含める：
- 月額/年額プランと価格
- 自動更新の説明
- 「24時間前までにキャンセル」
- Apple ID アカウント設定で管理
- プライバシーポリシーURL
- 利用規約URL

---

## ✅ 完了時アクション（必須）

**全4エージェント完了 + ファイル数351確認後のみ実行:**

### RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:10-appstore-metadata`**
   ↓
   - [x] **`/release:step:10-appstore-metadata`**

2. セクションステータス更新（最初の完了時）:
   ### **Auto03: メタデータ生成・最終リリース** (2コマンド) ⬜ 未着手
   ↓
   ### **Auto03: メタデータ生成・最終リリース** (2コマンド) 🔄 進行中
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
