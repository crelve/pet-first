# 💰 Step 11: IAP登録 + AdMob広告ユニット作成（自動）

<!-- PROGRESS_COMMAND_ID: 11-monetization-complete -->
<!-- PROGRESS_PHASE: phase4 -->
<!-- PROGRESS_NAME: IAP登録+AdMob広告ユニット -->
<!-- PROGRESS_TYPE: auto -->
<!-- AUTO_EXECUTE: true -->
<!-- NO_USER_INPUT: true -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 3-5分（全自動）

ASC IAP登録（サブスクリプション月額/年額 + 買い切り）、39言語ローカリゼーション、AdMob広告ユニット作成を全自動で行う。

## 前提条件

- App Store Connect でアプリが作成済み（Step 12 完了）
- `docs/project/business_design.md` に価格情報が記載済み（Phase 4 で生成）
- `config/api-keys.conf` が設定済み（company リポ）

## 自動実行手順

### 1. 価格情報の取得

`docs/project/business_design.md` から月額・年額・買い切り価格（JPY）を読み取る。

```bash
# business_design.md から価格を抽出
# 月額: monthly_price_jpy
# 年額: annual_price_jpy (= monthly × 7〜8.5)
# 買い切り: lifetime_price_jpy (= annual × 2.5)
```

### 2. アプリ情報の取得

```bash
APP_NAME=$(basename $(pwd))
# pubspec.yaml から Bundle ID を取得
BUNDLE_ID=$(grep -A2 'PRODUCT_BUNDLE_IDENTIFIER' ios/Runner.xcodeproj/project.pbxproj | head -1 | sed 's/.*= "\(.*\)";/\1/' || echo "")
# dart_env/prod.env から Bundle ID を取得（フォールバック）
[ -z "$BUNDLE_ID" ] && BUNDLE_ID=$(grep 'bundleId=' dart_env/prod.env 2>/dev/null | cut -d= -f2 | tr -d '"')
```

### 3. step11-setup-iap-admob.py を実行

```bash
python3 ~/kikiki/released/company/engineering/scripts/step11-setup-iap-admob.py \
  "$APP_NAME" "$BUNDLE_ID" \
  --monthly "$MONTHLY_PRICE" \
  --yearly "$YEARLY_PRICE" \
  --lifetime "$LIFETIME_PRICE"
```

スクリプトが自動で以下を実行:
1. ASC サブスクリプショングループ作成
2. 月額サブスク作成 + 価格設定
3. 年額サブスク作成 + 価格設定
4. 買い切り IAP 作成 + 価格設定
5. 全商品を39言語ローカライズ
6. AdMob広告ユニット4種作成（バナー/インタースティシャル/リワード/アプリ起動）

### 4. dart_env/prod.env 更新

スクリプトの出力からAdMob広告ユニットIDを取得し、`dart_env/prod.env` に反映。

### 5. Info.plist の AdMob app ID 更新（重要）

テンプレ流用時、Info.plist の `GADApplicationIdentifier` は孤児テンプレapp `~1338814004` のままになる。
**このアプリ専用の AdMob app を作成し、Info.plist を更新する必要がある**:

```bash
# AdMob app ID（~XXXXXXXXXX）を取得後、Info.plist を更新
python3 ~/kikiki/released/company/engineering/scripts/update-admob-app-id.py "$APP_NAME" ca-app-pub-2443502666087876~XXXXXXXXXX
```

これを忘れると 収益が孤児app `~1338814004` に計上され AdMob管理画面で表示できない。

### 6. 検証

```bash
# IAP作成の確認（結果JSONを確認）
ls ~/kikiki/released/company/engineering/scripts/step11-result-${APP_NAME}-*.json
# prod.env + Info.plist の AdMob ID 検証（本番値か / テスト値・孤児ID残留してないか）
bash ~/kikiki/released/flutter-template/scripts/validate-prod-ad-ids.sh dart_env/prod.env
```

`validate-prod-ad-ids.sh` は以下を検出:
- `dart_env/prod.env` の AdMob unit ID が空 / Google テストID `3940256099942544`
- `ios/Runner/Info.plist` の GADApplicationIdentifier が孤児テンプレapp `~1338814004`

## エラー時

- 価格ポイントが見つからない場合: ASCで手動設定（CEOタスク起票）
- AdMobアプリ未登録の場合: AdMob管理画面でアプリ追加 + ASCリスティングへリンク（CEOタスク起票）
- API認証エラー: `secretary/fix-gcloud-auth.sh` または P8キーの確認

## 完了条件

- ASCにサブスクリプション3種（monthly/yearly/lifetime）が作成済み
- 全商品に39言語ローカリゼーションが設定済み
- AdMob広告ユニットIDが `dart_env/prod.env` に反映済み
- **Info.plist GADApplicationIdentifier が `~1338814004` 以外の本アプリ専用 AdMob app ID**
- `validate-prod-ad-ids.sh` が PASS
