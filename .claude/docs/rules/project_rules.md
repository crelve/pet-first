# プロジェクトルール

## プロジェクト概要

本リポジトリは、Flutter を使用したモバイルアプリケーションのテンプレートです。
iOS プラットフォームに対応したモバイルアプリ開発の基盤として使用できます。

## 開発者情報（固定）

法的文書やApp Store申請で使用する開発者情報です。

| 項目 | 値 |
|------|-----|
| 事業形態 | 個人事業（Sole Proprietor） |
| 屋号（英語） | crelve |
| 屋号（日本語） | crelve |
| 連絡先メールアドレス | w4cd2017@gmail.com |

> **注意**: 法的文書では「運営者: crelve」として表記してください。

## 技術スタック

### フレームワーク・ライブラリ

- **Flutter**: stable バージョン
- **状態管理**: Riverpod（hooks_riverpod）と Flutter Hooks（flutter_hooks）の組み合わせ
- **ルーティング**: GoRouter
- **国際化**: flutter_localizations
- **データ永続化**: SharedPreferences
- **バックエンド**: Firebase（Firestore, Authentication, Analytics, Crashlytics 等）
- **広告**: Google Mobile Ads
- **課金**: RevenueCat（purchases_flutter）
- **通知**: Firebase Cloud Messaging

### 🧭 GoRouter画面遷移ルール（必須）

GoRouterを使用した画面遷移では、以下のルールに従ってください。

#### メソッドの使い分け

| メソッド | 用途 | スタック動作 |
|---------|------|-------------|
| `.go()` | スタック置換（戻れない遷移） | 現在のスタックを完全に置き換え |
| `.push()` | スタック追加（戻れる遷移） | 現在のスタックに追加 |
| `.pop()` | 前画面に戻る | スタックから削除 |

#### 使用例

```dart
// ✅ 正しい使用法

// スタック置換（ウォークスルー完了後、ログアウト後など）
const BaseScreenRoute().go(context);

// スタック追加（詳細画面、フォーム画面など）
PetDetailScreenRoute(petId: petId).push<void>(context);

// 戻り値を受け取る場合
final result = await PetFormScreenRoute(petId: petId).push<bool>(context);
if (result == true) {
  // リフレッシュ処理
}

// 前画面に戻る
Navigator.of(context).pop();
context.pop();
```

```dart
// ❌ 間違った使用法

// 詳細画面への遷移で .go() を使うと、戻るボタンでエラーになる
PetDetailScreenRoute(petId: petId).go(context);  // NG

// フォーム画面で .go() を使うと、pop時にスタックが空になる
const PetFormScreenRoute().go(context);  // NG
```

#### 判断基準

**`.go()` を使うケース:**
- ウォークスルー完了 → ホーム画面
- ログアウト → ログイン画面
- 初期化完了 → メイン画面

**`.push()` を使うケース:**
- ホーム → 詳細画面
- 一覧 → フォーム画面
- 設定 → サブ設定画面
- **原則**: 「戻る」ボタンで前の画面に戻りたい場合

#### リフレッシュパターン

フォーム画面から戻った後にデータを更新する場合：

```dart
Future<void> _navigateToForm(BuildContext context, WidgetRef ref) async {
  final result = await const FormScreenRoute().push<bool>(context);
  if (result == true) {
    // 方法1: refresh()を呼ぶ
    await ref.read(stateNotifierProvider.notifier).refresh();

    // 方法2: providerをinvalidateする
    ref.invalidate(stateNotifierProvider);
  }
}
```

### 🔥 Firebase使用規則（必須）

#### Firebase必須サービス
**全てのアプリで以下のFirebaseサービスを使用する必要があります：**

1. **Firebase Cloud Messaging (FCM)**
   - プッシュ通知機能の実装に必須
   - ユーザーエンゲージメント向上のため
   - アプリの重要な機能として位置づけ

2. **Firebase Hosting**
   - Web版アプリのホスティングに必須
   - 静的サイトの配信に使用
   - CDN機能による高速配信

3. **Firebase Analytics**
   - ユーザー行動分析に必須
   - アプリの改善・最適化に必要

4. **Firebase Crashlytics**
   - クラッシュレポート収集に必須
   - アプリの安定性向上に必要

#### Firebase設定必須項目
```dart
// ✅ 必須 - main.dartでのFirebase初期化
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// ✅ 必須 - FCM初期化
await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
);

// ✅ 必須 - Analytics初期化
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

#### Firebase設定ファイル必須
- `ios/Runner/GoogleService-Info.plist` - iOS用設定ファイル
- `lib/firebase_options.dart` - Flutter用設定ファイル

#### Firebase使用時の必須チェックリスト
- [ ] Firebase プロジェクトが作成されている
- [ ] 必要なサービス（FCM, Hosting, Analytics, Crashlytics）が有効化されている
- [ ] 設定ファイルが正しく配置されている
- [ ] プッシュ通知の権限設定が完了している
- [ ] 環境変数でFirebase設定が管理されている


### 🌍 AI多言語化ルール（必須）

AIが生成するテキスト（絵本・メッセージ・説明文など）は、**特定言語に固定してはならない**。
必ずユーザーの現在のロケールに合わせた言語で出力されるようにすること。

#### 必須実装パターン

```dart
// ✅ 正しい実装 - ロケールをプロンプトに含める
Future<void> generateContent({
  required String locale,       // Localizations.localeOf(context).toString()
}) async {
  final language = _localeToLanguageName(locale); // "ja" → "Japanese" など
  final prompt = """
  ...
  IMPORTANT: Write the response in $language only.
  """;
}

// ❌ 禁止 - 言語を固定したプロンプト
return '日本語で答えてください。';
return 'Answer in English.'; // 出力言語をハードコード
// ❌ 禁止 - 出力言語の指定なし
return 'Analyze this data and provide insights.';
```

#### ロケール取得方法

```dart
// BuildContextがある場所（画面・ウィジェット）
final locale = Localizations.localeOf(context).toString(); // 例: "ja", "en_US"

// プロバイダ・サービスに渡す
await aiProvider.generate(locale: locale);
```

#### ロケール→言語名変換（AIプロンプト用）

プロバイダに `_localeToLanguageName(String locale)` メソッドを実装し、
ロケールコードを自然言語名（"Japanese", "English" 等）に変換してプロンプトに渡す。

```dart
String _localeToLanguageName(String locale) {
  final code = locale.split('_').first.toLowerCase();
  const map = {
    'ja': 'Japanese', 'en': 'English', 'zh': 'Chinese',
    'ko': 'Korean', 'de': 'German', 'fr': 'French',
    'es': 'Spanish', 'pt': 'Portuguese', 'it': 'Italian',
    'ru': 'Russian', 'ar': 'Arabic', 'hi': 'Hindi',
    'tr': 'Turkish', 'pl': 'Polish', 'nl': 'Dutch',
    'sv': 'Swedish', 'da': 'Danish', 'fi': 'Finnish',
    'no': 'Norwegian', 'cs': 'Czech', 'sk': 'Slovak',
    'hu': 'Hungarian', 'ro': 'Romanian', 'hr': 'Croatian',
    'el': 'Greek', 'he': 'Hebrew', 'th': 'Thai',
    'vi': 'Vietnamese', 'id': 'Indonesian', 'ms': 'Malay',
    'uk': 'Ukrainian', 'ca': 'Catalan',
  };
  return map[code] ?? 'English';
}
```

#### チェックリスト

- [ ] AIプロンプトに `Write in {language} only.` または同等の言語指定が含まれている
- [ ] プロンプト内の動的テキストがl10n経由または原文ままで渡されている
- [ ] プロンプト自体に特定言語のハードコードがない（日本語・英語固定禁止）
- [ ] AI呼び出し元からロケールを渡している

### 開発ツール

- **コード生成**: build_runner, freezed, json_serializable
- **リント**: flutter_lints, pedantic_mono
- **アイコン生成**: flutter_launcher_icons
- **スプラッシュ画面**: flutter_native_splash

## ディレクトリルール

### フォルダ名の命名規則

- フォルダ名は単数形にしてください。

```sh
// 👎 NG
dart_defines
lib/types

// 👍 OK
dart_define
lib/type
```

### ファイル名の命名規則

- ファイル名に provider は付けないでください。

```sh
// 👎 NG
layer_1_web_view_contents_provider.dart

// 👍 OK
layer_1_web_view_contents.dart
```

- ファイル名に StateNotifier は付けてください。

```sh
// 👎 NG
layer_1_web_view.dart

// 👍 OK
layer_1_web_view_state_notifier.dart
```

### フォルダ分割のガイドライン

- 1 フォルダに目安として１０ファイル以上存在する場合は、フォルダで分割することを検討してください。

### 省略形の使用

- フォルダ名に省略形は使用して構いません。ただし、一般的に使用されている省略形のみ許容します。

**許容される省略形の例**:

- `lib/` (library)
- `src/` (source)
- `util/` (utility)
- `comp/` (component)
- `prov/` (provider)
- `model/` (model)
- `type/` (type)
- `const/` (constant)
- `ext/` (extension)
- `hook/` (hook)
- `route/` (route)
- `theme/` (theme)
- `l10n/` (localization)
- `gen/` (generated)
- `import/` (import)

## コード構造

### ディレクトリ構造

```
lib/
├── app.dart                  # メインAppウィジェット
├── main.dart                 # エントリーポイント
├── app_state_notifier.dart   # アプリ状態管理
├── screen/                   # UI画面
│   ├── base_screen.dart      # ベース画面
│   ├── home/                 # ホーム関連画面
│   ├── setting/              # 設定関連画面
│   └── walk_through/         # オンボーディング画面
├── provider/                 # Riverpodステートプロバイダー
│   ├── ad_provider.dart      # 広告関連
│   ├── app_lifecycle_state_notifier.dart # アプリライフサイクル
│   ├── cloud_messaging_provider.dart # プッシュ通知
│   ├── firebase_analytics_provider.dart # 分析
│   ├── go_router_provider.dart # ルーティング
│   ├── loading_state_notifier.dart # ローディング状態
│   ├── locale_provider.dart  # 言語設定
│   ├── purchase_state_notifier.dart # 課金
│   ├── push_notification_state_notifier.dart # 通知設定
│   ├── rating_state_notifier.dart # 評価
│   ├── shared_preferences_provider.dart # データ永続化
│   └── walk_through_state_notifier.dart # オンボーディング
├── model/                    # データモデル
│   ├── app_error.dart        # エラーモデル
│   ├── app_info.dart         # アプリ情報
│   ├── push_notification_setting.dart # 通知設定
│   ├── result.dart           # 結果型
│   └── token.dart            # トークン
├── utility/                  # ユーティリティ関数
│   ├── const/                # 定数定義
│   ├── extension/            # 拡張メソッド
│   ├── logger/               # ログ機能
│   ├── product/              # プロダクト関連
│   ├── validator/            # バリデーション
│   ├── app_tracking_transparency.dart # トラッキング
│   ├── color_utility.dart    # 色ユーティリティ
│   ├── date.dart             # 日付処理
│   ├── file_converter.dart   # ファイル変換
│   ├── format_log_parameters.dart # ログパラメータ
│   ├── handle_cloud_message.dart # クラウドメッセージ
│   ├── is_not_production.dart # 環境判定
│   ├── layout.dart           # レイアウト
│   ├── media_query.dart      # メディアクエリ
│   ├── open_review.dart      # レビュー
│   ├── open_url.dart         # URL起動
│   ├── platform.dart         # プラットフォーム
│   ├── show_local_push_notification.dart # ローカル通知
│   ├── slack.dart            # Slack連携
│   ├── space.dart            # スペース
│   ├── update_checker.dart   # アップデートチェック
│   └── walk_through_contents.dart # オンボーディング内容
├── component/                # 再利用可能なUIコンポーネント
│   ├── button/               # ボタンコンポーネント
│   ├── card/                 # カードコンポーネント
│   ├── dialog/               # ダイアログコンポーネント
│   ├── dropdown/             # ドロップダウンコンポーネント
│   ├── form/                 # フォームコンポーネント
│   ├── header/               # ヘッダーコンポーネント
│   ├── layout/               # レイアウトコンポーネント
│   ├── loading/              # ローディングコンポーネント
│   ├── snackbar/             # スナックバーコンポーネント
│   ├── switch/               # スイッチコンポーネント
│   ├── text/                 # テキストコンポーネント
│   └── widget/               # その他ウィジェット
├── theme/                    # アプリテーマ
│   ├── app_colors.dart       # カラー定義
│   ├── app_text_theme.dart   # テキストテーマ
│   ├── app_theme.dart        # アプリテーマ
│   ├── button_styles.dart    # ボタンスタイル
│   └── font_size.dart        # フォントサイズ
├── type/                     # 型定義
│   ├── log/                  # ログ関連型
│   ├── ad_state.dart         # 広告状態
│   ├── base_state.dart       # 基本状態
│   ├── purchase_state.dart   # 課金状態
│   ├── push_notification_state.dart # 通知状態
│   └── walk_through_state.dart # オンボーディング状態
├── hook/                     # カスタムフック
│   ├── use_ad_initialization.dart # 広告初期化
│   ├── use_handle_page_controller.dart # ページコントローラー
│   ├── use_handle_transit.dart # 画面遷移
│   ├── use_loading_state_transition.dart # ローディング状態遷移
│   ├── use_network_check.dart # ネットワークチェック
│   ├── use_push_notification_setting.dart # 通知設定
│   └── use_push_notification_token.dart # 通知トークン
├── route/                    # ルーティング定義
│   └── route.dart            # ルート定義
├── l10n/                     # 国際化（39言語・市場規模順）
│   ├── app_en.arb            # 1. 英語（最大市場）
│   ├── app_ja.arb            # 2. 日本語（高ARPU）
│   ├── app_zh.arb            # 3. 中国語（ユーザー数多）
│   ├── app_ko.arb            # 4. 韓国語（課金率高）
│   ├── app_de.arb            # 5. ドイツ語（EU最大iOS）
│   ├── app_fr.arb            # 6. フランス語（EU第2位）
│   ├── app_pt.arb            # 7. ポルトガル語（LATAM最大）
│   ├── app_es.arb            # 8. スペイン語（広言語圏）
│   ├── app_hi.arb            # 9. ヒンディー語（成長市場）
│   └── app_it.arb            # 10. イタリア語（EU中堅）
├── gen/                      # 生成されたコード
├── import/                   # バレルファイル（インポート用）
│   ├── component.dart        # コンポーネント
│   ├── domain.dart           # ドメイン
│   ├── gen.dart              # 生成コード
│   ├── hook.dart             # フック
│   ├── model.dart            # モデル
│   ├── provider.dart         # プロバイダー
│   ├── root.dart             # ルート
│   ├── route.dart            # ルート
│   ├── screen.dart           # 画面
│   ├── theme.dart            # テーマ
│   ├── type.dart             # 型
│   ├── utility.dart          # ユーティリティ
    ├── components.dart       # コンポーネント
    └── main.dart             # メイン
```

## コーディング規約

### 一般的なルール

1. **インポート順序**:

   - Dart の標準ライブラリ
   - サードパーティライブラリ
   - プロジェクト内の相対インポート（import/ディレクトリ経由）

2. **命名規則**:

   - クラス名: `PascalCase`（例: CustomButton, UserProfile）
   - 変数・メソッド名: `camelCase`（例: userName, fetchData）
   - ファイル名: `snake_case`（例: custom_button.dart）
   - ディレクトリ名: `snake_case`（例: component, screen, setting）
   - プライベートメンバー: `_`プレフィックス

3. **コメント**:

   - クラスドキュメント: 各クラスの直前に `/// クラスの説明` 形式
   - コンストラクタドキュメント: コンストラクタの直前に同様のドキュメントコメント
   - プロパティドキュメント: 各プロパティの直前に説明コメント
   - メソッドドキュメント: 必要に応じてメソッドの直前に説明コメント
   - コード内コメント: 複雑なロジックには `// コメント` 形式

4. **ファイル構造**:
   - 1 ファイルにつき 1 つの主要クラス
   - 関連する小さなクラスや enum は同じファイルに配置可能

### Flutter に関するルール

1. **ウィジェット構造**:

   - 複雑なウィジェットは小さなウィジェットに分割
   - StatelessWidget を優先し、必要な場合のみ StatefulWidget を使用
   - HookConsumerWidget を基底クラスとして使用
   - Riverpod を使用した状態管理を推奨

2. **レイアウト**:

   - ハードコードされた数値の代わりに`utility/space.dart`の定数を使用
   - レスポンシブデザインには`utility/media_query.dart`を使用

3. **コンポーネント命名パターン**:
   - 画面: 〇〇 Screen（例: HomeScreen, SettingsScreen）
   - コンポーネント: 機能を表す名前（例: CustomButton, LoadingDialog）

### 🚫 コンポーネント使用禁止ルール（必須）

**以下のFlutterウィジェットの直接使用を禁止します。必ず専用コンポーネントを使用してください。**

#### 1. ボタンの禁止ルール

**禁止されるウィジェット:**
- ❌ `ElevatedButton`
- ❌ `TextButton`
- ❌ `IconButton`
- ❌ `FloatingActionButton`
- ❌ `InkWell`（ボタン用途）

**使用すべきコンポーネント:**
```dart
// ✅ 正しい使用方法
import '../../import/component.dart';

// プライマリーボタン（強調度：高）
PrimaryButton(
  text: 'ボタンテキスト',
  screen: 'HomeScreen',
  width: 200,
  isDisabled: false,
  callback: () { /* 処理 */ },
)

// セカンダリーボタン（強調度：中）
SecondaryButton(
  text: 'ボタンテキスト',
  screen: 'HomeScreen',
  width: 200,
  isDisabled: false,
  callback: () { /* 処理 */ },
)

// キャンセルボタン（強調度：低）
CancelButton(
  text: 'キャンセル',
  screen: 'HomeScreen',
  width: 200,
  callback: () { /* 処理 */ },
)

// ダイアログ用プライマリーボタン
DialogPrimaryButton(
  text: 'OK',
  screen: 'HomeScreen',
  width: 150,
  callback: () { /* 処理 */ },
)

// ダイアログ用セカンダリーボタン
DialogSecondaryButton(
  text: 'キャンセル',
  screen: 'HomeScreen',
  width: 150,
  callback: () { /* 処理 */ },
)
```

**理由:**
- Firebase Analyticsの自動計測（tapButtonログ）
- デザインの一貫性確保
- スタイルの統一管理
- アクセシビリティの統一

#### 2. ダイアログの禁止ルール

**禁止されるウィジェット:**
- ❌ `AlertDialog`
- ❌ `SimpleDialog`
- ❌ `Dialog`
- ❌ `showDialog`（直接使用）

**使用すべきコンポーネント:**
```dart
// ✅ 正しい使用方法
import '../../import/component.dart';

// 1ボタンダイアログ
showDialog(
  context: context,
  builder: (_) => ActionDialog(
    title: 'タイトル',
    screen: 'HomeScreen',
    content: '内容',
    buttonLabel: 'OK',
    callBack: () {
      Navigator.of(context).pop();
    },
  ),
);

// 2ボタンダイアログ
showDialog(
  context: context,
  builder: (_) => TwoButtonDialog(
    title: 'タイトル',
    screen: 'HomeScreen',
    content: '内容',
    primaryButtonLabel: 'OK',
    secondaryButtonLabel: 'キャンセル',
    primaryCallBack: () {
      Navigator.of(context).pop();
      // 処理
    },
    secondaryCallBack: () {
      Navigator.of(context).pop();
    },
  ),
);

// レーティングダイアログ
showDialog(
  context: context,
  builder: (_) => const RatingDialog(screen: 'HomeScreen'),
);

// カレンダーダイアログ
showDialog(
  context: context,
  builder: (_) => CalendarDialog(
    screen: 'HomeScreen',
    initialDate: DateTime.now(),
    onDateSelected: (date) {
      // 日付選択処理
    },
  ),
);
```

**理由:**
- UIデザインの統一
- ボタンスタイルの一貫性
- 再利用性の向上
- メンテナンス性の向上

#### 3. スナックバーの禁止ルール

**禁止される使用方法:**
- ❌ `ScaffoldMessenger.of(context).showSnackBar()`（直接使用）
- ❌ `SnackBar`（直接使用）

**使用すべきコンポーネント:**
```dart
// ✅ 正しい使用方法
import '../../import/component.dart';

// 成功メッセージ
SnackBarUtility.showSuccess(
  context: context,
  theme: theme,
  message: '保存しました',
);

// エラーメッセージ
SnackBarUtility.showError(
  context: context,
  theme: theme,
  message: 'エラーが発生しました',
);

// 情報メッセージ
SnackBarUtility.showInfo(
  context: context,
  theme: theme,
  message: 'お知らせです',
);

// 警告メッセージ
SnackBarUtility.showWarning(
  context: context,
  theme: theme,
  message: '注意が必要です',
);

// 報酬メッセージ
SnackBarUtility.showReward(
  context: context,
  theme: theme,
  message: 'ポイントを獲得しました',
);
```

**理由:**
- メッセージタイプの統一（成功・エラー・情報・警告・報酬）
- アイコンとカラーの自動設定
- デザインの一貫性
- context.mountedチェックの自動化

#### 4. ヘッダーの禁止ルール

**禁止されるウィジェット:**
- ❌ `AppBar`（直接使用）
- ❌ `SliverAppBar`

**使用すべきコンポーネント:**
```dart
// ✅ 正しい使用方法
import '../../import/component.dart';

// 基本ヘッダー（appBarとして使用）
Scaffold(
  appBar: BaseHeader(title: l10n.screenTitle),
  body: /* コンテンツ */,
)

// 基本ヘッダー（body内で使用）
Scaffold(
  body: Column(
    children: [
      BaseHeader(title: l10n.screenTitle),
      Expanded(child: /* メインコンテンツ */),
    ],
  ),
)
```

**理由:**
- デザインの一貫性確保
- テーマカラーの統一管理
- テキストスタイルの統一
- 多言語対応の強制

#### 5. Loading()ウィジェットの使用ルール

**注意: `Loading()`は全画面表示専用**

`flutter_foundation`の`Loading()`ウィジェットは**全画面オーバーレイ用**に設計されています。
内部で`getScreenSize(context)`を使用して画面全体を覆うため、制限されたコンテナ内では使用できません。

**❌ 禁止される使用方法:**
```dart
// コンテナ内でのLoading()使用は禁止
Container(
  width: 120,
  height: 120,
  child: Loading(), // ❌ UIが崩れる
)

SizedBox(
  width: 24,
  height: 24,
  child: Loading(), // ❌ UIが崩れる
)

Padding(
  padding: EdgeInsets.all(32),
  child: Loading(), // ❌ UIが崩れる
)
```

**✅ 正しい使用方法:**
```dart
// 1. 全画面オーバーレイとして使用（Loading()の本来の用途）
Stack(
  children: [
    MainContent(),
    if (isLoading) Loading(), // ✅ 全画面オーバーレイ
  ],
)

// 2. 部分的なローディングにはCircularProgressIndicatorを使用
Container(
  width: 120,
  height: 120,
  child: Center(
    child: SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator( // ✅ 適切なサイズ指定
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation<Color>(theme.appColors.primary),
      ),
    ),
  ),
)

// 3. ボタン内のローディング
SizedBox(
  width: 24,
  height: 24,
  child: CircularProgressIndicator( // ✅ 小さいサイズ
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(ColorName.white),
  ),
)
```

**理由:**
- `Loading()`は`getScreenSize(context)`で画面サイズを取得し全体を覆う設計
- 制限されたコンテナ内ではサイズ計算が不正になりUIが崩れる
- 部分的なローディングには`CircularProgressIndicator`を直接使用する

#### 違反チェック方法

以下のコマンドで違反を自動検出できます：

```bash
# コンポーネント使用ルール違反チェック
make check-component-rules

# 全品質チェック（フォーマット・解析・テスト・コンポーネントルール）
make check-ready
```

#### 違反例と修正例

**❌ 違反例1: ElevatedButtonの直接使用**
```dart
ElevatedButton(
  onPressed: () {
    // 処理
  },
  child: Text('ボタン'),
)
```

**✅ 修正例1:**
```dart
PrimaryButton(
  text: 'ボタン',
  screen: 'HomeScreen',
  width: 200,
  isDisabled: false,
  callback: () {
    // 処理
  },
)
```

**❌ 違反例2: AlertDialogの直接使用**
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('確認'),
    content: Text('削除しますか？'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('キャンセル'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          // 削除処理
        },
        child: Text('削除'),
      ),
    ],
  ),
);
```

**✅ 修正例2:**
```dart
showDialog(
  context: context,
  builder: (_) => TwoButtonDialog(
    title: '確認',
    screen: 'HomeScreen',
    content: '削除しますか？',
    primaryButtonLabel: '削除',
    secondaryButtonLabel: 'キャンセル',
    primaryCallBack: () {
      Navigator.of(context).pop();
      // 削除処理
    },
    secondaryCallBack: () {
      Navigator.of(context).pop();
    },
  ),
);
```

**❌ 違反例3: ScaffoldMessengerの直接使用**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('保存しました'),
    backgroundColor: Colors.green,
  ),
);
```

**✅ 修正例3:**
```dart
SnackBarUtility.showSuccess(
  context: context,
  theme: theme,
  message: '保存しました',
);
```

#### 例外ケース

以下の場合のみ、例外として直接使用を許可します：

1. **サードパーティライブラリのカスタマイズ**
   - ライブラリ内部でウィジェットをラップする場合
   - 専用コンポーネントを作成する場合

2. **新規コンポーネント開発**
   - `lib/component/`配下で新しいコンポーネントを作成する場合
   - 必ずコードレビューを経てから使用すること

### 状態管理

1. **Riverpod + Flutter Hooks**:

   - 主要な状態管理に Riverpod と Flutter Hooks を組み合わせて使用
   - グローバル状態は Provider で管理（例: appThemeProvider, userStateProvider）
   - ローカル状態は useState や useTextEditingController などの Hooks で管理

2. **状態の分離パターン**:

   - 読み取り専用の状態: `ref.watch(provider)`
   - 状態の更新: `ref.watch(provider.notifier)`
   - コンポーネント内状態管理:
     - 一時的な状態（検索結果など）は useState で管理
     - フォーム状態は TextEditingController で管理

3. **プロバイダーの種類**:
   - 複雑な状態には`StateNotifier`を使用
   - 単純な状態には`Provider`を使用
   - 非同期データの取得には`FutureProvider`または`StreamProvider`を使用

### エラーハンドリング

1. **例外処理**:

   - API エラーは適切なエラーハンドリングを使用
   - 認証エラーは専用のハンドリングを使用
   - ネットワークエラーは`use_network_check.dart`を使用

2. **ログ記録**:
   - デバッグログには`utility/logger/logger.dart`を使用
   - 開発環境では詳細なログを記録し、本番環境では最小限のログを記録
   - ログパラメータは`utility/format_log_parameters.dart`でフォーマット

### テスト

1. **単体テスト**:

   - ビジネスロジックとユーティリティ関数には単体テストを作成
   - テストファイルは対応するソースファイルと同じディレクトリ構造に配置
   - テストファイル名は`*_test.dart`の形式

2. **モック**:
   - 外部依存関係のモックには`mockito`または`mocktail`を使用
   - テスト用のモックデータは`test/mock_data/`ディレクトリに配置

## 開発ワークフロー

1. **ブランチ戦略**:

   - 新機能開発: `feature/*`
   - バグ修正: `fix/*`
   - リファクタリング: `refactor/*`
   - 開発環境: `develop`
   - ステージング環境: `staging`
   - 本番環境: `main`

2. **ブランチ運用ルール（pushエラー防止）**:

   > ⚠️ `Can't push refs to remote. Try running "Pull" first` エラーを防ぐためのルール

   **【作業開始時 - 必須手順】**
   ```bash
   # 1. リモートの最新情報を取得
   git fetch origin

   # 2. mainブランチを最新化
   git checkout main
   git pull origin main

   # 3. 新しいフィーチャーブランチを作成して作業開始
   git checkout -b feature/your-feature-name
   ```

   **【作業完了時 - 必須手順】**
   ```bash
   # 1. 変更をコミット
   git add .
   git commit -m "feat: your changes"

   # 2. push前にmainの最新を取り込む（競合防止）
   git fetch origin
   git rebase origin/main

   # 3. フィーチャーブランチをpush
   git push -u origin feature/your-feature-name

   # 4. PRを作成してマージ（mainに直接pushしない）
   gh pr create --base main
   ```

   **【禁止事項】**
   - ❌ mainブランチへの直接push
   - ❌ fetch/pullなしでのpush
   - ❌ rebaseなしでの長期ブランチ作業

   **【推奨事項】**
   - ✅ 作業開始前に必ず `git fetch && git pull`
   - ✅ 1日1回以上 `git fetch origin && git rebase origin/main`
   - ✅ PRマージ後は速やかにローカルmainを更新

3. **コード品質チェック（実装時必須）**:

   - 実装後は必ず以下のコマンドを実行：
     ```bash
     make check-ready  # format + analyze + test を一括実行
     ```
   - 個別チェック：
     ```bash
     make format      # コードフォーマット
     make analyze     # 静的解析（lint）
     make test        # テスト実行
     ```
   - プッシュ前チェック：
     ```bash
     make push        # check-ready + git push を一括実行
     ```

4. **コードレビュー**:

   - PR を作成する前に`make check-ready`を実行して全チェックをクリア
   - PR には適切なレビュアーを指定
   - PR テンプレートに従って必要な情報を記入

5. **CI/CD**:
   - PR ごとに自動テストとリントチェックが実行される（Lefthook使用）
   - ステージング環境へのデプロイは`staging`ブランチへのマージ後に実行
   - 本番環境へのデプロイは`main`ブランチへのマージ後に実行

6. **Git Hook エラー対処**:
   - プッシュ時にLefthookエラーが発生した場合：
     ```bash
     # 事前チェックで問題を解決
     make check-ready

     # 緊急時のスキップ（非推奨）
     LEFTHOOK=0 git push
     ```

## 重要な概念

1. **アプリライフサイクル**:

   - `AppLifecycleStateProvider`: アプリのライフサイクル状態の管理
   - `MediaQueryStateNotifier`: 画面サイズと向きの管理

2. **認証システム**:

   - Firebase Authentication を使用
   - Google Sign-In によるソーシャルログイン対応

3. **プッシュ通知**:

   - `CloudMessagingProvider`: プッシュ通知の管理
   - `PushNotificationStateNotifier`: 通知設定の状態管理
   - `handleCloudMessage`: 受信メッセージの処理

4. **分析統合**:

   - `FirebaseAnalyticsProvider`: ユーザーインタラクションのログ記録
   - `AppTrackingTransparency`: iOS のトラッキング許可管理

5. **課金システム**:
   - RevenueCat を使用したサブスクリプション管理
   - `PurchaseStateNotifier`: 課金状態の管理

### 💎 サブスクリプション状態のリアルタイム反映ルール（必須）

**サブスクリプションプランの購入・解約・更新時に、UI状態がリアルタイムに反映されるよう実装する必要があります。**

#### 必須実装パターン

**1. 課金状態の監視（ref.watchを使用）**
```dart
// ✅ 正しい実装 - ref.watchで状態を監視
class SubscriptionScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 課金状態をwatchで監視（状態変更時に自動的に再ビルド）
    final purchaseState = ref.watch(purchaseStateNotifierProvider);

    return purchaseState.when(
      data: (state) {
        // プレミアム状態に応じたUI表示
        if (state.isPremium) {
          return const PremiumContent();
        }
        return const FreeContent();
      },
      loading: () => const Loading(),
      error: (e, _) => ErrorWidget(error: e),
    );
  }
}
```

**2. 課金状態に依存するUIコンポーネント**
```dart
// ✅ 正しい実装 - 広告バナーの表示制御
class AdBannerWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseStateNotifierProvider);

    // プレミアムユーザーには広告を表示しない
    final isPremium = purchaseState.valueOrNull?.isPremium ?? false;
    if (isPremium) {
      return const SizedBox.shrink();
    }

    return const AdBanner();
  }
}

// ✅ 正しい実装 - 機能制限の表示制御
class FeatureLimitBadge extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseStateNotifierProvider);
    final isPremium = purchaseState.valueOrNull?.isPremium ?? false;

    if (isPremium) {
      return const SizedBox.shrink(); // プレミアムなら非表示
    }

    return const Badge(label: 'PRO');
  }
}
```

**3. 購入完了後の状態更新**
```dart
// ✅ 正しい実装 - 購入処理
Future<void> _handlePurchase(WidgetRef ref) async {
  final notifier = ref.read(purchaseStateNotifierProvider.notifier);

  try {
    await notifier.purchase(packageId: 'premium_monthly');
    // 購入成功 → PurchaseStateNotifierが自動的に状態を更新
    // → ref.watchしている全UIが自動的に再ビルド
  } catch (e) {
    // エラーハンドリング
  }
}
```

#### 禁止パターン

**❌ ref.readで課金状態を取得してUIに反映**
```dart
// ❌ 間違った実装 - ref.readは状態変更を監視しない
class BadExample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // readは一度だけ値を取得し、以降の変更は反映されない
    final purchaseState = ref.read(purchaseStateNotifierProvider);

    // 購入後もUIが更新されない！
    if (purchaseState.valueOrNull?.isPremium ?? false) {
      return const PremiumContent();
    }
    return const FreeContent();
  }
}
```

**❌ ローカル変数で課金状態をキャッシュ**
```dart
// ❌ 間違った実装 - ローカル変数はリアルタイム更新されない
class BadExample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseStateNotifierProvider);

    // useStateでキャッシュすると更新が反映されない
    final isPremium = useState(purchaseState.valueOrNull?.isPremium ?? false);

    // isPremium.valueは初期値のまま変わらない！
    return isPremium.value ? const PremiumContent() : const FreeContent();
  }
}
```

**❌ initStateや一度きりの処理で課金状態を判定**
```dart
// ❌ 間違った実装 - 初期化時のみの判定
class BadStatefulWidget extends StatefulWidget {
  @override
  State<BadStatefulWidget> createState() => _BadStatefulWidgetState();
}

class _BadStatefulWidgetState extends State<BadStatefulWidget> {
  late bool _isPremium;

  @override
  void initState() {
    super.initState();
    // 初期化時のみ判定 → 以降の状態変更は反映されない
    _isPremium = /* 課金状態の取得 */;
  }
}
```

#### チェックリスト

**課金状態に依存する全てのUIで以下を確認：**
- [ ] `ref.watch(purchaseStateNotifierProvider)` で状態を監視している
- [ ] `ref.read()` ではなく `ref.watch()` を使用している
- [ ] ローカル変数（useState等）で課金状態をキャッシュしていない
- [ ] 課金状態の変更時にUIが自動的に更新される
- [ ] 広告表示、機能制限、プレミアムバッジ等全ての箇所で正しく実装

#### 影響を受ける典型的なUI要素

| UI要素 | 期待される動作 |
|--------|--------------|
| 広告バナー | プレミアム購入後、即座に非表示 |
| 機能制限バッジ（PRO等） | プレミアム購入後、即座に非表示 |
| アップグレードボタン | プレミアム購入後、即座に非表示または変更 |
| 制限解除メッセージ | プレミアム購入後、即座に表示 |
| 使用回数カウンター | プレミアム購入後、即座に無制限表示 |
| 設定画面のプラン表示 | プレミアム購入後、即座にプラン名更新 |

## 環境設定

1. **Flutter**:

   - Flutter SDK は stable バージョンを使用
   - コマンド実行時は`flutter`を使用

2. **環境変数**:

   - 環境変数は`dart_env/`ディレクトリ内のファイルで管理
   - 開発環境: `dev.env`
   - ステージング環境: `stg.env`
   - 本番環境: `prod.env`

3. **ビルド設定**:
   - ビルドコマンドは`Makefile`で定義
   - CI/CD パイプラインは`.github/workflows/`ディレクトリで設定

## パフォーマンス最適化

1. **画像最適化**:

   - 画像ファイルは最適化・圧縮してから追加
   - SVG ファイルを優先的に使用
   - `flutter_gen`を使用した画像リソース管理

2. **メモリ管理**:

   - 大きなオブジェクトは使用後に適切に破棄
   - 不要なウィジェットの再構築を避ける

3. **時間関連の処理**:
   - 時間値（ミリ秒など）にはマジックナンバーを使用せず、名前付き定数を定義

## セキュリティ

1. **認証情報**:

   - 認証情報は`SharedPreferences`で安全に保存
   - API キーなどの機密情報はソースコードに直接記述しない

2. **API リクエスト**:
   - API リクエストには適切な認証ヘッダーを追加
   - HTTPS 通信を強制

## アクセシビリティ

1. **セマンティクス**:

   - 重要な UI コンポーネントには適切なセマンティクスラベルを追加
   - コントラスト比を適切に保つ

2. **フォントサイズ**:

   - テキストサイズはデバイスの設定に応じてスケーリング
   - 最小フォントサイズを設定して可読性を確保

3. **国際化**:
   - `AppLocalizations`を使用した多言語対応
   - 39言語対応（市場規模順：英語・日本語・中国語・韓国語・ドイツ語・フランス語・ポルトガル語・スペイン語・ヒンディー語・イタリア語）
   - **翻訳整合性チェック**: `make check-translations`で以下を自動チェック
     - 全言語で同じキーが存在するか
     - 重複キーがないか
     - 空の翻訳値がないか
     - 未翻訳の箇所（他言語の文字列が混入）がないか
   - 新しい翻訳を追加するたびに必ず実行すること

## リリースプロセス

1. **事前準備**:

   - Firebase プロジェクトの作成
   - 証明書の作成（iOS）
   - アプリの作成（App Store Connect, Google Play Console）

2. **ビルド・テスト**:

   - `make run-dev`, `make run-prod`でビルドテスト
   - 各種設定の確認

3. **リリース準備**:

   - アイコン・スプラッシュ画面の設定
   - スクリーンショットの作成
   - アプリ説明文の準備

4. **審査・公開**:
   - ストア審査への提出
   - 審査対応
   - 公開後の設定（AdMob 連携等）

## App Store 審査準拠チェックリスト（必須）

App Store 審査でリジェクトされないよう、以下のチェックリストを必ず確認してください。

### Guideline 3.1.2 - サブスクリプション要件

自動更新サブスクリプションを提供するアプリは、以下の情報をアプリ内に表示する必要があります：

1. **サブスクリプションタイトル**（アプリ内購入製品名と同じ可）
2. **サブスクリプション期間**（月額/年額など）
3. **サブスクリプション価格**（適切な場合は単位あたりの価格も）
4. **利用規約とプライバシーポリシーへの機能的なリンク**

**実装方法:**

```dart
// SubscriptionScreenConfig に法的リンクを設定
SubscriptionScreen(
  config: SubscriptionScreenConfig(
    // ... 他の設定
    termsOfServiceUrl: ExternalPageList.legal,      // 必須
    privacyPolicyUrl: ExternalPageList.privacyPolicy, // 必須
    benefits: [...],
  ),
);
```

**App Store Connect での設定（必須）:**
- Privacy Policy URL を「App Privacy」セクションに入力
- Terms of Use (EULA) を以下のいずれかで設定:
  - App Description に「Apple's Standard EULA applies」と記載
  - 「App Information」→「License Agreement」でカスタム EULA を設定

### Guideline 4.0 - iOS 権限リクエストの言語一致

権限リクエスト（カメラ、写真ライブラリ等）の文言は、アプリのローカライゼーションと同じ言語で表示される必要があります。

**正しい構成:**

1. **Info.plist**: 英語（ベース言語）で権限説明を設定
2. **InfoPlist.strings**: 各言語ディレクトリに翻訳を配置

```
ios/Runner/
├── Info.plist                 # 英語ベース
├── en.lproj/InfoPlist.strings # 英語
├── ja.lproj/InfoPlist.strings # 日本語
├── de.lproj/InfoPlist.strings # ドイツ語
└── ...
```

**Info.plist（英語ベース）:**
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to take photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required to save photos.</string>
```

**InfoPlist.strings（各言語）:**
```
// ja.lproj/InfoPlist.strings
NSCameraUsageDescription = "写真を撮影するためにカメラへのアクセスが必要です。";
NSPhotoLibraryUsageDescription = "写真を保存するためにフォトライブラリへのアクセスが必要です。";
```

### 審査前チェックリスト

| チェック項目 | 確認 |
|-------------|------|
| サブスクリプション画面に利用規約リンクがある | [ ] |
| サブスクリプション画面にプライバシーポリシーリンクがある | [ ] |
| App Store Connect に Privacy Policy URL が設定されている | [ ] |
| App Store Connect に EULA が設定されている（またはApp Descriptionに記載） | [ ] |
| Info.plist の権限説明が英語になっている | [ ] |
| 全言語の InfoPlist.strings に権限説明がある | [ ] |
| 権限説明がアプリの機能を正確に説明している | [ ] |

## カスタマイズガイド

### プロジェクト名の変更

1. `pubspec.yaml`の`name`フィールドを変更
2. `lib/l10n/`内の翻訳ファイルのアプリ名を更新
3. アイコンとスプラッシュ画面を新しいアプリ用に変更

### 機能の追加・削除

1. 不要なプロバイダーは`lib/provider/`から削除
2. 不要なコンポーネントは`lib/component/`から削除
3. 新しい機能に応じてプロバイダーとコンポーネントを追加

### レビューダイアログの実装

**このテンプレートでは、レビューダイアログの呼び出しを意図的に含めていません。**

アプリ固有の最適なタイミングでレビューリクエストを表示するため、実装時に以下のガイドを参照してください：

- **ベストプラクティスガイド**: `.claude/docs/best-practices/rating-dialog-timing.md`
- **推奨タイミング**: タスク完了直後、目標達成時、ポジティブな体験の後
- **使用方法**: `useRatingDialog(context: context, ref: ref, screen: 'screen_name')`

詳細は [rating-dialog-timing.md](..//best-practices/rating-dialog-timing.md) を参照してください。

### テーマのカスタマイズ

1. `lib/theme/app_colors.dart`でカラーパレットを定義
2. `lib/theme/app_theme.dart`でテーマを調整

## 🎨 UIデザインルール（必須）

### Apple Design Skill の使用（必須）

**新規UIコンポーネントや画面を実装する際は、必ず apple-design skill を参照してください。**

**スキルファイルの場所:**
- `.claude/skills/apple-design/SKILL.md` - コア指示とクイックリファレンス
- `.claude/skills/apple-design/references/` - 詳細リファレンス

**必須参照タイミング:**
1. 新規画面（Screen）の作成時
2. 新規コンポーネント（Widget）の作成時
3. 既存UIの大幅なリデザイン時
4. カスタムアニメーションの実装時
5. カラーやタイポグラフィの追加・変更時

**Apple Design 原則:**
- **Clarity（明瞭性）**: 読みやすく、認識しやすいUI
- **Deference（控えめさ）**: コンテンツが主役、UIは脇役
- **Depth（深度）**: レイヤーとブラー効果で視覚的階層を表現

**デザイン実装チェックリスト:**
- [ ] 8ptグリッドシステムでレイアウト
- [ ] AppleTextStylesまたは既存theme.textThemeを使用
- [ ] **テキスト階層を確認（バッジ < 補助テキスト < タイトル）**
- [ ] **グラデーション背景は `theme.appColors.main`（ブランド色）を使用（`primary`=黒 は使わない）**
- [ ] **背景色は `AppleSemanticColors.background(context)` を使用**
- [ ] ダークモード対応を含める
- [ ] 44pt以上のタッチターゲット確保
- [ ] アニメーションは200-500msで控えめに
- [ ] アクセシビリティ設定（Reduced Motion等）を考慮

### 🔤 テキストサイズ必須ルール（AppTextTheme）

> ⚠️ **命名の罠**: `h` の数字は**小さいほど小さいフォント**（h10=10pt, h60=24pt）

**用途別スタイル対応表:**

| 用途 | ✅ 正しいスタイル | ❌ よくある誤り |
|------|----------------|--------------|
| バッジ・チップのテキスト | `h10`（10pt） | `h60`（24pt） ← バッジがタイトルより大きくなる |
| 日付・補助テキスト | `h20`（12pt） | `h50`（20pt） |
| リストタイトル | `h40`（16pt） | `h30`（14pt） |
| セクション見出し | `h45`〜`h50`（18〜20pt） | - |
| 大型統計数値 | `h50`〜`h60`（20〜24pt） | - |

```dart
// ✅ 正しい階層（バッジ < 補助テキスト < タイトル）
_CategoryBadge:  theme.textTheme.h10  // 10pt
dateText:        theme.textTheme.h20  // 12pt
titleText:       theme.textTheme.h40  // 16pt

// ❌ NG: バッジ(24pt) > タイトル(14pt) という逆転
_CategoryBadge:  theme.textTheme.h60  // 24pt ← 大きすぎ！
titleText:       theme.textTheme.h30  // 14pt
```

### 🎨 ブランドカラー必須ルール（main vs primary）

> ⚠️ **命名の罠**: `primary` は「メイン」ではなくテキスト色。グラデーションに使うと真っ黒になる。

| プロパティ | 実際の色 | 正しい用途 | ❌ 誤った用途 |
|-----------|---------|-----------|------------|
| `theme.appColors.main` | ブランドアクセント色（プロジェクト毎に異なる） | グラデーション、カラーヘッダー、アクセント装飾 | テキスト色 |
| `theme.appColors.primary` | `#212121`（ほぼ黒） | テキスト、アイコン、前景要素 | 背景グラデーション、カラーUI |

```dart
// ✅ 正しい: グラデーション背景 → main（ブランドアクセント）
gradient: LinearGradient(
  colors: [theme.appColors.main, theme.appColors.main.withValues(alpha: 0.75)],
)

// ❌ NG: primary(#212121=黒) でグラデーション → 暗鬱・古臭いUIになる
gradient: LinearGradient(
  colors: [theme.appColors.primary, theme.appColors.primary.withValues(alpha: 0.75)],
)
```

**既存テーマシステムとの関係:**
```dart
// 既存コード（引き続き使用可能）
theme.appColors.primary  // テキスト・アイコン色（#212121 ほぼ黒）
theme.appColors.main     // ブランドアクセント色（プロジェクト毎に異なる）
theme.textTheme.h30

// Apple Design準拠の新規実装時
// → apple-design skill のガイドラインに従う
```

**参照コマンド:**
```bash
# スキルファイルを確認
cat .claude/skills/apple-design/SKILL.md

# 詳細リファレンス
cat .claude/skills/apple-design/references/colors.md
cat .claude/skills/apple-design/references/typography.md
cat .claude/skills/apple-design/references/components.md
cat .claude/skills/apple-design/references/animations.md
cat .claude/skills/apple-design/references/spacing.md
```
