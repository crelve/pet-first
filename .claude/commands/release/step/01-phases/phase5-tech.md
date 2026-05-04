# 🏗️ Phase 5: 技術設計

## 目的
Phase 4で確定したMVP機能を実現するための技術アーキテクチャ設計

---

## 📥 企画書チェック（最初に実行）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
ls "$SPEC_PATH" 2>/dev/null
```

**企画書が存在する場合:**
- 企画書にデータモデルの言及があれば参考にする（ただし詳細設計はこのPhaseで行う）
- 企画書のMVP機能リストから必要な技術スタックを判定
- Firebase構成は企画書に関わらず下記の共通構成を適用

**企画書がない場合:**
- Phase 4のMVP機能定義から技術スタックを判定

---

## 必須Firebase構成（全アプリ共通）

| サービス | 用途 |
|---------|------|
| Hosting | 利用規約・プライバシーポリシー配信（審査必須） |
| Messaging (FCM) | プッシュ通知・リマインダー配信基盤 |
| App Check | デバイス改ざん防止・API不正利用対策（App Attest 必須） |
| Analytics | ユーザー行動分析・収益最適化 |
| Crashlytics | クラッシュレポート収集・品質保証 |
| Performance | パフォーマンス監視・レスポンス最適化 |

---

## 技術スタック

| カテゴリ | 選定 |
|---------|------|
| 状態管理 | Riverpod + Flutter Hooks |
| ローカルDB | Shared Preferences / Hive |
| UI | Material Design 3 |
| 多言語 | Flutter Intl |
| アーキテクチャ | Clean Architecture |

---

## AI機能技術スタック

[_common/ai-capabilities.md](_common/ai-capabilities.md) 参照

**コスト管理設計**:
- Firebase AI無料枠活用
- 1日あたりAPI呼び出し上限設定
- キャッシュ戦略
- オフライン時フォールバック

---

## セキュリティ設計

- ローカルストレージ暗号化
- API通信HTTPS必須
- ユーザーデータ保護
- **Firebase App Check（App Attest）**: Firestore・Cloud Functions への不正アクセス防止
  - 本番: `AppleAppAttestProvider`（Apple Developer Portal で App Attest Capability 要設定）
  - 開発: `AppleDebugProvider`
  - 初期化タイミング: `FirebaseAppCheck.instance.activate()` を Firestore より前に実行

---

## 成果物
- Firebase構成図
- 技術スタック一覧
- セキュリティ設計書
- AI機能技術設計書（採用時）

---

## 🤖 実行指示
- Firebase構成は固定テンプレート利用
- 設計図はMermaidで簡潔に表現
