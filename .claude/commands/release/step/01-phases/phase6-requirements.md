# 📋 Phase 6: 要件定義作成（ハイブリッド方式）

## 目的
**ハイブリッド要件定義方式**による構造化要件定義作成

詳細ガイド: [hybrid-requirements-guide.md](../../../../docs/hybrid-requirements-guide.md)

---

## 📥 企画書チェック（最初に実行）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
ls "$SPEC_PATH" 2>/dev/null
```

**企画書が存在する場合:**
- 企画書のMVP機能リストを REQ-XXX に展開
- 企画書に画面構成の言及があれば SCR-XXX の起点にする
- 画面遷移図・ワイヤーフレームの詳細はこのPhaseで生成（企画書には含まれない）

**企画書がない場合:**
- Phase 4-5の出力から要件を定義

---

## Part 1-4構造

### Part 1: プロジェクト概要・ビジネス要件
- 基本情報、目標、非機能要件

### Part 2: 機能要件（EARS記法）
- **REQ-001**, **REQ-002**, ... 形式
- Event-driven / Adaptive / Requirement / State
- 実装画面（SCR-XXX）への紐付け

### Part 3: 画面別実装仕様
- **SCR-XXX**, **SCR-XXX-N** 形式
- ファイルパス、機能要件リンク、受け入れ基準、実装仕様、画面遷移

### Part 4: 共通機能・非画面機能
- **COMMON-XXX**: 共通Provider
- **BG-XXX**: バックグラウンド処理
- **SYS-XXX**: システム機能

**Part 4 必須エントリ（全プロジェクト共通）:**
- **SYS-001**: Firebase App Check（App Attest）初期化 — Firestore/Cloud Functions 保護
- **SYS-002**: Push通知基盤の統合 — flutter_foundation の `PushNotificationStateNotifier` / `handleCloudMessage` / `usePushNotificationToken` を使用（受信・権限・トークン管理は foundation が担う）
- **BG-001**: リマインダーPush通知（採用時）— `ReminderNotificationService`（送信スケジュール保存）+ Cloud Functions `processReminders`（スケジュール実行）。FCMトークンは `pushNotificationStateNotifierProvider` から取得して渡すこと

---

## 必須要件（UI/ナビゲーション基盤）

### REQ-020: メインナビゲーション
- タブ構成定義
- BaseScreen（IndexedStack）実装
- 状態保持・スクロール独立制御

### REQ-021: 画面遷移フロー
- 新規ユーザーフロー
- メインフロー
- GoRouterルート構成

### REQ-022: UI/UX基盤
- Material Design 3・ライト/ダークテーマ
- レスポンシブデザイン
- アニメーション（250ms）

---

## AI機能ガイドライン

[_common/ai-capabilities.md](_common/ai-capabilities.md) 参照

**要件に含めて良い**: テキスト生成、画像理解、ストリーミング
**含めてはいけない**: TTS、音声会話、動画生成

---

## 成果物

| ファイル | 内容 |
|---------|------|
| `docs/project/requirements.md` | ハイブリッド要件定義（Part 1-4） |
| `docs/project/requirements.json` | メタデータ |

---

## 検証ポイント

- [ ] Part 1-4全セクション存在
- [ ] REQ-XXX: 5個以上（REQ-020,021,022含む）
- [ ] SCR-XXX: 5-8画面
- [ ] COMMON-XXX: 3-5個
- [ ] REQ↔SCR紐付け明確
- [ ] SYS-001（App Check）が Part 4 に存在する
- [ ] SYS-002（Push通知基盤）が Part 4 に存在する

---

## 🤖 実行指示
- Phase 1-5メモリから情報集約
- `history.json` は保持して追加（上書き禁止）
