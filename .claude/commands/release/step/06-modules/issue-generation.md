# Step 1: 要件からGitHub Issues生成（ハイブリッド方式対応）

> **📋 ハイブリッド方式対応**:
> - Part 2: 機能要件 (REQ-XXX) → 親Issueとして作成
> - Part 3: 画面別実装仕様 (SCR-XXX) → 実装Issueとして作成
> - Part 4: 共通機能 (COMMON-XXX, BG-XXX, SYS-XXX) → システムIssueとして作成

## 目的
`docs/project/requirements.md` (ハイブリッド方式) から自動的にGitHub Issuesを生成

---

## 🔴 Issue作成の前提条件（必須）

### ラベル事前作成（Issue作成前に必ず実行）

`gh issue create --label` で指定するラベルが存在しないと **Issue作成自体が失敗する**。
Issue作成の前に、必要なラベルを全て作成すること。

```bash
# 必須ラベルの一括作成（既存なら無視される）
for label in "P0:d73a4a:リリース必須" "P1:fbca04:推奨" "P2:0e8a16:v1.1以降" \
  "feature:1d76db:新機能" "infra:5319e7:インフラ" "screen:0075ca:画面実装" \
  "system:5319e7:システム機能" "common:c5def5:共通機能"; do
  IFS=':' read -r name color desc <<< "$label"
  gh label create "$name" --color "$color" --description "$desc" 2>/dev/null || true
done
echo "✅ ラベル作成完了"
```

### Issue作成結果の検証（必須）

Issue作成後、必ず結果を検証すること。`gh issue create` の出力が空やエラーの場合は再作成する。

```bash
# 作成後の検証
ISSUE_URL=$(gh issue create --title "..." --body "..." --label "..." 2>&1)
if echo "$ISSUE_URL" | grep -q "https://"; then
  echo "✅ Issue created: $ISSUE_URL"
else
  echo "❌ Issue creation failed: $ISSUE_URL"
  # ラベルなしで再試行
  gh issue create --title "..." --body "..."
fi
```

---

## 実行フロー

### 1. 要件ファイル読み込み（ハイブリッド方式）

#### 1-1. Part 2: 機能要件抽出 (REQ-XXX)
```bash
# Serena で機能要件を抽出（非コードファイル検索）
mcp__serena__search_for_pattern \
  substring_pattern="^\*\*REQ-[0-9]+\*\*:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=5
```

**重要**: `restrict_search_to_code_files=false` を指定することで、Markdownファイルでも検索可能になります。

#### 1-2. Part 3: 画面別実装仕様抽出 (SCR-XXX)
```bash
# Serena で画面IDを抽出（非コードファイル検索）
mcp__serena__search_for_pattern \
  substring_pattern="^### SCR-[A-Z0-9-]+:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=20
```

**重要**: `restrict_search_to_code_files=false` を指定することで、Markdownファイルでも検索可能になります。

#### 1-3. Part 4: 共通機能抽出 (COMMON/BG/SYS-XXX)
```bash
# Serena で共通機能を抽出（非コードファイル検索）
mcp__serena__search_for_pattern \
  substring_pattern="^\*\*(COMMON|BG|SYS)-[0-9]+\*\*:.*" \
  relative_path="docs/project/requirements.md" \
  restrict_search_to_code_files=false \
  output_mode="content" \
  context_lines_after=10
```

**重要**: `restrict_search_to_code_files=false` を指定することで、Markdownファイルでも検索可能になります。

### 2. Issue分類戦略

ハイブリッド方式では、以下の3種類のIssueを作成：

#### A. 機能要件Issue (REQ-XXX) - 親Issue
- **目的**: ビジネス要件の追跡
- **ラベル**: `epic`, `requirement`, `priority-*`
- **内容**: EARS記法の要件定義

#### B. 画面実装Issue (SCR-XXX) - 実装Issue
- **目的**: 実際の画面実装タスク
- **ラベル**: `screen`, `implementation`, `priority-*`
- **内容**: 画面機能の詳細実装仕様
- **関連**: 実装する機能要件(REQ-XXX)へのリンク

#### C. システム機能Issue (COMMON/BG/SYS-XXX) - システムIssue
- **目的**: 共通機能・バックグラウンド処理の実装
- **ラベル**: `system`, `common`, `priority-*`
- **内容**: 横断的機能の実装仕様

### 3. Issue作成フロー

#### 3-1. 画面実装Issue作成（SCR-XXX）

**画面単位でIssueを作成** - これが実際の実装タスクとなります

```bash
# 例: ログイン画面実装Issue
SCR_AUTH=$(gh issue create \
  --title "[SCR-AUTH] ログイン画面実装" \
  --body "$(cat <<'EOF'
## 📱 画面概要
**画面ID**: SCR-AUTH
**ファイルパス**: `lib/screen/auth/login_screen.dart`
**優先度**: 必須

## 🎯 画面の目的
ユーザー認証とGoogleログインによるアプリへのアクセス

## 📋 実装する機能要件
- **REQ-001**: ユーザー認証
- **REQ-002**: ソーシャルログイン

## 🔗 依存関係
### 前提条件（これらが完了していること）
なし（最初に実装する画面）

### このIssue完了後に実装可能になるIssue
- [ ] SCR-001 (ホーム画面) - 認証後に表示
- [ ] SCR-003 (設定画面) - ログイン状態が必要

## ✅ 受け入れ基準
### SCR-AUTH-F1: Google Sign-Inボタン表示
- [ ] Googleロゴ付きボタンが中央に表示
- [ ] タップでGoogle認証フロー開始
- [ ] ローディング中はボタン無効化

### SCR-AUTH-F2: 認証エラーハンドリング
- [ ] ネットワークエラー時はエラーメッセージ表示
- [ ] 認証キャンセル時は元の画面に戻る
- [ ] エラーメッセージは多言語対応

## 🔧 実装仕様
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

## 📊 Firebase連携
- **Authentication**: Google Sign-In Provider
- **Firestore**: なし（認証のみ）

## 🔗 画面遷移
- 認証成功 → ホーム画面 (SCR-001)
- 認証失敗 → ログイン画面のまま (エラー表示)

## 📖 関連ドキュメント
- docs/project/requirements.md#SCR-AUTH

## ⏱️ 見積もり
3-4時間
EOF
)" \
  --label "screen,implementation,auth,priority-high" \
  --assignee "@me" \
  --json number --jq '.number')

echo "Created screen issue #$SCR_AUTH"
```

#### 3-2. システム機能Issue作成（COMMON/BG/SYS-XXX）

**共通機能・バックグラウンド処理用のIssue**

```bash
# 例: 共通Provider実装Issue
COMMON_001=$(gh issue create \
  --title "[COMMON-001] UserProfileProvider実装" \
  --body "$(cat <<'EOF'
## 🔧 システム機能概要
**機能ID**: COMMON-001
**ファイルパス**: `lib/provider/user_profile_provider.dart`
**優先度**: 必須

## 🎯 機能の目的
ユーザー情報の一元管理と複数画面での共有

## 📋 使用画面
- SCR-001 (ホーム画面)
- SCR-003 (設定画面)

## 🔗 依存関係
### 前提条件（これらが完了していること）
- [ ] SCR-AUTH (ログイン画面) - 認証機能が必要

### このIssue完了後に実装可能になるIssue
- [ ] SCR-001 (ホーム画面) - このProviderを使用
- [ ] SCR-003 (設定画面) - このProviderを使用

## ✅ 受け入れ基準
- [ ] Firestoreからユーザー情報取得
- [ ] ユーザー情報の更新機能
- [ ] オフライン時のキャッシュ管理
- [ ] エラーハンドリング実装

## 🔧 実装仕様
```dart
// ファイル構成
lib/provider/
└── user_profile_provider.dart

// Firestore Schema
users/{uid}
  - name: string
  - email: string
  - photoUrl: string
  - createdAt: timestamp
```

## 📖 関連ドキュメント
- docs/project/requirements.md#COMMON-001

## ⏱️ 見積もり
2-3時間
EOF
)" \
  --label "system,common,provider,priority-high" \
  --assignee "@me" \
  --json number --jq '.number')

echo "Created system issue #$COMMON_001"
```

#### 3-3. Issue優先度の設定

ハイブリッド方式では、以下の優先順位でIssueを作成：

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

**Phase 4: システム機能** (高優先度)
9. SYS-001 (Firebase App Check / App Attest セットアップ)
10. SYS-002 (Push通知基盤統合 — flutter_foundation の `PushNotificationStateNotifier` / `handleCloudMessage` / `usePushNotificationToken` を app.dart で初期化・接続する。受信・権限・トークン管理は foundation 提供済み)
11. BG-001 (リマインダーPush通知 — `ReminderNotificationService` でFirestoreに保存 + Cloud Functions `processReminders` デプロイ。FCMトークンは `pushNotificationStateNotifierProvider` から取得)
12. SYS-003 (エラーハンドリング)
13. SYS-004 (Analytics連携)

```bash
# 優先度順にIssue作成
# Phase 1
gh issue create --title "[SCR-AUTH] ログイン画面実装" --label "screen,priority-critical,phase-1" ...
gh issue create --title "[COMMON-003] AuthProvider実装" --label "system,priority-critical,phase-1" ...

# Phase 2
gh issue create --title "[SCR-001] ホーム画面実装" --label "screen,priority-high,phase-2" ...
gh issue create --title "[SCR-002] 機能A画面実装" --label "screen,priority-high,phase-2" ...

# Phase 3-4
...
```

### 4. 作成確認
```bash
# Issue一覧確認（種類別）
gh issue list --label "screen"        # 画面実装Issue
gh issue list --label "system"        # システム機能Issue
gh issue list --label "common"        # 共通Provider Issue

# Phase別確認
gh issue list --label "phase-1"       # Phase 1: 認証基盤
gh issue list --label "phase-2"       # Phase 2: コア機能
gh issue list --label "phase-3"       # Phase 3: 設定・管理
gh issue list --label "phase-4"       # Phase 4: システム機能

# 優先度別確認
gh issue list --label "priority-critical"  # 最優先
gh issue list --label "priority-high"      # 高優先度
```

---

## 🤖 Claude Code への指示（ハイブリッド方式）

### トークン効率化
- 要件ファイルは Serena でパターン検索（Part別に検索、`restrict_search_to_code_files=false` 必須）
- **画面Issueは3-5個ずつバッチ実行**（GitHub API制限考慮）
- システムIssueも並列実行可能（依存関係がない場合）
- **作成結果をメモリに保存（Step 2-3で参照）**

### メモリ活用の具体例

**Step 1完了時にメモリ保存**:
```bash
# 作成されたIssue一覧をメモリに保存
mcp__serena__write_memory \
  memory_file_name="issues_created_step1" \
  content="$(cat <<EOF
# Step 1で作成されたIssue一覧

## 🎯 実装フェーズ別Issue

### Phase 1: 認証基盤（最優先）
- **COMMON-003**: AuthProvider実装 - Issue #${COMMON_003}
- **SCR-AUTH**: ログイン画面実装 - Issue #${SCR_AUTH}

### Phase 2: コア機能
- **SCR-001**: ホーム画面実装 - Issue #${SCR_001}
- **SCR-002**: 機能A画面実装 - Issue #${SCR_002}
- **SCR-002-1**: 新規作成画面実装 - Issue #${SCR_002_1}

### Phase 3: 設定・管理
- **SCR-003**: 設定画面実装 - Issue #${SCR_003}
- **COMMON-001**: UserProfileProvider実装 - Issue #${COMMON_001}
- **COMMON-002**: LocaleProvider実装 - Issue #${COMMON_002}

### Phase 4: システム機能
- **SYS-001**: Firebase App Check / App Attest - Issue #${SYS_001}
- **SYS-002**: Push通知基盤統合（foundation 提供機能の app.dart 初期化・接続）- Issue #${SYS_002}
- **BG-001**: リマインダーPush通知（ReminderNotificationService + Cloud Functions）- Issue #${BG_001}
- **SYS-003**: エラーハンドリング - Issue #${SYS_003}
- **SYS-004**: Analytics連携 - Issue #${SYS_004}

## 📊 統計
- 合計Issue数: 11個
- 画面Issue: 5個 (SCR-*)
- システムIssue: 6個 (COMMON-*, BG-*, SYS-*)

## ⏱️ 見積もり合計
- Phase 1: 6-8時間
- Phase 2: 12-15時間
- Phase 3: 10-12時間
- Phase 4: 8-10時間
- **総合計**: 36-45時間
EOF
)"

echo "✅ Issue一覧をメモリに保存しました: issues_created_step1"
```

**Step 2-3でメモリから参照**:
```bash
# Step 2: 開発環境セットアップ時にIssue情報を参照
mcp__serena__read_memory memory_file_name="issues_created_step1"

# Step 3: 初期実装準備時にIssue情報を参照
mcp__serena__read_memory memory_file_name="issues_created_step1"
```

**メモリ活用のメリット**:
- **トークン削減**: Issue一覧の再取得不要（`gh issue list` 実行不要）
- **情報の一貫性**: Step 1で作成したIssue番号を正確に参照可能
- **実装順序の明確化**: Phase別に整理された情報で実装の優先順位が明確

### Issue粒度の基準（ハイブリッド方式）

#### 画面実装Issue (SCR-XXX)
- **粒度**: **3-5時間で完了可能な単位**
- **ラベル**: `screen`, `implementation`, 技術領域, `priority-*`, `phase-*`
- **内容**:
  - 画面ID、ファイルパス
  - 実装する機能要件(REQ-XXX)へのリンク
  - 受け入れ基準（機能単位）
  - 実装仕様（Provider、Component、Firebase）
  - 画面遷移情報

#### システム機能Issue (COMMON/BG/SYS-XXX)
- **粒度**: **2-4時間で完了可能な単位**
- **ラベル**: `system`, `common`/`background`/`system`, `priority-*`, `phase-*`
- **内容**:
  - 機能ID、ファイルパス
  - 使用画面リスト
  - 受け入れ基準
  - 実装仕様

### Issue分割の例（ハイブリッド方式）

**良い分割例**（画面ベース）：
```
✅ SCR-AUTH: ログイン画面実装（3-4h）
✅ SCR-001: ホーム画面実装（3-4h）
✅ SCR-002: 機能A画面実装（4-5h）
✅ COMMON-003: AuthProvider実装（2-3h）
```

**悪い分割例**（粒度が大きすぎ）：
```
❌ SCR-ALL: 全画面実装（20時間以上）
```

**悪い分割例**（粒度が小さすぎ）：
```
❌ SCR-AUTH-BTN: ボタンWidget作成（30分）
❌ SCR-AUTH-STYLE: スタイル定義（30分）
```

### Issue数の目安（ハイブリッド方式）
- **5-8画面 = 5-8個の画面Issue**
- **共通機能 = 3-5個のシステムIssue**
- **合計 = 8-13個のIssue**が推奨
- 各Issueは**独立して実装・テスト可能**であること

### 依存関係の管理

**Issue作成時に依存関係を本文に明記する** - これにより適切な実装順序が明確になります

#### 依存関係の記述フォーマット

各Issue本文に以下のセクションを追加：

```markdown
## 🔗 依存関係
### 前提条件（これらが完了していること）
- [ ] #{ISSUE_NUMBER} ({ISSUE_TITLE}) - {依存理由}
- [ ] #{ISSUE_NUMBER} ({ISSUE_TITLE}) - {依存理由}

### このIssue完了後に実装可能になるIssue
- [ ] {ISSUE_ID} ({ISSUE_TITLE}) - {使用目的}
- [ ] {ISSUE_ID} ({ISSUE_TITLE}) - {使用目的}
```

#### 実装例

```bash
# Step 1: 基盤となるProvider作成（依存関係なし）
COMMON_003=$(gh issue create \
  --title "[COMMON-003] AuthProvider実装" \
  --body "$(cat <<'EOF'
## 🔗 依存関係
### 前提条件（これらが完了していること）
なし（最初に実装する基盤機能）

### このIssue完了後に実装可能になるIssue
- [ ] SCR-AUTH (ログイン画面) - 認証機能を使用
- [ ] SCR-001 (ホーム画面) - 認証状態を確認
EOF
)" \
  --label "system,common,priority-critical,phase-1")

# Step 2: AuthProviderに依存する画面作成
SCR_AUTH=$(gh issue create \
  --title "[SCR-AUTH] ログイン画面実装" \
  --body "$(cat <<'EOF'
## 🔗 依存関係
### 前提条件（これらが完了していること）
- [ ] #${COMMON_003} (AuthProvider実装) - 認証機能が必要

### このIssue完了後に実装可能になるIssue
- [ ] SCR-001 (ホーム画面) - 認証後に表示
- [ ] SCR-003 (設定画面) - ログイン状態が必要
EOF
)" \
  --label "screen,priority-critical,phase-1")

# Step 3: 両方に依存する画面作成
SCR_001=$(gh issue create \
  --title "[SCR-001] ホーム画面実装" \
  --body "$(cat <<'EOF'
## 🔗 依存関係
### 前提条件（これらが完了していること）
- [ ] #${COMMON_003} (AuthProvider実装) - 認証状態確認に必要
- [ ] #${SCR_AUTH} (ログイン画面実装) - ログイン後の遷移先

### このIssue完了後に実装可能になるIssue
- [ ] SCR-002 (機能A画面) - ホームから遷移
EOF
)" \
  --label "screen,priority-high,phase-2")
```

#### 依存関係の可視化

```
実装順序:
1. COMMON-003 (AuthProvider) ← 最優先（依存なし）
   ↓
2. SCR-AUTH (ログイン画面) ← COMMON-003に依存
   ↓
3. SCR-001 (ホーム画面) ← COMMON-003, SCR-AUTHに依存
   ↓
4. SCR-002 (機能A画面) ← SCR-001に依存
```

**重要**: Issue番号を変数に保存し、後続Issueの依存関係記述に使用することで、正確な依存関係を記録できます
