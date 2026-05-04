# 🏷️ Phase 2: アプリ名決定・多言語設定

## 目的
**グローバル展開を前提**としたアプリ名を決定し、全39言語のARB + iOS設定に反映

---

## 📥 企画書チェック（最初に実行）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
ls "$SPEC_PATH" 2>/dev/null
```

**企画書が存在し、アプリ名が確定済みの場合:**
- アプリ名の生成・選定（Step 1-2）をスキップ
- 企画書のアプリ名をそのまま採用
- **Step 3（ARBファイル更新）から実行**

**企画書がない or アプリ名未確定の場合:**
- 通常フロー（Step 1から）を実行

---

## アプリ名の原則

### 英語版（メイン・グローバル）
- ✅ シンプルで覚えやすい（1-2語推奨）
- ✅ 発音・スペルが簡単
- ✅ 検索しやすい（ASO最適化）
- ❌ 造語・難解な単語

### 🚫 命名バリエーション強制ルール（必須）

**Step 1の直前に必ず実行する：**

```bash
# 既存リポジトリのサフィックス使用回数を集計
gh repo list crelve --limit 100 --json name --jq '.[].name' | \
  grep -oE '\-[a-z]+$' | sort | uniq -c | sort -rn
```

**禁止基準:**
| 使用回数 | 判定 |
|---------|------|
| 2回以上 | ❌ そのサフィックスは使用禁止 |
| 1回 | ⚠️ 極力避ける（新鮮なサフィックスを優先） |
| 0回 | ✅ 使用可 |

**現在禁止サフィックス（2026-03時点）:**
- ❌ `-note`（kid-note, coord-note, oshi-noteで3回使用済み）
- ❌ `-log`（encore-log, sweet-log, lumi-log, petlife-log, sleep-log-aiで5回使用済み）
- ❌ `-ai`（things-ai, cosmic-ai, fridge-cook-aIで3回使用済み）
- ❌ `-mind`（gift-mind, vox-mindで2回使用済み）

**推奨サフィックスパターン（未使用・少使用）:**
`-pal`, `-hub`, `-spot`, `-flow`, `-bloom`, `-spark`, `-lens`, `-path`, `-craft`, `-joy`, `-boost`, `-glow`, `-pulse`, `-wave`, `-nest`（1回使用済み）, `-fi`（1回使用済み）など

### ローカライズ版（日本語含む）
- **英語名をそのまま使用**が基本
- **全言語でサブタイトルを付与する（必須）**
- 形式: `[英語アプリ名] 〜[各言語のサブタイトル]〜`
  - 例（日本語）: `Day Ritual 〜毎日のルーティン〜`
  - 例（中国語）: `Day Ritual ～每日习惯～`
  - 例（韓国語）: `Day Ritual ～매일의 루틴～`
- サブタイトルは**その言語ユーザーに刺さる価値訴求**を15文字以内で表現
- App Store Connect の「名前」フィールド（30文字制限）に収まること
- ARB の `productName` にこの形式で設定し、InfoPlist.strings・fastlane metadata にも反映

---

## 対象ファイル

### ARB（39言語）
`lib/l10n/app_{en,ja,zh,ko,de,fr,pt,es,hi,it}.arb`

### iOS
| ファイル | 内容 |
|---------|------|
| `ios/Runner/Info.plist` | CFBundleDisplayName, Keywords, Permissions |
| `ios/Runner/{lang}.lproj/InfoPlist.strings` | 各言語アプリ名（39言語） |

---

## 実装手順

### Step 1: アプリ名生成・選定
1. Phase 1のアイデアから核心的価値を抽出
2. **英語名5-7案を生成**（グローバル優先）
3. 選定後、**全言語（英語含む）のサブタイトルを同時に生成**
   - 各言語の文化・検索意図に合わせた15文字以内の価値訴求フレーズ
   - 英語形式: `[英語名] – [subtitle]`（例: `Day Ritual – Daily Habits`）
   - 非英語形式: `[英語名] 〜[サブタイトル]〜`（App Store名前フィールド30文字以内）

### Step 2: App Store重複チェック（必須）
```
検索: "[候補名]" site:apps.apple.com
```

| 状況 | 判定 |
|------|------|
| 完全一致あり | ❌ 使用不可 |
| 類似あり（同カテゴリ） | ⚠️ 別名推奨 |
| なし | ✅ 使用可 |

### Step 3: ARBファイル更新
- `productName`: 各言語のアプリ名を設定
  - **英語（en/en-AU/en-CA/en-GB）**: `"Day Ritual – Daily Habits"` （英語サブタイトル付き）
  - **英語以外の主要言語（ja/zh/ko等）**: `"Day Ritual 〜毎日のルーティン〜"` （サブタイトル付き）
  - **その他の言語**: サブタイトルなし（英語名のみ）でも可
- 空欄フィールド（`": ""`）を埋める:
  - `descriptionMessage`
  - `mainIntroductionScreen`
  - `mainIntroductionContent`
  - `serviceBeginContent`

**主要10言語のサブタイトル付き productName 設定例（Step 1で生成した値を使用）:**
```json
// app_en.arb
"productName": "Day Ritual – Daily Habits",

// app_ja.arb
"productName": "Day Ritual 〜毎日のルーティン〜",

// app_zh.arb
"productName": "Day Ritual ～每日习惯～",

// app_zh_Hant.arb
"productName": "Day Ritual ～每日習慣～",

// app_ko.arb
"productName": "Day Ritual ～매일의 루틴～",

// app_de.arb
"productName": "Day Ritual – Meine Routinen",

// app_fr.arb
"productName": "Day Ritual – Mes Routines",

// app_es.arb
"productName": "Day Ritual – Rutinas Diarias",

// app_pt.arb
"productName": "Day Ritual – Rotinas Diárias",

// app_hi.arb
"productName": "Day Ritual – दैनिक दिनचर्या",

// app_ar.arb
"productName": "Day Ritual – روتين يومي",
```

### Step 4: iOS設定更新

#### 4a. Info.plist の CFBundleDisplayName / CFBundleName を更新

```bash
# Step 3 で設定した英語アプリ名を ARB から取得
APP_NAME="$(python3 -c "import json; d=json.load(open('lib/l10n/app_en.arb')); print(d['productName'])")"
echo "アプリ名: $APP_NAME"

# Info.plist 更新
sed -i '' "/<key>CFBundleDisplayName<\/key>/{n;s/<string>[^<]*<\/string>/<string>${APP_NAME}<\/string>/;}" ios/Runner/Info.plist
sed -i '' "/<key>CFBundleName<\/key>/{n;s/<string>[^<]*<\/string>/<string>${APP_NAME}<\/string>/;}" ios/Runner/Info.plist
echo "✅ Info.plist 更新完了"
```

#### 4b. 全39言語の InfoPlist.strings を ARB の productName から自動更新

```bash
python3 << 'EOF'
import json, os, re

arb_dir = "lib/l10n"
lproj_base = "ios/Runner"

updated = []
skipped = []

for arb_file in sorted(os.listdir(arb_dir)):
    if not arb_file.startswith("app_") or not arb_file.endswith(".arb"):
        continue

    lang_code = arb_file[4:-4]           # "app_ja.arb" → "ja"
    lproj_lang = lang_code.replace("_", "-")  # "zh_Hant" → "zh-Hant"
    strings_path = f"{lproj_base}/{lproj_lang}.lproj/InfoPlist.strings"

    with open(f"{arb_dir}/{arb_file}") as f:
        data = json.load(f)

    product_name = data.get("productName", "")
    if not product_name:
        skipped.append(f"{lproj_lang} (productName 未設定)")
        continue

    if not os.path.exists(strings_path):
        skipped.append(f"{lproj_lang} (InfoPlist.strings なし)")
        continue

    with open(strings_path) as f:
        content = f.read()

    new_content = re.sub(
        r'"CFBundleDisplayName"\s*=\s*"[^"]*"',
        f'"CFBundleDisplayName" = "{product_name}"',
        content
    )

    with open(strings_path, "w") as f:
        f.write(new_content)

    updated.append(f"{lproj_lang}: {product_name}")

print("✅ 更新済み:")
for u in updated:
    print(f"   {u}")
if skipped:
    print("⏭️  スキップ:")
    for s in skipped:
        print(f"   {s}")
EOF
```

#### 4c. 結果確認

```bash
echo "=== Info.plist ==="
grep -A1 "CFBundleDisplayName" ios/Runner/Info.plist

echo ""
echo "=== InfoPlist.strings（サンプル） ==="
grep "CFBundleDisplayName" ios/Runner/en.lproj/InfoPlist.strings
grep "CFBundleDisplayName" ios/Runner/ja.lproj/InfoPlist.strings
grep "CFBundleDisplayName" ios/Runner/zh.lproj/InfoPlist.strings
```

---

## チェックリスト

- [ ] App Store重複チェック完了（英語名 + 主要市場）
- [ ] 全39言語ARBのproductName設定
- [ ] **英語を含む主要言語（en/en-AU/en-CA/en-GB/ja/zh/zh_Hant/ko/de/fr/es/pt/hi/ar）のサブタイトルが `productName` に含まれている**
- [ ] App Store Connect「名前」フィールドの30文字制限を全言語でクリア（`productName` が30文字以内）
- [ ] 空欄翻訳なし（`grep '": "",' lib/l10n/app_*.arb` = 0件）
- [ ] iOS Info.plist の CFBundleDisplayName / CFBundleName 更新（Step 4a）
- [ ] iOS InfoPlist.strings（全39言語）の CFBundleDisplayName 更新（Step 4b）
- [ ] 結果確認（Step 4c）

---

## 成果物

`docs/project/app_branding.md`:
```markdown
# アプリブランディング

## メイン名（グローバル）
- **英語名**: [名前]
- 決定理由: [理由]
- ASO キーワード: [英語]

## ローカライズ
| 言語 | productName（ARB / App Store 名前フィールド） |
|------|---------------------------------------------|
| en | [英語名] – [English subtitle] |
| ja | [英語名] 〜[日本語サブタイトル]〜 |
| zh | [英語名] ～[简体中文サブタイトル]～ |
| zh_Hant | [英語名] ～[繁體中文サブタイトル]～ |
| ko | [英語名] ～[한국어サブタイトル]～ |
| de | [英語名] – [Deutsch サブタイトル] |
| fr | [英語名] – [Français サブタイトル] |
| es | [英語名] – [Español サブタイトル] |
| pt | [英語名] – [Português サブタイトル] |
| hi | [英語名] – [हिंदी サブタイトル] |
| ar | [英語名] – [عربي サブタイトル] |
| その他 | [英語名]（サブタイトルなし） |

※ 全言語で30文字以内（App Store Connect 名前フィールド制限）
```

---

## 🤖 実行指示
- ARBファイル読み込み/更新は並列実行（39言語同時）
- iOS InfoPlist.strings更新も並列実行
