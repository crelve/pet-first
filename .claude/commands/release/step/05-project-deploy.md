# 🚀 Step 05: プロジェクトデプロイ

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->
<!-- AUTO_EXECUTE: true -->
<!-- NO_USER_INPUT: false -->

<!-- PROGRESS_COMMAND_ID: 05-project-deploy -->
<!-- PROGRESS_PHASE: phase2 -->
<!-- PROGRESS_NAME: プロジェクトデプロイ -->
<!-- PROGRESS_TYPE: auto -->
<!-- PROGRESS_ESTIMATED_TIME: 5-8 -->
<!-- PROGRESS_DEPENDENCIES: ["01-project-init"] -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_EXECUTION_START: -->
<!-- PROGRESS_EXECUTION_END: -->
<!-- PROGRESS_DURATION_MINUTES: -->
<!-- PROGRESS_RESULT: -->
<!-- PROGRESS_LOGS: [] -->

**実行時間**: 5-8分

Firebase環境構築・GitHub統合・プロジェクト設定を完全自動化します。

---

## 🤖 AI自動実行フロー

### Phase 7: GitHub Issues・プロジェクト管理
🔗 **GitHub Issues自動生成 → Milestone・Project Board構築**

**自動実行される処理:**
```bash
# 1. GitHub Issues Template自動生成
# docs/project/requirements.md から機能別Issue自動生成

# 2. Milestone自動作成
# 22ステップフェーズ管理用マイルストーン
gh api repos/{owner}/{repo}/milestones -f title="Phase 1: 企画・設計"
gh api repos/{owner}/{repo}/milestones -f title="Phase 2: 環境構築"
# ... 全6フェーズ分

# 3. Project Board自動作成
# リリース進捗トラッキングボード（To Do/In Progress/Done）
gh project create --owner {owner} --title "${PROJECT_NAME} Release Progress"

# 4. Issue自動リンク
# 各IssueをMilestone・Project Boardに自動割当
```

**生成されるGitHub構造:**
- **Issues**: 要件定義ベースの実装タスクIssue（自動ラベル付与）
- **Milestones**: Phase1-6の進捗管理マイルストーン
- **Project Board**: 3カラム形式の進捗ボード（Issue自動リンク）

### Phase 8: Firebase環境構築
🔥 **必須Firebase設定 → 本番環境作成・Dev環境は作れる状態に整備**

**🚨 重要**: このフェーズは**全プロジェクトで必須実行**（オフラインアプリ・Firebase不使用アプリでも実行必須）

**Dev環境の方針:**
- **Dev Firebase プロジェクトは作成しない**（ローカル開発時に手動で作成できれば十分）
- `.firebaserc` と `dart_env/dev.env` はテンプレートとして整備するのみ
- 実際の開発はProd環境で行う（必要になったときだけDevを作成）

**自動実行される処理:**

> ⚠️ **Firebase統合方式（2026-04-02〜）**: 新規プロジェクト作成ではなく、カテゴリ別統合先プロジェクトにアプリを追加する。
> マッピング: `~/kikiki/released/company/config/firebase-category-mapping.conf`
> 設計書: `~/kikiki/released/company/engineering/docs/firebase-project-consolidation.md`

```bash
# 1. 統合先プロジェクトにiOSアプリを追加【必須】
# company/config/firebase-category-mapping.conf でアプリ→プロジェクトを自動判定
# まず dry-run で確認 → 問題なければ本番実行
bash ~/kikiki/released/company/engineering/scripts/firebase-add-app.sh ${PROJECT_NAME} --dry-run
bash ~/kikiki/released/company/engineering/scripts/firebase-add-app.sh ${PROJECT_NAME}

# ※ firebase-add-app.sh が自動で以下を実行:
#   - firebase apps:create ios（統合先プロジェクトにアプリ登録）
#   - flutterfire configure（GoogleService-Info.plist等 生成）
#   - .firebaserc 更新
#   - Firebase API有効化

# ※ マッピング未登録の場合はDEFAULT（kikiki-apps-overflow-prod）が使われる
# ※ 事前に mapping.conf にエントリを追加することを推奨

# 2. 環境変数ファイル更新【必須】
# dart_env/dev.env, dart_env/prod.env の appId を PROJECT_NAME に基づいて更新

# ⚠️ 重要: appId は iOS Bundle ID 形式（ドット区切り）で置換すること
# - PROJECT_NAME（リポ名）のハイフンをドットに変換して使う
# - dev.env:  appId=${APP_ID}.dev   (例: day.dot.dev)
# - prod.env: appId=${APP_ID}       (例: day.dot)
# pbxproj PRODUCT_BUNDLE_IDENTIFIER / ASC 登録 と必ず一致させること。
# 乖離すると fastlane match が「存在しない App ID」を探して失敗する。

# Bundle ID 形式への変換（ハイフン → ドット）
APP_ID="${PROJECT_NAME//-/.}"

# 置換処理（必須実行）
sed -i '' "s/appId=kikiki.flutter.template.dev/appId=${APP_ID}.dev/g" dart_env/dev.env
sed -i '' "s/appId=kikiki.flutter.template/appId=${APP_ID}/g" dart_env/prod.env

# universalLinks も更新（統合先プロジェクトIDを使用）
# ※ firebase-add-app.sh が .firebaserc を更新済みなので、そこからプロジェクトIDを取得
FIREBASE_PROJECT=$(python3 -c "import json; print(json.load(open('.firebaserc'))['projects']['prod'])")
sed -i '' "s/universalLinks=kikiki-flutter-template-dev/universalLinks=${PROJECT_NAME}-dev/g" dart_env/dev.env
sed -i '' "s/universalLinks=kikiki-flutter-template-prod/universalLinks=${FIREBASE_PROJECT}/g" dart_env/prod.env

# 置換結果の検証（必須）
echo "=== dart_env/dev.env の appId 確認 ==="
grep "appId=" dart_env/dev.env
echo "=== dart_env/prod.env の appId 確認 ==="
grep "appId=" dart_env/prod.env

# ❌ 検証失敗条件: 以下が残っている場合はエラー
# - kikiki.flutter.template が残っている → 置換失敗

# 3. Firebase バンドルID整合性チェック【必須】
# lib/firebase_options.dart の iosBundleId が
# GoogleService-Info.plist / Xcode PRODUCT_BUNDLE_IDENTIFIER と一致することを検証。
# 2026-04 までに `.prod` suffix 残留が多数発生しており、このチェック無しでは
# Firebase.initializeApp が起動時に validation エラーを投げる。
bash ~/kikiki/released/company/engineering/scripts/verify-firebase-bundle-id.sh
```

**Firebase プロジェクトID制約:**

⚠️ **必ず遵守**: Firebase プロジェクトIDは [.claude/docs/rules/naming_conventions.md](../../docs/rules/naming_conventions.md#firebase-プロジェクトid) で定義された命名規則に**厳密に従う**必要があります。

**重要な制約（詳細はnaming_conventions.mdを参照）:**
- ✅ **ケバブケース**: `habit-flow-dev`, `quick-shop-prod`
- ❌ **アンダースコア禁止**: `habit_flow_dev` は不可
- ❌ **大文字禁止**: `HabitFlow-dev` は不可

**📖 完全なルール**: [命名規則ガイド - Firebase プロジェクトID](../../docs/rules/naming_conventions.md#firebase-プロジェクトid)

**🔥 必須Firebase機能（全プロジェクト共通・スキップ不可）:**

**【必須インフラ】（オフラインアプリでも必須）**
- ✅ **Firebase Hosting**: 利用規約・プライバシーポリシー・アプリ情報ページ配信（App Store審査必須）
- ✅ **Firebase Messaging (FCM)**: プッシュ通知・リマインダー配信基盤（将来の機能拡張・ユーザー再訪促進に必須）
- ✅ **Firebase App Check**: デバイス改ざん防止・API不正利用対策（App Attest — Apple Developer Portal での Capability設定必須）
- ✅ **Firebase Analytics**: ユーザー行動分析・収益化最適化（広告収益向上に必須）
- ✅ **Firebase Crashlytics**: クラッシュレポート収集・品質保証（ユーザー体験向上に必須）
- ✅ **Firebase Performance Monitoring**: パフォーマンス監視・レスポンス最適化（離脱率低減に必須）

**【要件定義に基づくオプション機能有効化】**

**【認証要件レベル別】**
- **Level 0 (なし)**: Firebase Auth無効化（ローカルストレージのみ）
- **Level 1 (基本)**: Email/Password認証
- **Level 2 (ソーシャル)**: Google Sign-In追加
- **Level 3 (企業)**: Apple Sign-In、電話番号認証

**【データベース要件別】**
- **完全オフライン**: Firebase Auth・Firestore・Cloud Storage無効化
- **クラウド同期あり**: Firestore + Realtime Database
- **オフライン優先**: Firestore offline persistence有効化
- **大容量データ**: Cloud Storage自動有効化

**【分析・監視要件別】**
- **基本分析**: Firebase Analytics（必須）
- **高度分析**: Google Analytics 4連携
- **エラー監視**: Crashlytics + Performance Monitoring（必須）

**⚠️ スキップ禁止**: 「完全オフライン」「Firebase不使用」アプリでも、上記必須Firebase機能は構築必須です。
理由: App Store審査、プッシュ通知基盤、分析基盤、品質保証は全アプリで必要。

### Phase 9: プロジェクト設定統合
⚙️ **設定統合適用 → パッケージ名・環境変数・依存関係更新**

**自動実行される処理:**

#### 1. 基本置換処理（Makefile `replace-content`）
```bash
make replace-content PROJECT_NAME=${PROJECT_NAME}
```

**置換される項目:**
- **環境変数ファイル【必須・最優先】**:
  - `dart_env/dev.env` の `appId` → `${PROJECT_NAME}.dev`
  - `dart_env/prod.env` の `appId` → `${PROJECT_NAME}`
  - `universalLinks` も同様に更新
- **Dart/Flutter設定**:
  - `pubspec.yaml` の `name` フィールド
  - `lib/l10n/*.arb` の `productName` フィールド（全言語対応）
  - Dartパッケージインポート一括置換（`lib/`, `test/` 全ファイル）
    - `package:flutter_template` → `package:${PROJECT_NAME}`
- **ビルド設定**:
  - `Makefile` の `FIREBASE_PROJECT_ID` / `APP_ID`
  - `ios/Runner/Info.plist` の `CFBundleDisplayName` / `CFBundleName`
- **ネイティブコード**:
  - iOS: Bundle ID更新
- **CI/CD設定**:
  - `fastlane` 環境設定の更新
  - `package-lock.json` の名前更新

#### 2. AI駆動ドキュメント更新

**README.md の更新:**
- プロジェクト名・概要を `docs/project/requirements.md` から抽出
- 主要機能リストの自動生成
- 技術スタック・アーキテクチャの調整
- スクリーンショット・デモリンクのプレースホルダ追加

**CLAUDE.md の更新:**
- プロジェクト名・目的の詳細更新
- 主要機能リストを要件定義から生成
- Firebase機能の有効化状態を反映
- 開発セットアップ手順のカスタマイズ
- プロジェクト固有の注意事項追加

**.claude/README.md の更新:**
- タイトルをプロジェクト名に合わせて更新
- Claude Code Cookbook の説明をプロジェクト固有に調整
- プロジェクト特有のコマンド・役割の追加

**その他のドキュメント:**
- `.claude/docs/rules/` 配下の参照を尊重
- プロジェクト固有のルール・ガイドラインを追加

#### 3. テンプレートベース生成ルール
- `docs/project/requirements.md` の内容を解析
- プロジェクトのコンセプト・差別化ポイントを抽出
- ドキュメント構造は `.claude/docs/rules/` に準拠
- 自動生成されたセクションには明確なマーキング

#### 4. .gitignore の更新
```bash
# previous_flavor.txt を .gitignore に追加（まだ追加されていない場合）
if ! grep -q "previous_flavor.txt" .gitignore; then
  echo "previous_flavor.txt" >> .gitignore
  echo "✓ .gitignore に previous_flavor.txt を追加しました"
fi

# previous_flavor.txt が既にGit追跡対象の場合は削除
if git ls-files --error-unmatch previous_flavor.txt > /dev/null 2>&1; then
  git rm --cached previous_flavor.txt
  echo "✓ previous_flavor.txt をGit追跡対象から除外しました"
fi
```

#### 5. Bundle ID整合性チェック【必須】
```bash
# Xcode Bundle ID
XCODE_BUNDLE=$(grep 'PRODUCT_BUNDLE_IDENTIFIER' ios/Runner.xcodeproj/project.pbxproj | head -1 | sed 's/.*= //;s/;//;s/[[:space:]]//g;s/"//g')
# prod.env appId
PROD_APP_ID=$(grep '^appId=' dart_env/prod.env | cut -d= -f2)
# Firebase GoogleService-Info.plist Bundle ID
FIREBASE_BUNDLE=$(/usr/libexec/PlistBuddy -c "Print :BUNDLE_ID" ios/Runner/GoogleService-Info.plist 2>/dev/null)

echo "Xcode:    $XCODE_BUNDLE"
echo "prod.env: $PROD_APP_ID"
echo "Firebase: $FIREBASE_BUNDLE"

# 3つが一致しなければエラー
if [ "$XCODE_BUNDLE" != "$FIREBASE_BUNDLE" ]; then
  echo "❌ Bundle ID不一致! Xcode=$XCODE_BUNDLE, Firebase=$FIREBASE_BUNDLE"
  echo "→ gen-firebase-configを正しいBundle IDで再実行してください"
  exit 1
fi
echo "✅ Bundle ID整合性OK"
```

#### 6. 最終検証・コミット
```bash
# 設定ファイル整合性確認
flutter analyze --no-fatal-infos

# 環境変数テンプレート検証
test -f dart_env/dev.env && test -f dart_env/prod.env

# 最終コミット・プッシュ
git add .
git commit -m "🔧 Configure project settings for ${PROJECT_NAME}"
git push
```

---

## 🚀 事前準備

### 必須認証確認
```bash
# GitHub CLI の認証確認
gh auth status

# Firebase CLI の認証確認
# ⚠️ Claude Code内では対話型ログインができないため、
# 事前に通常のターミナルでログインしておく必要があります
firebase login

# または、既にログイン済みか確認
firebase login:list

# プロジェクトデプロイ実行
/release:step:05-project-deploy
```

---

## 📝 構築される環境

### 🔗 GitHubプロジェクト統合
- **Repository**: プライベートリポジトリ（初回コミット済み）
- **Issues**: 要件定義ベースの実装タスク（自動生成）
- **Milestones**: 22ステップフェーズ管理用マイルストーン
- **Project Board**: リリース進捗トラッキングボード（3カラム）

### 🔥 Firebase環境
- **本番環境**: `${PROJECT_NAME}-prod`
  - FlutterFire設定ファイル自動生成済み
  - 本番用環境変数テンプレート配置済み
- **開発環境**: `${PROJECT_NAME}-dev`（未作成・作れる状態）
  - `.firebaserc` にプロジェクトID記載済み
  - `dart_env/dev.env` テンプレート配置済み
  - 作成時: `make create-firebase-project PROJECT_NAME=${PROJECT_NAME}` + `make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod`

### ⚙️ プロジェクト設定
- **パッケージ名**: `com.example.${PROJECT_NAME}` に統一
- **Bundle ID**: `com.example.${PROJECT_NAME}` に統一
- **アプリ名**: 全言語の `l10n/*.arb` で統一
- **ドキュメント**: README/CLAUDE.md/コマンドドキュメント更新済み

---

## ✅ 完了確認

### Phase 7: GitHub Issues・プロジェクト管理
- [ ] Issues Template自動生成済み
- [ ] Milestone作成済み（Phase1-6）
- [ ] Project Board作成済み（3カラム）
- [ ] Issue自動リンク完了

### Phase 8: Firebase環境構築（統合プロジェクト方式）
- [ ] `firebase-add-app.sh` で統合先プロジェクトにアプリ追加済み
- [ ] GoogleService-Info.plist 生成済み
- [ ] firebase_app_id_file.json 生成済み
- [ ] firebase_options.dart 生成済み
- [ ] `.firebaserc` 更新済み（統合先プロジェクトID）
- [ ] Firebase API有効化済み
- [ ] **`dart_env/prod.env` の `appId` 更新済み** ← 必須確認
- [ ] **`dart_env/dev.env` の `appId` 更新済み**
- [ ] `kikiki.flutter.template` が残っていないことを確認済み

### Phase 9: プロジェクト設定統合
- [ ] プロジェクト名・パッケージ名置換済み
- [ ] iOS設定更新済み
- [ ] Dartインポート一括置換済み
- [ ] README/CLAUDE.md更新済み
- [ ] .gitignore に previous_flavor.txt 追加済み
- [ ] previous_flavor.txt をGit追跡対象から除外済み
- [ ] 設定ファイル整合性確認済み
- [ ] 最終コミット・プッシュ完了

---

## 🔧 トラブルシューティング

### GitHub関連

**Q: GitHub CLI の認証に失敗する**
```bash
gh auth login --web
```

**Q: GitHub Push Protection でシークレット検出**
```bash
# Git履歴からシークレットを完全削除
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch fastlane/.env.dev fastlane/.env.prod' \
  --prune-empty --tag-name-filter cat -- --all

# シークレットを削除したファイルを再作成
# プレースホルダー値で fastlane/.env.dev と .env.prod を作成
```

### Firebase関連

**Q: Firebase CLI の認証に失敗する / 非対話型モードエラーが出る**
```bash
# Claude Code内では対話型ログインができません
# 通常のターミナルで事前にログインしてください：
firebase login

# すでにログイン済みか確認
firebase login:list

# CI環境用のトークンを使用する場合（高度な使用方法）
firebase login:ci
# 生成されたトークンを環境変数に設定
export FIREBASE_TOKEN="your-token-here"
```

**Q: Firebase プロジェクト名が重複している**
```bash
# 既存プロジェクトの確認
firebase projects:list

# 別名を試すか、既存を削除
firebase projects:delete ${PROJECT_NAME}-dev
```

**Q: Firebase プロジェクトID の制約エラー**
- **エラー例**:
  - "Project ID must be between 6 and 30 characters"
  - "Project ID can only contain lowercase letters, digits, and hyphens"
  - "Invalid project ID: underscores are not allowed"
- **対処法**: [.claude/docs/rules/naming_conventions.md](../../docs/rules/naming_conventions.md) の命名規則を参照して、プロジェクト名を修正してください
- **📖 詳細**: [命名規則ガイド - トラブルシューティング](../../docs/rules/naming_conventions.md#トラブルシューティング)

### 設定統合関連

**Q: dart_env/*.env の appId が置き換わらない**
```bash
# 現在の appId を確認
grep "appId=" dart_env/dev.env dart_env/prod.env

# 手動で置換（PROJECT_NAME を実際のプロジェクト名に置き換え）
sed -i '' "s/appId=kikiki.flutter.template.dev/appId=PROJECT_NAME.dev/g" dart_env/dev.env
sed -i '' "s/appId=kikiki.flutter.template/appId=PROJECT_NAME/g" dart_env/prod.env

# または直接編集
# dart_env/dev.env: appId=your-project-name.dev
# dart_env/prod.env: appId=your-project-name
```

**Q: パッケージ名の置換が不完全**
```bash
# Dart インポート文の再チェック（lib/ と test/ の両方）
grep -r "package:flutter_template" lib/ test/

# 残っている場合は手動置換
find lib test -name "*.dart" -type f -exec sed -i '' 's/package:flutter_template/package:your_project_name/g' {} \;

# または IDE の Find & Replace 機能を使用
# 検索: package:flutter_template
# 置換: package:your_project_name
# スコープ: Project Files
```

**Q: ドキュメント更新が反映されない**
```bash
# AI駆動更新のログ確認
# PROGRESS_LOGS を参照

# 手動で再実行
# README.md / CLAUDE.md を手動編集
```

---

## 📚 関連ドキュメント

- [.claude/docs/rules/project_rules.md](.claude/docs/rules/project_rules.md) - プロジェクト規約
- [.claude/docs/rules/git_rule.md](.claude/docs/rules/git_rule.md) - Git運用ルール
- [Makefile](../../Makefile) - 自動化コマンド定義
- [docs/project/requirements.md](../../docs/project/requirements.md) - 要件定義（Phase 4生成）

---

## 🎯 次のステップ

デプロイ完了後、次のコマンドで開発を開始：

```bash
# スクリーン構造設計
/release:step:04-screen-structure

# ブランドカラー設定
/release:step:02-brand-color-setup

# 自動実装セットアップ
/release:step:06-setup-auto-implementation
```

---

## ✅ 完了時アクション（必須）

**⚠️ 重要: このコマンド完了後、以下の更新を必ず実行すること**

### 必須アクション: RELEASE_CHECKLIST.md を Edit ツールで更新

```
ファイル: .claude/commands/release/RELEASE_CHECKLIST.md

1. チェックボックス更新:
   - [ ] **`/release:step:05-project-deploy`**
   ↓
   - [x] **`/release:step:05-project-deploy`**

2. セクションステータス更新（Auto01の最後のコマンド）:
   ### **Auto01: プロジェクト初期化** (5コマンド) 🔄 進行中
   ↓
   ### **Auto01: プロジェクト初期化** (5コマンド) ✅ 完了
```

**この更新をスキップしないこと。完了報告の前に必ず実行する。**
