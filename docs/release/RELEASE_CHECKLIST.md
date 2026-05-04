# 🚀 Flutter リリースプロセス - 公式チェックリスト

<!-- PROGRESS_COMMAND_ID: 00-release-checklist -->
<!-- PROGRESS_PHASE: phase1-8 -->
<!-- PROGRESS_NAME: リリースチェックリスト -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

---

 

**Step 01: 以下のどちらかを選択**
- [x] `/release:step:01-guided-init` - **対話型**（アイデアがある時）
- [x] `/release:step:01-project-init` - **完全自動**（ゼロから探索）
- [x] `/release:step:02-brand-color-setup` - ブランドカラー設定
- [x] `/release:step:03-app-icons-images-guide` - アイコン・画像作成
- [x] `/release:step:04-screen-structure` - 画面構成設計
- [ ] `/release:step:05-project-deploy` - デプロイ
- [ ] `/release:step:06-setup-auto-implementation` - Issues作成・環境構築
- [ ] `/release:step:07-implement-issue` - Issue自動実装
- [ ] `/release:step:08-requirements-check` - 要件適合性チェック
- [ ] `/release:step:09-quality-rules-check` - 品質ルール確認
- [ ] `/release:step:09b-infoplist-check` - InfoPlist.strings パーミッション確認・修正
- [ ] `/release:step:10-appstore-metadata` - メタデータ生成
- [ ] `/release:step:11-monetization-complete` - AdMob設定
- [ ] `/release:step:12-ios-certificate-setup` - iOS証明書
- [ ] `/release:step:13-revenuecat-setup` - RevenueCat IA
- [ ] `/release:step:14-release-legal` - 法的要件整備
- [ ] `/release:step:15-run-app` - アプリ起動確認
- [ ] `/release:step:16a-ios-screenshot` - スクリーンショット生成
- [ ] `/release:step:16b-frame-auto` - 自動フレーム適用
- [ ] `/release:step:16c-frame-ai` - AI生成フレーム適用
- [ ] `/release:step:17-apns-auth-key-setup` - APNs認証キー
- [ ] `/release:step:18-release-ios` - App Store提出
- [ ] `/release:step:19-metrics-setup` - 日次レポート設定
- [ ] `/release:step:20-post-release-cleanup` - リリース後クリーンアップ

---

## 📋 CEO確認ポイント

各Stepの完了時に自動追記される。CEOが後から確認してチェックを入れる。

<!-- Step 03完了時に追記 -->
<!-- - [ ] Step 03: アイコン画像の確認 -->
<!-- Step 10完了時に追記 -->
<!-- - [ ] Step 10: メタデータ（キーワード・説明文）の確認 -->
<!-- Step 16完了時に追記 -->
<!-- - [ ] Step 16: スクショのビジュアル確認 -->
<!-- Step 18完了時に追記 -->
<!-- - [ ] Step 18: 提出前最終確認 -->

---

## 💡 使用方法

| 状態 | 表記 |
|------|------|
| 未着手 | ⬜ + `- [ ]` |
| 進行中 | 🔄 + 一部 `- [x]` |
| 完了 | ✅ + 全て `- [x]` |

**フロー**: Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6

---

## 📚 参考

| ドキュメント | 内容 |
|-------------|------|
| [README-AUTO.md](auto/README-AUTO.md) | 自動実行コマンド詳細 |
| [README-MANUAL.md](manual/README-MANUAL.md) | 手動実行コマンド詳細 |
| [Apple Design SKILL](../../skills/apple-design/SKILL.md) | iOS HIG準拠・UI設計 |

---

## ⚠️ App Storeリリース前チェック（ITMS-91061対策）

### Privacy Manifest確認
- [ ] `ios/Runner/PrivacyInfo.xcprivacy` が存在する
- [ ] Xcodeプロジェクト（Runner.xcodeproj）にPrivacyInfo.xcprivacyが追加されている
- [ ] `ios/Podfile` の `post_install` ブロックに `.xcprivacy` を削除するコードが**ない**こと
  - ❌ 削除すべきコード: `build_phase.remove_file_reference(file.file_ref)` (xcprivacy関連)
- [ ] `cd ios && pod install` を実行済み（最新のPrivacy Manifest統合）

### 確認コマンド
```bash
# xcprivacy削除コードが残っていないか確認
grep "xcprivacy" ios/Podfile

# Privacy Manifestが存在するか確認
ls ios/Runner/PrivacyInfo.xcprivacy
```
