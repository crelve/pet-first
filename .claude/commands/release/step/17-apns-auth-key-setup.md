# 🔑 Step 17: APNs認証キーセットアップ

<!-- PROGRESS_COMMAND_ID: 17-apns-auth-key-setup -->
<!-- PROGRESS_PHASE: phase4 -->
<!-- PROGRESS_NAME: APNs認証キーセットアップ -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

**実行時間**: 自動（数秒）

Firebase Cloud Messaging用APNs認証キーをFirebase Consoleに登録します。
**Playwright自動化により、CEO手動操作不要です。**

## 自動設定（推奨）

共有APNsキー `AuthKey_UP344PGDBH.p8` をFirebaseの統合プロジェクトに一括登録する自動スクリプトが利用可能です。
新規アプリがFirebaseプロジェクトに追加されると、次回スクリプト実行時に自動的に検出・設定されます。

```bash
# 新規アプリが追加されたプロジェクトのみ実行（未設定を自動検出）
python3 ~/kikiki/released/company/engineering/scripts/batch-apns-playwright.py

# 特定プロジェクトのみ
python3 ~/kikiki/released/company/engineering/scripts/batch-apns-playwright.py \
  --projects kikiki-apps-overflow-prod
```

### 対象プロジェクト（統合済み）
- `kikiki-flutter-template-prod` — テンプレ・独立アプリ
- `kikiki-apps-overflow-prod` — overflow系30本
- `kikiki-apps-overflow2-prod` — overflow2系26本

### 動作仕様
- 既にAPNs設定済みのアプリ → SKIP（上書きしない）
- 未設定のアプリのみ → 自動アップロード
- `--force` フラグで既存設定も上書き可能

## 使用キー情報

| 項目 | 値 |
|------|-----|
| キーファイル | `~/.keys/apns/AuthKey_UP344PGDBH.p8` |
| Key ID | `UP344PGDBH` |
| Team ID | `TVU7FV638Y` |

> このキーは全アプリ共通（p8キーはチーム単位で全アプリに使用可能）。
> 年次更新不要。

## 手動設定が必要な場合

新しいFirebaseプロジェクト（統合対象外）へのAPNs設定は手動：

1. [Firebase Console](https://console.firebase.google.com) → プロジェクト選択
2. プロジェクト設定（⚙️） → **Cloud Messaging** タブ
3. **APNs Authentication Key** → Upload
4. `~/.keys/apns/AuthKey_UP344PGDBH.p8` をアップロード
5. Key ID: `UP344PGDBH` / Team ID: `TVU7FV638Y` → Save

---

## ✅ 完了時アクション

このコマンド完了後、**RELEASE_CHECKLIST.md のステータスを更新**してください：

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md

# 1. チェックボックス更新
- [ ] → - [x] **`/release:step:17-apns-auth-key-setup`**

# 2. セクションステータス更新
# Manual02の全コマンドが完了したら: 🔄 進行中 → ✅ 完了
```
