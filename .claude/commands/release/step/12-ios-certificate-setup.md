# 🔐 Step 12: iOS証明書セットアップ【全自動】

<!-- PROGRESS_COMMAND_ID: 12-ios-certificate-setup -->
<!-- PROGRESS_PHASE: phase1 -->
<!-- PROGRESS_NAME: iOS証明書セットアップ -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->

ASC APIでBundle ID登録・Capabilities有効化・ExportOptions更新を全自動で実行します。

**実行時間**: 2-3分（全自動）
**CEO操作**: 不要

**重要**: このガイドの回答は必ず日本語で行ってください。

---

## 🎯 実行内容（3 Phase、全て自動）

1. **Phase 1**: Bundle ID整合（ExportOptions.plist + Xcodeプロジェクト更新）
2. **Phase 2**: ASC APIでBundle ID作成 + Capabilities有効化
3. **Phase 3**: ExportOptionsDev.plist更新

---

## 🔧 Phase 1: Bundle ID自動整合【AIが実行】

以下を自動で実行してください：

1. `dart_env/dev.env` から `appId` を取得
2. `dart_env/prod.env` から `appId` を取得

**ExportOptions.plist更新:**
3. `ios/ExportOptionsDev.plist` の provisioningProfiles キーを dev.env の appId に更新
4. `ios/ExportOptionsprod.plist` の provisioningProfiles キーを prod.env の appId に更新
5. プロファイル名は Fastlane match 形式:
   - dev: `match Development {dev.env appId}`
   - prod: `match AppStore {prod.env appId}`

**Xcodeプロジェクト更新:**
6. `ios/Runner.xcodeproj/project.pbxproj` の `PRODUCT_BUNDLE_IDENTIFIER` を prod.env の appId に更新
   - `YOUR_BUNDLE_ID` → `{prod.env appId}`

---

## 📋 事前確認: Bundle ID命名規則

- ✅ ハイフン（`-`）は使用可能
- ❌ アンダースコア（`_`）は使用不可 → `Invalid identifier` エラー

環境変数ファイルにアンダースコアがあれば、ハイフンに修正してから続行すること。

---

## 🚀 Phase 2: ASC APIでBundle ID登録 + Capabilities有効化【AIが実行】

`ios/fastlane/.env` からASC認証情報を読み取り、ASC APIでBundle IDを自動登録します。

**実行コマンド:**
```bash
python3 ~/kikiki/released/company/engineering/scripts/register-bundle-ids.py ${PROJECT_NAME}
```

このスクリプトが自動で実行する内容:
1. **prod Bundle ID登録**: `POST /v1/bundleIds` — prod.env の appId
2. **dev Bundle ID登録**: `POST /v1/bundleIds` — dev.env の appId（.dev付き）
3. **Capabilities有効化**: 以下4つを `POST /v1/bundleIdCapabilities` で有効化（prod/dev両方）
   - PUSH_NOTIFICATIONS
   - ASSOCIATED_DOMAINS
   - APP_ATTEST
   - IN_APP_PURCHASE
4. **ASCアプリ存在確認**: アプリが未作成の場合はGUI作成手順を表示

**注意**: ASCアプリの新規作成（`+ 新規App`）はAPIで実行不可のため、必要な場合のみ手動で作成してください。既にStep 05で作成済みの場合はスキップOK。

---

## 🔧 Phase 3: ExportOptionsDev.plist最終確認【AIが実行】

Phase 1で更新した内容を最終確認:

```bash
# Bundle IDが正しく設定されているか確認
grep -A1 "provisioningProfiles" ios/ExportOptionsDev.plist
grep -A1 "provisioningProfiles" ios/ExportOptionsprod.plist
grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | head -5
```

---

## ✅ 完了確認

- [ ] 【Phase 1】ExportOptions.plist のBundle ID整合済み
- [ ] 【Phase 1】Xcode project.pbxproj のBundle ID整合済み
- [ ] 【Phase 2】prod Bundle ID登録済み（ASC API）
- [ ] 【Phase 2】dev Bundle ID登録済み（ASC API）
- [ ] 【Phase 2】Capabilities有効化済み（Push Notifications / Associated Domains / App Attest / IAP）
- [ ] 【Phase 3】ExportOptionsDev.plist最終確認OK

**Provisioning Profileについて**: fastlane match がCI時に自動生成するため、Step 12では不要です。

---

## 🔧 トラブルシューティング

**Q: register-bundle-ids.py が認証エラーになる**
- `~/.private_keys/AuthKey_AN77R722CJ.p8` が存在するか確認
- トークンの有効期限は20分。再実行すれば自動更新される

**Q: Bundle ID登録で409エラー**
- 既に登録済み。スクリプトは自動でGIDを取得して続行する

**Q: Capabilityの有効化に失敗する**
- 一部のCapability（Sign In with Apple等）はApple Developer Program Agreement への追加同意が必要な場合がある
- 必須4つ（Push/AssociatedDomains/AppAttest/IAP）以外は後から追加可能

---

## ✅ 完了時アクション

このコマンド完了後、**RELEASE_CHECKLIST.md のステータスを更新**してください：

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md

# 1. チェックボックス更新
- [ ] → - [x] **`/release:step:12-ios-certificate-setup`**

# 2. セクションステータス更新（最初の完了時のみ）
### **Auto01: プロジェクト初期化 + 証明書** ⬜ 未着手
↓
### **Auto01: プロジェクト初期化 + 証明書** 🔄 進行中
```

---

**Assistant Instructions:**
- このコマンドを実行する際は、必ず日本語で回答してください
- Phase 1 → Phase 2 → Phase 3 を順番に実行してください
- Phase 2の `register-bundle-ids.py` はcompanyリポのスクリプトを呼び出します
- 全て自動実行。CEO操作は不要です
