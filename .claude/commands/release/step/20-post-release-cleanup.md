# 🧹 Step 20: リリース後クリーンアップ

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->
<!-- AUTO_EXECUTE: true -->
<!-- NO_USER_INPUT: true -->

<!-- PROGRESS_COMMAND_ID: 20-post-release-cleanup -->
<!-- PROGRESS_PHASE: phase1 -->
<!-- PROGRESS_NAME: リリース後クリーンアップ -->
<!-- PROGRESS_TYPE: auto -->
<!-- PROGRESS_ESTIMATED_TIME: 2-3 -->
<!-- PROGRESS_DEPENDENCIES: [18-release-ios] -->
<!-- PROGRESS_STATUS: pending -->

**App Store公開完了後に実行** — リリースプロセスで使用したファイルを削除し、リポジトリをクリーンな状態にする

---

## 📋 削除対象

### 必ず削除するもの

| パス | 理由 |
|------|------|
| `.claude/commands/release/step/` | リリースステップ完了済み。運用フェーズでは不要 |
| `.claude/commands/release/RELEASE_CHECKLIST.md` | 同上 |
| `.claude/commands/release/README-AUTO.md` | 同上 |
| `.claude/commands/release/README-MANUAL.md` | 同上 |
| `docs/project/` | 企画・設計ドキュメント。company リポが正（Single Source of Truth） |
| `scripts/iap/setup_*.sh` | IAP セットアップ完了後は不要 |
| `scripts/iap/review_screenshot.png` | 審査用スクショ。提出済み |
| `scripts/create-core-issues.sh` | Issue 作成完了後は不要 |
| `scripts/requirements-check.sh` | 要件チェック完了後は不要 |

### 残すもの

| パス | 理由 |
|------|------|
| `.claude/commands/flutter/` | 開発中も使用するコマンド（analyze, fix-error 等） |
| `.claude/commands/git/` | PR 管理で使用 |
| `.claude/commands/utils/` | 品質チェック・テスト |
| `.claude/commands/analysis/` | 運用分析で使用 |
| `.claude/commands/release/operations/` | 運用 KPI で使用 |
| `.claude/docs/rules/` | コーディング規約は引き続き必要 |
| `.claude/docs/best-practices/` | 開発ベストプラクティス |
| `.claude/agents/` | エージェントロール |
| `.claude/skills/` | デザインスキル |
| `CLAUDE.md` | プロジェクトルール |
| `scripts/` のうち上記以外 | l10n, coverage 等は継続使用 |

---

## 📲 おすすめアプリ自動登録

リリース完了したアプリを、全アプリ共通の「おすすめアプリ」リストに自動追加する。

```bash
# アプリの App Store ID を取得（product_config.dart から）
APP_STORE_ID=$(grep -oP "iosAppId\s*=\s*'(\d+)'" lib/utility/product/product_config.dart | grep -oP '\d+' || grep -oP "_iosAppId\s*=\s*'(\d+)'" lib/utility/product/product_config.dart | grep -oP '\d+')

# おすすめアプリJSONに追加 + Firebase deploy + git push
~/kikiki/released/company/engineering/scripts/add-app-to-recommend.sh "$APP_STORE_ID"
```

> iTunes Search API からアプリ名・説明・アイコンを自動取得。apps.json に追加後、Firebase Hosting にデプロイされ、全アプリの「おすすめアプリ」画面に即時反映される。

---

## 🤖 実行指示

以下のコマンドを順に実行する:

```bash
# 1. リリースステップを削除
rm -rf .claude/commands/release/step/
rm -f .claude/commands/release/RELEASE_CHECKLIST.md
rm -f .claude/commands/release/README-AUTO.md
rm -f .claude/commands/release/README-MANUAL.md

# 2. 企画ドキュメントを削除（company が正）
rm -rf docs/project/

# 3. IAP セットアップスクリプトを削除
rm -f scripts/iap/setup_*.sh
rm -f scripts/iap/review_screenshot.png

# 4. その他の完了済みスクリプトを削除
rm -f scripts/create-core-issues.sh
rm -f scripts/requirements-check.sh

# 5. 空ディレクトリを削除
find . -type d -empty -not -path './.git/*' -delete 2>/dev/null

# 6. コミット
git add -A
git commit -m "chore: リリース後クリーンアップ — 不要なリリースファイルを削除"
git push
```

---

## ✅ 完了確認

- [ ] `.claude/commands/release/step/` が存在しないこと
- [ ] `docs/project/` が存在しないこと
- [ ] `.claude/commands/flutter/` が残っていること
- [ ] `.claude/docs/rules/` が残っていること
- [ ] `CLAUDE.md` が残っていること
- [ ] アプリが正常にビルドできること（`flutter build ios --no-codesign`）
- [ ] おすすめアプリJSON（apps.json）にアプリが追加されていること

---

## 📝 注意事項

- **このステップは App Store で公開が確認されてから実行する**（審査中は実行しない）
- company リポの `pm/tickets/{app}-release.md` にクリーンアップ完了を記録する
- 将来リリースステップが必要になった場合は、flutter-template から再取得可能
