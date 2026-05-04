# ハイブリッド要件定義方式 - 完全ガイド

> **📋 ドキュメント概要**:
> EARS記法（システム全体要件）と画面ベース実装仕様を組み合わせた、Flutter開発に最適化された要件定義方式

---

## 🎯 ハイブリッド方式とは

### 従来の問題点

**EARS記法のみ:**
- ✅ システム全体の振る舞いは明確
- ❌ 実装時に「どのファイルに何を書くか」が不明確
- ❌ Firebase連携の具体的な実装が不足
- ❌ 画面遷移や UI要素の詳細が欠如

**画面ベースのみ:**
- ✅ 実装詳細が明確で実装しやすい
- ❌ ビジネス要件との紐付けが曖昧
- ❌ 非画面機能（バックグラウンド処理等）が漏れる
- ❌ EARS記法の本質（システム全体の振る舞い）から逸脱

### ハイブリッド方式の解決策

**4つのPartで構成:**

```
Part 1: ビジネス要件・非機能要件
  ↓ (ビジネス目標・成功指標)
Part 2: 機能要件 (EARS記法)
  ↓ (システム全体の振る舞い)
Part 3: 画面別実装仕様
  ↓ (具体的な実装詳細)
Part 4: 共通機能・非画面機能
  ↓ (横断的機能)
```

**メリット:**
- ✅ EARS記法の本質を保持（システム全体の振る舞い）
- ✅ 実装時の具体性を確保（ファイルパス、Firebase等）
- ✅ 機能漏れを防止（非画面機能を明示）
- ✅ Issue生成が自動化可能

---

## 📋 requirements.md の構造

### Part 1: プロジェクト概要・ビジネス要件

```markdown
## Part 1: プロジェクト概要・ビジネス要件

**プロジェクト名**: Your App Name
**バージョン**: 1.0.0
**概要**: アプリの概要説明

**ビジネス目標**:
- 目標1
- 目標2

### 非機能要件

#### パフォーマンス
- 画面表示時間: < 1秒
- Firebase取得時間: < 3秒

#### セキュリティ
- データ暗号化: AES-256
- 認証: Firebase Auth

#### システム構成
- フロントエンド: Flutter
- バックエンド: Firebase
- 状態管理: Riverpod + Flutter Hooks
```

**ポイント:**
- プロジェクト全体のビジネス目標を明確化
- 非機能要件（パフォーマンス、セキュリティ等）を集約
- 技術スタックを一元管理

---

### Part 2: 機能要件（EARS記法 - システム全体）

```markdown
## Part 2: 機能要件（EARS記法 - システム全体）

### 2.1 ユーザー認証機能

**REQ-001**: ユーザー認証
- **EARS**: システムは、ユーザーがアプリを起動した時、Firebase認証状態を確認し、未認証の場合はログイン画面を表示する必要がある
- **優先度**: 必須
- **実装画面**: SCR-AUTH (ログイン画面)
- **検証基準**:
  - 認証済みユーザーは直接ホーム画面へ遷移
  - 未認証ユーザーはログイン画面が表示される

**REQ-002**: ソーシャルログイン
- **EARS**: システムは、ユーザーがGoogleログインボタンをタップした時、Firebase AuthによるGoogle Sign-In処理を実行する必要がある
- **優先度**: 必須
- **実装画面**: SCR-AUTH (ログイン画面)
- **検証基準**:
  - Googleアカウント選択画面が表示される
  - 認証成功時はホーム画面へ遷移
  - 認証失敗時はエラーメッセージ表示
```

**ポイント:**
- **EARS記法でシステム全体の振る舞いを記述**
- 画面に依存しない要件定義
- 実装画面(SCR-XXX)へのリンクで紐付け

**EARS記法のルール:**
- ❌ 「ログイン画面は〜する」（画面に閉じた記述）
- ✅ 「システムは〜する」（システム全体の振る舞い）

---

### Part 3: 画面別実装仕様

```markdown
## Part 3: 画面別実装仕様

### SCR-AUTH: ログイン画面

**画面ID**: SCR-AUTH
**ファイルパス**: `lib/screen/auth/login_screen.dart`
**優先度**: 必須
**実装要件**: REQ-001, REQ-002

#### 🎯 画面の目的
ユーザー認証とGoogleログインによるアプリへのアクセス

#### 📋 画面で実現する機能

**SCR-AUTH-F1**: Google Sign-Inボタン表示
- **実装要件**: REQ-002
- **UI要素**: Googleロゴ付きボタン
- **状態管理**: `AuthProvider`
- **受け入れ基準**:
  - [ ] Googleロゴ付きボタンが中央に表示
  - [ ] タップでGoogle認証フロー開始
  - [ ] ローディング中はボタン無効化

**SCR-AUTH-F2**: 認証エラーハンドリング
- **実装要件**: REQ-002
- **UI要素**: エラーメッセージ表示領域
- **受け入れ基準**:
  - [ ] ネットワークエラー時はエラーメッセージ表示
  - [ ] 認証キャンセル時は元の画面に戻る
  - [ ] エラーメッセージは多言語対応

#### 🔧 実装仕様
```dart
// ファイル構成
lib/screen/auth/
├── login_screen.dart
└── widget/
    └── google_sign_in_button.dart

// 使用Provider
- AuthProvider (認証状態管理)

// 使用Component
- PrimaryButton
- Loading
- SnackBarUtility
```

#### 📊 Firebase連携
- **Authentication**: Google Sign-In Provider
- **Firestore**: なし（認証のみ）

#### 🔗 画面遷移
- 認証成功 → ホーム画面 (SCR-001)
- 認証失敗 → ログイン画面のまま (エラー表示)
```

**ポイント:**
- 画面単位で実装詳細を完全定義
- 実装する機能要件(REQ-XXX)へのリンク
- ファイルパス、Provider、Component、Firebaseスキーマを明記
- 受け入れ基準をチェックリスト形式で記載

---

### Part 4: 共通機能・非画面機能

```markdown
## Part 4: 共通機能・非画面機能

### 4.1 共通Provider

**COMMON-001**: UserProfileProvider
- **使用画面**: SCR-001, SCR-003
- **目的**: ユーザー情報の一元管理
- **Firestore**: `users/{uid}`
- **機能**:
  - ユーザー情報取得
  - ユーザー情報更新
  - キャッシュ管理

**COMMON-002**: LocaleProvider
- **使用画面**: 全画面
- **目的**: 多言語化対応
- **ローカルストレージ**: SharedPreferences
- **機能**:
  - 言語設定取得・保存
  - 言語変更時の全画面更新

### 4.2 バックグラウンド処理

**BG-001**: プッシュ通知ハンドリング
- **実装要件**: REQ-005
- **ファイルパス**: `lib/utility/push_notification_handler.dart`
- **機能**:
  - FCMメッセージ受信
  - フォアグラウンド通知表示
  - バックグラウンド通知処理
  - 通知タップ時の画面遷移
- **受け入れ基準**:
  - [ ] アプリ起動中は画面内通知
  - [ ] バックグラウンド時はシステム通知
  - [ ] 通知タップで適切な画面へ遷移

### 4.3 システム基盤機能

**SYS-001**: エラーハンドリング
- **ファイルパス**: `lib/utility/error_handler.dart`
- **機能**:
  - グローバルエラーキャッチ
  - エラーログ記録 (Firebase Crashlytics)
  - ユーザーフレンドリーなエラー表示
```

**ポイント:**
- **非画面機能を明示的に定義**（機能漏れ防止）
- 複数画面で使用する共通Providerを一元管理
- バックグラウンド処理を明確化
- システム基盤機能を集約

---

## 🔄 Issue生成戦略

### Issue の種類（ハイブリッド方式）

#### A. 画面実装Issue (SCR-XXX)
```bash
タイトル: [SCR-AUTH] ログイン画面実装

ラベル: screen, implementation, auth, priority-high, phase-1

本文:
- 画面ID、ファイルパス
- 実装する機能要件(REQ-XXX)へのリンク
- 受け入れ基準（チェックリスト）
- 実装仕様（Provider、Component、Firebase）
- 画面遷移情報
- 見積もり時間: 3-4時間
```

#### B. システム機能Issue (COMMON/BG/SYS-XXX)
```bash
タイトル: [COMMON-001] UserProfileProvider実装

ラベル: system, common, provider, priority-high, phase-3

本文:
- 機能ID、ファイルパス
- 使用画面リスト
- 受け入れ基準
- 実装仕様
- 見積もり時間: 2-3時間
```

### Issue優先度（Phase別）

**Phase 1: 認証基盤** (最優先)
1. SCR-AUTH (ログイン画面)
2. COMMON-003 (AuthProvider)

**Phase 2: コア機能**
3. SCR-001 (ホーム画面)
4. SCR-002 (機能A画面)
5. SCR-002-1 (新規作成画面)

**Phase 3: 設定・管理**
6. SCR-003 (設定画面)
7. COMMON-001 (UserProfileProvider)
8. COMMON-002 (LocaleProvider)

**Phase 4: システム機能**
9. BG-001 (プッシュ通知ハンドリング)
10. SYS-001 (エラーハンドリング)
11. SYS-002 (Analytics連携)

### Issue粒度の基準

- **画面Issue**: 3-5時間で完了可能
- **システムIssue**: 2-4時間で完了可能
- **合計Issue数**: 8-13個が推奨
- 各Issueは**独立して実装・テスト可能**

---

## 🚀 実装フロー

### Step 1: 要件定義作成 (`/01-project-init`)

1. **Phase 1-4**: 企画・市場分析・ビジネス設計
2. **Phase 5**: 技術設計
3. **Phase 6**: **requirements.md作成（ハイブリッド方式）**
   - Part 1: ビジネス要件
   - Part 2: 機能要件（EARS記法）
   - Part 3: 画面別実装仕様
   - Part 4: 共通機能・非画面機能

### Step 2: 画面設計（Optional - 必要に応じて）

`/04-screen-structure` で画面構成・遷移フローを詳細化

### Step 3: Issue自動生成 (`/06-setup-auto-implementation`)

requirements.md (ハイブリッド方式) から自動的にGitHub Issues生成

```bash
# Serenaでパターン検索
mcp__serena__search_for_pattern \
  substring_pattern="^### SCR-[A-Z0-9-]+:.*" \
  relative_path="docs/project/requirements.md"

# 画面Issueを並列生成
gh issue create --title "[SCR-AUTH] ログイン画面実装" ...
gh issue create --title "[SCR-001] ホーム画面実装" ...

# システムIssueを並列生成
gh issue create --title "[COMMON-001] UserProfileProvider実装" ...
```

### Step 4: Issue自動実装 (`/07-implement-issue`)

優先度順にIssueを1つずつ自動実装

```bash
# Phase 1から順次実装
/07-implement-issue  # SCR-AUTH実装
/07-implement-issue  # COMMON-003実装
/07-implement-issue  # SCR-001実装
...
```

---

## 📊 ハイブリッド方式 vs 従来方式

| 項目 | EARS記法のみ | 画面ベースのみ | **ハイブリッド方式** |
|------|------------|--------------|-------------------|
| ビジネス要件の明確性 | ✅ 高 | ❌ 低 | ✅ 高 |
| 実装詳細の具体性 | ❌ 低 | ✅ 高 | ✅ 高 |
| 非画面機能の網羅性 | △ 中 | ❌ 低 | ✅ 高 |
| Issue自動生成 | △ 可能だが複雑 | ✅ 容易 | ✅ 容易 |
| EARS記法の本質保持 | ✅ 保持 | ❌ 逸脱 | ✅ 保持 |
| 実装時の参照性 | ❌ 不足 | ✅ 十分 | ✅ 十分 |
| Firebase連携の明確性 | ❌ 不足 | ✅ 明確 | ✅ 明確 |
| 横断的機能の管理 | △ 中 | ❌ 困難 | ✅ 明確 |

---

## 🎯 ベストプラクティス

### 1. Part 2 (EARS記法) の書き方

**✅ 良い例:**
```markdown
**REQ-001**: ユーザー認証
- **EARS**: システムは、ユーザーがアプリを起動した時、Firebase認証状態を確認し、未認証の場合はログイン画面を表示する必要がある
```
→ システム全体の振る舞いを記述

**❌ 悪い例:**
```markdown
**REQ-001**: ユーザー認証
- **EARS**: ログイン画面は、Googleログインボタンを表示する必要がある
```
→ 画面に閉じた記述（Part 3に記載すべき）

### 2. Part 3 (画面別実装仕様) の書き方

**✅ 良い例:**
```markdown
### SCR-AUTH: ログイン画面

**実装要件**: REQ-001, REQ-002  ← 機能要件へのリンク

**SCR-AUTH-F1**: Google Sign-Inボタン表示
- **実装要件**: REQ-002  ← 具体的な要件へのリンク
- **UI要素**: Googleロゴ付きボタン  ← UI詳細
- **状態管理**: `AuthProvider`  ← 使用Provider
```

**❌ 悪い例:**
```markdown
### SCR-AUTH: ログイン画面

Googleログインできるようにする
```
→ 実装詳細が不足

### 3. Part 4 (共通機能) の管理

**複数画面で使う機能は必ずPart 4に記載:**

```markdown
**COMMON-001**: UserProfileProvider
- **使用画面**: SCR-001, SCR-003  ← 使用箇所を明記
```

→ 重複実装を防止

---

## 🔧 トラブルシューティング

### Q1: 画面に表示されない機能はどこに書く？

**A: Part 4の「バックグラウンド処理」または「システム基盤機能」に記載**

```markdown
### 4.2 バックグラウンド処理

**BG-001**: プッシュ通知ハンドリング
- **実装要件**: REQ-005
- **ファイルパス**: `lib/utility/push_notification_handler.dart`
```

### Q2: 複数画面で使う共通機能はどうする？

**A: Part 4の「共通Provider」に記載し、使用画面を明記**

```markdown
**COMMON-001**: UserProfileProvider
- **使用画面**: SCR-001, SCR-003, SCR-005
```

### Q3: Issue粒度が大きすぎる場合は?

**A: 画面を機能グループで分割**

```
❌ SCR-002: 機能A画面（10個の機能、15時間）

✅ SCR-002: 機能A - データ表示（3-4時間）
✅ SCR-002-A: 機能A - データ操作（3-4時間）
✅ SCR-002-B: 機能A - 共有・エクスポート（3-4時間）
```

### Q4: EARS記法と画面仕様の整合性は？

**A: Part 2で機能要件を定義し、Part 3で「実装要件」としてリンク**

```markdown
## Part 2
**REQ-002**: ソーシャルログイン
- **EARS**: システムは、ユーザーがGoogleログインボタンをタップした時...

## Part 3
### SCR-AUTH: ログイン画面
**実装要件**: REQ-001, REQ-002  ← リンク

**SCR-AUTH-F1**: Google Sign-Inボタン表示
- **実装要件**: REQ-002  ← 具体的なリンク
```

---

## 📚 関連ドキュメント

- [requirements.md テンプレート](../../docs/project/requirements.md)
- [Issue生成スクリプト](../commands/release/step/07-modules/issue-generation.md)
- [トークン効率化ベストプラクティス](../docs/best-practices/token-efficiency.md)

---

**最終更新**: 2025-01-30
**形式**: ハイブリッド方式 (EARS + 画面ベース)
