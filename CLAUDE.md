# CLAUDE.md

## Project Overview

**pet_first** is a comprehensive Flutter template project designed for rapid mobile app development with enterprise-level features and Firebase integration.

### Purpose
This template provides a production-ready foundation for Flutter apps with:
- Firebase backend integration (Auth, Firestore, Analytics, etc.)
- Multi-flavor development (dev/prod environments)
- Comprehensive state management using Riverpod + Flutter Hooks
- Internationalization support (39 languages: App Store Connect全対応・完全翻訳)
- AdMob integration for monetization
- Automated build and deployment workflows

### Key Features
- **State Management**: Riverpod with Flutter Hooks for reactive programming
- **Backend**: Complete Firebase integration (Auth, Firestore, Functions, Storage, etc.)
- **Monetization**: Google AdMob and In-App Purchases integration
- **Development**: Multi-environment support with automated build processes
- **UI/UX**: Material Design with custom theming and dark mode support
- **Analytics**: Firebase Analytics and Crashlytics integration
- **CI/CD**: Fastlane integration for automated deployment

## Development Setup

### Prerequisites
- Flutter SDK (Stable channel)
- Firebase CLI
- Fastlane (for iOS deployment)
- FVM (Flutter Version Management) - recommended
- Xcode (for iOS development)

### Initial Setup

1. **Clone and setup the project:**
   ```bash
   git clone <repository-url>
   cd flutter-template
   ```

2. **Install dependencies:**
   ```bash
   make setup
   ```

3. **Configure Firebase:**
   ```bash
   # Create Firebase projects
   make create-firebase-project PROJECT_NAME=your-project-name
   
   # Generate Firebase configuration
   make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod
   ```

4. **Setup environment files:**
   ```bash
   # テンプレートから環境ファイルを作成
   cp dart_env/dev.env.template dart_env/dev.env
   cp dart_env/prod.env.template dart_env/prod.env
   cp dart_env/test.env.template dart_env/test.env
   ```

   - Edit `dart_env/dev.env` and `dart_env/prod.env` with your configuration
   - Update Firebase project IDs and app identifiers
   - **AI機能**: Firebase AI Logicを使用（Firebaseプロジェクト認証、APIキー不要）

   **セキュリティ注意**:
   - ⚠️ `dart_env/*.env` ファイルはGitに追跡されません（APIキーなど機密情報を含むため）
   - ✅ テンプレートファイル（`.env.template`）のみがGitに含まれます

## Key Commands

### Development

```bash
# Clean and setup project
make clean && make setup

# Run development environment
make run-dev

# Run production environment  
make run-prod

# Run tests with coverage
make test

# Generate code (models, routes, etc.)
make update-gen

# Check translation consistency (all languages)
make check-translations
```

### Building

```bash
# Build iOS app for development
make build-ipa FLAVOR=dev EXPORT_OPTIONS_SUFFIX=Dev

# Build iOS app for production
make build-ipa FLAVOR=prod EXPORT_OPTIONS_SUFFIX=prod BUILD_NUMBER=1
```

### Deployment

```bash
# Release iOS app to TestFlight/App Store
make release-prod-ios BUILD_NUMBER=1

# Create launcher icons
make create-launcher-icon FLAVOR=prod

# Create native splash screen
make create-native-splash
```

### Project Management

```bash
# Clone repository as new project
make clone-repo REPO_NAME=your-project-name

# Replace template content with your project details
make replace-content PROJECT_NAME=your-project-name

# Setup AdMob configuration
make setup-admob-manual
```

## Architecture

### Core Package System

This template uses **`flutter_foundation`** package to share common components, utilities, and providers across multiple projects:

**Repository**: https://github.com/crelve/flutter_foundation

**What's in Core**:
- 🧩 **Common Components**: Buttons, dialogs, forms, headers, loading states, snackbars
- 🔧 **Utilities**: Color utilities, validators, loggers, layout helpers, date formatters
- 📦 **Providers**: Auth state, app lifecycle, analytics, network, push notifications, purchases
- 🎣 **Hooks**: Network checks, push notification handling, loading state transitions
- 🤖 **AI Services**: Gemini AI integration (Firebase AI), streaming support, conversation history

**Import in your code**:
```dart
import 'package:flutter_foundation/flutter_foundation.dart';
```

This architecture allows you to:
- Share battle-tested code across multiple projects
- Update common features in one place
- Focus on app-specific features in your project
- Maintain consistency across your app portfolio

## Project Structure

```
lib/
├── component/          # App-specific UI components
│   ├── card/          # Custom cards (e.g., iOS settings tile)
│   ├── dialog/        # Custom dialogs (e.g., rating dialog)
│   └── widget/        # Custom widgets (e.g., ad banner)
├── screen/            # Application screens
│   ├── home/          # Home-related screens
│   ├── setting/       # Settings screens
│   └── walk_through/  # Onboarding screens
├── provider/          # App-specific Riverpod state providers
│   ├── ad_provider.dart
│   ├── firebase_messaging_service.dart
│   ├── rating_state_notifier.dart
│   └── walk_through_state_notifier.dart
├── hook/              # App-specific custom hooks
│   └── use_handle_transit.dart
│   # 広告トリガーは flutter_foundation の
│   # useTopScreenInterstitial / useMilestoneInterstitial / useRewardedUnlock を使用
├── utility/           # App-specific helper functions
│   ├── const/         # App constants
│   ├── product/       # Product-specific utilities
│   └── walk_through_contents.dart
├── route/             # GoRouter configuration
├── theme/             # App theming and styling
├── type/              # Type definitions and enums
├── import/            # Centralized imports
├── gen/               # Generated files (assets, colors, etc.)
├── l10n/              # Internationalization files (39 languages - App Store Connect全対応・完全翻訳)
└── model/             # App-specific data models
```

### Directory Conventions

- **component/**: App-specific UI widgets (common ones are in `flutter_foundation`)
- **screen/**: Full-screen widgets representing app pages
- **provider/**: App-specific state management (common providers in `flutter_foundation`)
- **model/**: App-specific data structures using Freezed for immutability
- **hook/**: App-specific custom hooks (common hooks in `flutter_foundation`)
- **utility/**: App-specific helper functions (common utilities in `flutter_foundation`)
- **import/**: Barrel exports for cleaner imports
- **route/**: Navigation configuration using GoRouter
- **theme/**: App-specific theming (extends core theme system)
- **l10n/**: Localization files for 39 languages (App Store Connect全対応・完全翻訳)

## Important Notes

### ⚠️ 実装前チェックリスト（必須）

**コードを書く前に、該当するルールファイルを必ず確認すること。**

| 実装内容 | 確認するルール |
|---------|--------------|
| 画面遷移 | [project_rules.md#gorouter画面遷移ルール](.claude/docs/rules/project_rules.md) |
| ボタン・ダイアログ | [project_rules.md#コンポーネント使用ルール](.claude/docs/rules/project_rules.md) |
| 色の使用 | [color_management_rule.md](.claude/docs/rules/color_management_rule.md) |
| 新規画面・UI | [apple-design skill](.claude/skills/apple-design/SKILL.md) |
| UX・心理学設計 | [ux-psychology.md](.claude/skills/apple-design/references/ux-psychology.md) |
| 課金状態に依存するUI |
| AIプロンプト・AI出力 | [project_rules.md#ai多言語化ルール必須](.claude/docs/rules/project_rules.md) | [project_rules.md#サブスクリプション状態のリアルタイム反映ルール](.claude/docs/rules/project_rules.md) |

**確認を怠った場合、ルール違反のコードが生成される可能性があります。**

### Coding Standards

Refer to [project_rules.md](.claude/docs/rules/project_rules.md) for detailed coding standards including:
- Directory and file naming conventions
- **🚫 Component usage rules (MANDATORY)**:
  - ❌ Prohibited: `ElevatedButton`, `AlertDialog`, `ScaffoldMessenger.of(context).showSnackBar`
  - ✅ Required: Components from `flutter_foundation`:
    - Buttons: `PrimaryButton`, `SecondaryButton`, `CancelButton`
    - Dialogs: `ActionDialog`, `TwoButtonDialog`
    - Snackbars: `SnackBarUtility.showSuccess()`, `SnackBarUtility.showError()`
    - Loading: `Loading()`, `ContainerWithLoading()`
    - Spacing: `hSpace()`, `wSpace()`
  - Import: `import 'package:flutter_foundation/flutter_foundation.dart';`
  - Auto-check: `make check-component-rules`
- **🎨 Color System Rules (MANDATORY)**:
  - ❌ Prohibited: `theme.appColors.background`, `theme.appColors.black`, `theme.appColors.white`, `theme.appColors.grey`
  - ✅ Required: `AppleSemanticColors` from `flutter_foundation`:
    - Background: `AppleSemanticColors.background(context)`, `AppleSemanticColors.groupedBackground(context)`
    - Labels: `AppleSemanticColors.label(context)`, `AppleSemanticColors.secondaryLabel(context)`
    - Fills: `AppleSemanticColors.fill(context)`, `AppleSemanticColors.secondaryFill(context)`, `AppleSemanticColors.tertiaryFill(context)`
    - Separator: `AppleSemanticColors.separator(context)`
  - **Benefits**: Automatic dark mode support, Apple HIG compliance
  - **Exception**: `theme.appColors.primary` (accent color) is allowed
- Color management rules (`.claude/docs/rules/color_management_rule.md`)
- Naming conventions (`.claude/docs/rules/naming_conventions.md`)
- Style guide (`.claude/docs/rules/style_guide.md`)
- **🧭 GoRouter navigation rules (MANDATORY)**:
  - `.go()`: スタック置換（ウォークスルー→ホームなど戻れない遷移）
  - `.push()`: スタック追加（詳細画面、フォーム画面など戻れる遷移）
  - **原則**: 「戻る」ボタンで前の画面に戻りたい場合は `.push()` を使用

### 🔧 Serena MCP（必須）

**コード探索・編集・品質管理は必ずSerena MCPツールを使用してください。**

**探索用ツール（コード理解時に必須）:**
1. `mcp__serena__get_symbols_overview` - ファイルの構造把握（最初に使用）
2. `mcp__serena__find_symbol` - シンボル検索（クラス・メソッド等）
3. `mcp__serena__find_referencing_symbols` - 参照箇所の検索
4. `mcp__serena__search_for_pattern` - パターン検索（柔軟な検索）
5. `mcp__serena__list_dir` - ディレクトリ構造の確認
6. `mcp__serena__find_file` - ファイルマスクで検索

**編集用ツール（コード変更時に必須）:**
1. `mcp__serena__replace_symbol_body` - シンボル単位の編集
2. `mcp__serena__insert_after_symbol` / `insert_before_symbol` - コード挿入
3. `mcp__serena__rename_symbol` - シンボル名の一括変更

**メモリツール（プロジェクト知識の永続化）:**
1. `mcp__serena__list_memories` - 利用可能なメモリ一覧
2. `mcp__serena__read_memory` - メモリの読み取り
3. `mcp__serena__write_memory` - メモリへの書き込み
4. `mcp__serena__edit_memory` - メモリの編集

**品質管理ツール（作業の振り返り）:**
1. `mcp__serena__think_about_collected_information` - 収集情報の妥当性確認
2. `mcp__serena__think_about_task_adherence` - タスク遵守の確認（編集前に必須）
3. `mcp__serena__think_about_whether_you_are_done` - 完了判定

**初期化ツール（セッション開始時）:**
1. `mcp__serena__check_onboarding_performed` - オンボーディング確認
2. `mcp__serena__onboarding` - 初回セットアップ

**使用ルール:**
- ファイル全体を読む前に `get_symbols_overview` で構造を把握
- 標準の `Read` / `Glob` ツールより先に Serena の探索ツールを使用
- コード編集は `replace_symbol_body` でシンボル単位で実施
- 標準の `Edit` ツールは Serena が使えない場合のみ使用
- 複雑な探索後は `think_about_collected_information` で情報を整理
- コード変更前は `think_about_task_adherence` でタスク確認
- タスク完了時は `think_about_whether_you_are_done` で完了判定
- プロジェクト固有の知識は `write_memory` で永続化
- `/utils:serena` コマンドで詳細なガイダンスを参照可能

### 🎨 Apple Design Skill（必須）

**新規UI実装時は必ず apple-design skill を参照してください。**

**スキルファイル**: `.claude/skills/apple-design/SKILL.md`

**必須参照タイミング**:
- 新規画面・コンポーネントの作成時
- カスタムアニメーションの実装時
- カラー・タイポグラフィの追加時
- **UX心理学に基づいた設計が必要な時**（応答性、ローディング表示、選択肢の最適化）

**クイックリファレンス**:
```dart
// Apple Design 原則
// - Clarity（明瞭性）: 読みやすく認識しやすいUI
// - Deference（控えめさ）: コンテンツが主役
// - Depth（深度）: レイヤーとブラー効果で階層表現

// デザインチェックリスト
// ✅ 8ptグリッドシステム
// ✅ ダークモード対応
// ✅ 44pt以上のタッチターゲット
// ✅ 200-500msの控えめなアニメーション

// UX心理学チェックリスト
// ✅ 400ms以内の応答時間（ドハティの閾値）
// ✅ 長時間処理には「考え中...」表示（労働の錯覚）
// ✅ 選択肢は5-7個以下（ヒックの法則）
// ✅ 完了時のお祝い演出（ピーク・エンドの法則）
```

**詳細リファレンス**:
- `.claude/skills/apple-design/references/colors.md` - カラーシステム
- `.claude/skills/apple-design/references/typography.md` - タイポグラフィ
- `.claude/skills/apple-design/references/components.md` - UIコンポーネント
- `.claude/skills/apple-design/references/animations.md` - アニメーション
- `.claude/skills/apple-design/references/spacing.md` - レイアウト・余白
- `.claude/skills/apple-design/references/ux-psychology.md` - **UX心理学**（ドハティの閾値、労働の錯覚、ヒックの法則など）

### State Management Pattern

- **Base Class**: Use `HookConsumerWidget` for components
- **Global State**: Managed with Riverpod providers
- **Local State**: Use Flutter Hooks (`useState`, `useTextEditingController`)
- **State Updates**: Use `ref.watch()` for reading, `ref.watch().notifier` for updates

### Environment Configuration

- **Development**: Uses `-dev` suffix for Firebase projects and `.dev` for app identifiers
- **Production**: Uses `-prod` suffix for Firebase projects and production app identifiers
- **Environment Files**: `dart_env/dev.env` and `dart_env/prod.env` contain environment-specific configuration

### Firebase Integration

The project includes full Firebase integration:
- **Authentication**: Firebase Auth with Google Sign-In
- **Database**: Firestore with offline persistence
- **Storage**: Firebase Storage for file uploads
- **Analytics**: Firebase Analytics and Crashlytics
- **Messaging**: Push notifications with FCM
- **Functions**: Cloud Functions for backend logic

For Firebase usage rules and mandatory services, see [project_rules.md](.claude/docs/rules/project_rules.md#firebase使用規則必須).

### Build Flavors

- **dev**: Development environment with debug features
- **prod**: Production environment optimized for release

### Localization

- Supports 39 languages (App Store Connect全対応・完全翻訳):
  - English (en), Japanese (ja), Chinese Simplified (zh), Korean (ko), German (de), French (fr), Portuguese (pt), Spanish (es), Hindi (hi), Italian (it)
  - Arabic (ar), Catalan (ca), Chinese Traditional (zh_Hant), Croatian (hr), Czech (cs), Danish (da), Dutch (nl), English variants (en_AU, en_CA, en_GB), Finnish (fi), French Canadian (fr_CA), Greek (el), Hebrew (he), Hungarian (hu), Indonesian (id), Malay (ms), Norwegian (no), Polish (pl), Portuguese Portugal (pt_PT), Romanian (ro), Russian (ru), Slovak (sk), Spanish Mexican (es_MX), Swedish (sv), Thai (th), Turkish (tr), Ukrainian (uk), Vietnamese (vi)
- Uses Flutter's internationalization framework
- Localizations in `lib/l10n/` directory (39 ARB files)
- ARB format for translation management

### Documentation

Comprehensive documentation is available in the `.claude/` directory:
- `.claude/docs/rules/`: コーディング規約・スタイルガイド
  - `project_rules.md`: 詳細なプロジェクトルール（必読）
  - `style_guide.md`: コーディングスタイル規約
  - `color_management_rule.md`: 色管理ルール
  - `naming_conventions.md`: 命名規則
- `.claude/docs/`: 開発ガイド
  - **`hybrid-requirements-guide.md`: ハイブリッド要件定義方式 完全ガイド（必読）**
    - EARS記法 + 画面ベース実装仕様の統合方式
    - Part 1-4構造による包括的要件管理
    - 機能漏れを防ぐ非画面機能の明示
- `.claude/commands/`: 87個のカスタムコマンド
  - `release/`: 21個のリリース自動化コマンド
  - `flutter/`: Flutter開発専用コマンド
  - `git/`: Git/GitHub統合コマンド
  - `utils/`: ユーティリティコマンド
- `.claude/agents/roles/`: 10個のAIエージェント役割
- `docs/project/`: プロジェクト固有のドキュメント
  - `history.json`: プロジェクト履歴・重複チェック結果 (自動生成)
  - **`requirements.md`: ハイブリッド要件定義書 (コマンドで生成)**
    - Part 1: ビジネス要件・非機能要件
    - Part 2: 機能要件 (EARS記法)
    - Part 3: 画面別実装仕様
    - Part 4: 共通機能・非画面機能
  - `design.md`: アーキテクチャ設計 (コマンドで生成)
  - `tasks.md`: 実装タスク (コマンドで生成)

### Release Process

Follow the complete release workflow with 87 Claude Code commands:

**🚀 完全自動化リリースフロー (3-4時間)**
1. **プロジェクト初期化** - 8-25分
   - `/01-guided-init`: 対話型（15-25分）- アイデアがある時
   - `/01-project-init`: 自動（8-12分）- ゼロから探索
   - 市場分析・競合調査・要件定義・設計ドキュメント生成
2. **環境構築** (`/05-project-deploy`) - 7-10分
   - GitHubリポジトリ作成
   - Firebase プロジェクト構築
3. **機能実装** (AI自動実装システム)
4. **リリース準備・本番デプロイ** (`/15-release-ios`) - 15-20分

**📋 手動実行コマンド (必要時のみ)**
- `/00-release-checklist` - 最終品質確認
- iOS証明書設定・スクリーンショット作成等

**重要**: 全プロセスで `docs/project/history.json` にプロジェクト履歴が自動記録され、重複防止システムが動作します。

詳細は [.claude/commands/release/README.md](.claude/commands/release/README.md) をご覧ください。

### Claude Code Cookbook の活用

```bash
# Claude Code Cookbook インストール
./.claude/scripts/install.sh --to-global

# 🚀 完全自動化リリースフロー
/01-guided-init           # 対話型：アイデアがある時
/01-project-init          # 自動：ゼロから探索
/05-project-deploy        # 環境構築・Firebase設定
/15-release-ios           # iOS App Store リリース

# 📋 開発支援コマンド (50+)
/flutter-analyze          # コード品質解析
/build-check             # ビルド検証
/test-coverage           # テスト網羅率分析
/fix-error               # エラー自動修正

# 🤖 AIエージェント役割
/role security           # セキュリティ専門家
/role flutter            # Flutter専門家
/role performance        # パフォーマンス専門家

# 📊 要件整合性チェック
/09-requirements-check   # 要件との整合性確認
```


詳細は [.claude/README.md](.claude/README.md) をご覧ください。

## Development Workflow

For detailed development workflow including:
- Branch strategy
- Code quality checks (必須: `make check-ready`)
- Code review process
- CI/CD pipeline
- Git hook error handling

Refer to [project_rules.md](.claude/docs/rules/project_rules.md#開発ワークフロー).

## Important Concepts

**Note**: Most core providers and utilities are provided by `flutter_foundation`. Import with:
```dart
import 'package:flutter_foundation/flutter_foundation.dart';
```

### 1. App Lifecycle (from Core)
- `AppLifecycleStateProvider`: アプリのライフサイクル状態の管理
- `MediaQueryStateNotifier`: 画面サイズと向きの管理

### 2. Authentication System (from Core)
- Firebase Authentication を使用
- Google Sign-In によるソーシャルログイン対応
- `AuthStateNotifier`: 認証状態の管理

### 3. Push Notifications (from Core + App-specific)
- `PushNotificationStateNotifier`: 通知設定の状態管理 (Core)
- `handleCloudMessage`: 受信メッセージの処理 (Core)
- `firebase_messaging_service.dart`: アプリ固有のメッセージング実装

### 4. Analytics Integration (from Core)
- `FirebaseAnalyticsProvider`: ユーザーインタラクションのログ記録
- `AppTrackingTransparency`: iOS のトラッキング許可管理

### 5. In-App Purchases (from Core)
- RevenueCat を使用したサブスクリプション管理
- `PurchaseStateNotifier`: 課金状態の管理

**⚠️ サブスクリプション状態のリアルタイム反映（必須）:**

サブスクリプション購入後、UIが即座に更新されるよう実装すること。

```dart
// ✅ 正しい実装 - ref.watchで状態を監視
class PremiumFeature extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watchで監視 → 購入後に自動的に再ビルド
    final purchaseState = ref.watch(purchaseStateNotifierProvider);
    final isPremium = purchaseState.valueOrNull?.isPremium ?? false;

    if (isPremium) {
      return const PremiumContent();
    }
    return const UpgradePrompt();
  }
}

// ❌ 間違った実装 - ref.readは状態変更を監視しない
final purchaseState = ref.read(purchaseStateNotifierProvider); // NG!
```

**影響を受けるUI要素:**
| UI要素 | 期待される動作 |
|--------|--------------|
| 広告バナー | 購入後、即座に非表示 |
| 機能制限バッジ | 購入後、即座に非表示 |
| アップグレードボタン | 購入後、即座に非表示/変更 |
| プラン表示 | 購入後、即座に更新 |

詳細は [project_rules.md](.claude/docs/rules/project_rules.md#-サブスクリプション状態のリアルタイム反映ルール必須) を参照。

### 6. AI Integration (from Core)

**Firebase AI経由でGemini APIを統合:**

```dart
import 'package:flutter_foundation/flutter_foundation.dart';

// GeminiServiceの初期化
final geminiService = GeminiService();

// テキスト送信（一括応答）
final response = await geminiService.sendMessage(
  message: 'こんにちは、Geminiさん',
);

// ストリーミング応答（リアルタイム）
await for (final chunk in geminiService.streamMessage(
  message: 'ストーリーを書いてください',
)) {
  print(chunk); // チャンク毎に表示
}

// 会話履歴の管理
final history = [
  {'role': 'user', 'content': '前回の質問'},
  {'role': 'assistant', 'content': '前回の回答'},
];
final response2 = await geminiService.sendMessage(
  message: '続きを教えて',
  conversationHistory: history,
);

// 履歴クリア
geminiService.clearHistory();
```

**AI実装の優先順位:**
1. **第一選択**: `AiServiceWrapper`を使用（タイムアウト・エラーハンドリング付き、推奨）
2. **第二選択**: `GeminiService`を直接import（シンプルな用途のみ）
3. **第三選択**: `flutter_foundation`を改修して機能追加
4. **第四選択**: プロジェクト内で`AiServiceBase`を継承して独自実装

**利用可能なAI基盤:**
- `GeminiService`: Firebase AI + Gemini 2.5 Flash
- `AiServiceBase`: 抽象基底クラス（OpenAI、Claude等の追加実装可能）
- 会話履歴管理
- ストリーミング対応

**⚠️ タイムアウト・エラーハンドリング（必須）:**

AI実行は必ず`AiServiceWrapper`を使用してください（30秒タイムアウト付き）:

```dart
import 'package:pet_first/service/ai/ai_service_wrapper.dart';
import 'package:pet_first/service/ai/ai_exception.dart';

// AiServiceWrapperを使用（30秒タイムアウト付き）
final aiService = AiServiceWrapper();

try {
  final response = await aiService.sendMessage(message: 'こんにちは');
} on AiTimeoutException catch (e) {
  // タイムアウト（30秒超過）
  showError('処理がタイムアウトしました。再度お試しください。');
} on AiNetworkException catch (e) {
  // ネットワークエラー
  showError('ネットワーク接続を確認してください。');
} on AiConfigurationException catch (e) {
  // API設定エラー
  showError('AIサービスが正しく設定されていません。');
} on AiRateLimitException catch (e) {
  // レート制限
  showError('リクエスト制限に達しました。しばらくお待ちください。');
} on AiException catch (e) {
  // その他のAIエラー
  showError('エラーが発生しました: ${e.message}');
}
```

**エラーハンドリングルール:**
1. **必須**: AI呼び出しは必ず`try-catch`で囲む
2. **必須**: `AiServiceWrapper`を使用（直接`GeminiService`を使わない）
3. **推奨**: エラータイプに応じたユーザーフレンドリーなメッセージを表示
4. **推奨**: ストリーミングには`streamMessageWithInitialTimeout`を使用

**例外クラス一覧:**
| 例外クラス | 説明 | 対処例 |
|-----------|------|-------|
| `AiTimeoutException` | 30秒タイムアウト | 再試行を促す |
| `AiNetworkException` | ネットワークエラー | 接続確認を促す |
| `AiConfigurationException` | API設定エラー | 開発者に報告 |
| `AiRateLimitException` | レート制限 | 待機を促す |
| `AiUnknownException` | 不明なエラー | 一般的なエラーメッセージ |

### 7. App-Specific Providers
This template includes the following app-specific providers:
- `ad_provider.dart`: AdMob広告の管理（バナー、インタースティシャル、リワードインタースティシャル）
- `rating_state_notifier.dart`: アプリ評価ダイアログの状態管理
- `walk_through_state_notifier.dart`: オンボーディング画面の状態管理

**レビューダイアログの実装:**
このテンプレートでは、レビューダイアログの呼び出しを意図的に含めていません。アプリ固有の最適なタイミングで表示するため、実装時に `.claude/docs/best-practices/rating-dialog-timing.md` を参照してください。推奨タイミングは、タスク完了直後、目標達成時、ポジティブな体験の後です。

### 8. 広告システム (AdMob Integration)

**対応広告タイプ:**
- バナー広告 (`AdBanner`)
- インタースティシャル広告
- リワード広告 / リワードインタースティシャル広告
- アプリ起動広告 (App Open Ad)

**⚠️ 広告トリガーは `flutter_foundation` 標準ヘルパー必須（再発防止B / 2026-04）**

`useAdInitialization` + 手書き `useEffect` で広告を出す旧実装は **禁止**。以下3ヘルパーを使う:

| 用途 | ヘルパー | 使用場所 |
|------|---------|---------|
| 起動時Interstitial | `useTopScreenInterstitial` | トップ画面の `build` 内1行 |
| N回ごとInterstitial | `useMilestoneInterstitial` | 保存/完了系アクションの画面 |
| Rewarded視聴で機能解放 | `useRewardedUnlock` | プレミアム機能ゲート |

```dart
import 'package:flutter_foundation/flutter_foundation.dart';

// 1. トップ画面の起動時Interstitial（最低ライン）
class TopScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useTopScreenInterstitial(context: context, ref: ref);
    return Scaffold(/* ... */);
  }
}

// 2. マイルストーン（例: 3回保存ごとに1回表示）
final milestone = useMilestoneInterstitial(
  ref: ref, counterKey: 'save_count', everyN: 3,
);
onPressed: () async {
  await save();
  await milestone.increment();
}

// 3. Rewardedで24時間プレミアムテーマ解放
final unlock = useRewardedUnlock(ref: ref);
if (!unlock.isUnlocked('premium_theme')) {
  final ok = await unlock.unlock(featureKey: 'premium_theme');
  if (!ok) showError();
}
```

`AdConfig` の `minIntervalSeconds` / `dailyMaxInterstitialCount` / `sessionMaxInterstitialCount`
/ `appLaunchCooldownHours` はヘルパー内で自動適用されるため、画面側で重複チェックを書かないこと。
App Open広告とのバッティングも `respectAppOpenAd: true` で自動回避される。

**低レベルAPI（どうしても直接触る必要がある場合のみ）:**
```dart
final adNotifier = ref.read(adStateNotifierProvider.notifier);
if (adNotifier.canShowInterstitialAd()) {
  adNotifier.showInterstitialAd();
}
```

**デフォルトの制限設定:**
| 設定項目 | デフォルト値 | 環境変数 |
|---------|------------|---------|
| 最小表示間隔 | 60秒 | `adMinIntervalSeconds` |
| 1日の最大表示回数（インタースティシャル） | 10回 | `adDailyMaxInterstitialCount` |
| 1日の最大表示回数（リワード） | 20回 | `adDailyMaxRewardedCount` |
| セッションの最大表示回数 | 5回 | `adSessionMaxInterstitialCount` |

**環境変数の設定（dart_env/prod.env）:**
```
iOSBannerAdUnitId=ca-app-pub-xxx/xxx
iOSInterstitialAdUnitId=ca-app-pub-xxx/xxx
iOSRewardedInterstitialAdUnitId=ca-app-pub-xxx/xxx
```

For detailed rules on error handling, testing, performance optimization, security, and accessibility, see [project_rules.md](.claude/docs/rules/project_rules.md).

## Customization Guide

For detailed customization instructions including:
- Project name changes
- Feature additions/removals
- Theme customization

Refer to [project_rules.md](.claude/docs/rules/project_rules.md#カスタマイズガイド).

---

This template is designed to accelerate development while maintaining high code quality and production readiness through:

- **87個のClaude Code専用コマンド** - 完全自動化リリースフロー
- **AI駆動開発** - 企画からApp Store配信まで3-4時間
- **品質保証システム** - 10役割のAIエージェント + 自動テスト
- **重複防止機能** - プロジェクト履歴管理による類似アプリ回避
- **要件駆動開発** - 構造化された要件定義ベースの実装
