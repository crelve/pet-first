<!-- PROGRESS_COMMAND_ID: 18-release-ios-submit -->
<!-- PROGRESS_PHASE: phase6 -->
<!-- PROGRESS_NAME: App Store提出（既存ビルド使用） -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

# Step 16: App Store提出（既存TestFlightビルドを使用）

> **⚠️ このステップはビルドしない。** Step 13でTestFlightに配信済みのビルドをそのままApp Store審査に提出する。
> `flutter build ipa` は絶対に実行しないこと。

---

## 前提確認

Step 13のビルドがTestFlightに存在することを確認:

```bash
# ASC APIでビルド一覧確認
python3 ~/kikiki/released/company/engineering/scripts/check-tf-expiry.py
```

ビルドが存在しない or 期限切れ → **このステップを中断してStep 13に戻す**

---

## App Store提出手順

### 1. App Store Connectでビルドを選択

```
https://appstoreconnect.apple.com/apps/{apple_id}/appstore/ios
```

- 「バージョン情報」→「ビルド」セクションで + ボタン
- Step 13でアップロードしたビルドを選択（バージョン番号・ビルド番号で確認）

### 2. 提出前チェックリスト

- [ ] バンドルID・バージョン番号が正しい
- [ ] スクリーンショット（Step 15）が設定済み
- [ ] メタデータ（Step 09）が設定済み
- [ ] プライバシーポリシーURLが設定済み
- [ ] REJECT歴あり → **提出しない。CEO実機確認後に手動提出**

### 3. 審査提出

```
「審査のために提出」ボタンをクリック
```

---

## ✅ 完了時アクション

1. building file の `current_step` を `"17"` に更新
2. `status: submitted` を追記
3. commit + push
