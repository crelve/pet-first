# 原則

- まず、この knowledge が呼ばれたら「コーディングルールを確認しました。」と出力する事
- 本リポジトリのコーディングを行う際は以下の実装前必須チェックに従い作業を行う事
- 開発コマンド実行時は、必ずこのチェックを実行してから実装を開始すること
- チェックリストがすべて✅であることを確認してから修正を完了する

## 実装前必須チェック

⚠️ **重要**: 時間短縮のためにこれらのチェック項目を省略してはいけない。品質維持のため全項目を必ず実行すること。

### 1. 静的解析の実行
```bash
flutter analyze  # 0 issues found! であることを確認
# 0 issues達成後は自動的にコミット・Pushを実行
```

### 2. 既存パターンの確認（最重要）
- テーマ使用時の実際のプロパティを確認
- コンポーネント使用時の既存パターンを確認
- 状態管理パターンを確認
- l10n使用パターンを確認

### 3. 品質ルール準拠チェック
詳細なチェック方法は **`.claude/commands/release/step/10-quality-rules-check.md`** を参照してください。

以下のコマンドで包括的な品質チェックを実行:
```bash
# 色管理ルールチェック
make check-color-usage

# 統合品質チェック（推奨）
make check-ready

# または個別チェック
make analyze  # 静的解析
make format   # フォーマット
make test     # テスト実行
```

### 4. 実装方針
- **新しいプロパティやメソッドを追加するのではなく、既存のものを使う**
- **既存のコードベースのパターンに完全に合わせる**
- **勝手に独自の実装を作らない**
- **時間短縮のためにコーディングルールを省略しない**
- **品質維持のため全チェック項目を必ず実行する**
- テストファイル作成時は sealed class の継承を禁止
- 未使用のインポートや変数は削除する

## コーディング規約詳細

### 📋 import文順序（必須）
4つのセクションに分けてアルファベット順:
```dart
// 1. Dart SDK imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. External package imports
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 4. Relative imports - barrel exportsを使用
import '../import/component.dart';  // ✅ 必須: barrel import使用
import '../import/model.dart';      // ✅ 必須: barrel import使用
import '../import/provider.dart';   // ✅ 必須: barrel import使用
import '../import/service.dart';    // ✅ 必須: barrel import使用
import '../import/utility.dart';    // ✅ 必須: barrel import使用
```

### 📦 Barrel Import規則（必須）
```dart
// ✅ 必須 - lib/import/配下のbarrel exportを使用
import '../import/model.dart';           // model/配下のすべて
import '../import/component.dart';       // component/配下のすべて
import '../import/provider.dart';        // provider/配下のすべて
import '../import/service.dart';         // service/配下のすべて
import '../import/utility.dart';         // utility/配下のすべて

// ❌ 禁止 - 直接パスでのimport
import '../model/security/privacy_settings.dart';
import '../model/time/time_entry.dart';
import '../component/button/timer_button.dart';
import '../provider/auth/auth_provider.dart';
```

### 🧩 コンポーネント使用規則（必須）

#### 1. 余白
```dart
// ✅ 必須
hSpace(height: 16)  // 縦の余白
wSpace(width: 16)   // 横の余白

// ❌ 禁止
const SizedBox(height: 16)
```

#### 2. カラー
```dart
// ✅ 必須
color: theme.appColors.text
color: ColorUtility.black50

// ❌ 禁止
color: ColorName.black.withValues(alpha: 0.5)
color: Colors.white  // Colors.* の直接使用を禁止
```

#### 3. ローディング表示
```dart
// ✅ 必須
const Loading()

// ❌ 禁止
const CircularProgressIndicator()
```

#### 4. テキスト表示
```dart
// ✅ 必須 - 多言語化対応（l10n使用）
ThemeText(
  text: l10n.buttonSave,  // 多言語化されたテキスト
  color: theme.appColors.text,
  style: theme.textTheme.h30,
)

// ❌ 禁止 - 直接文字列使用
ThemeText(
  text: 'テキスト',  // 直接文字列は禁止
  color: theme.appColors.text,
  style: theme.textTheme.h30,
)

// ❌ 禁止
Text('テキスト', style: TextStyle(color: ColorName.black))
```

#### 5. ヘッダー表示

**全画面で`BaseHeader`のみを使用**

画面のヘッダーには統一された`BaseHeader`コンポーネントを使用します。アクションボタンは画面下部に配置します。

```dart
// ✅ 必須 - BaseHeaderのみ使用（多言語化対応）
// showBackButton引数で戻るボタンの表示を制御（デフォルト: false）
BaseHeader(title: l10n.screenTitle)                          // 戻るボタンなし（ホーム画面等）
BaseHeader(title: l10n.screenTitle, showBackButton: true)    // 戻るボタンあり（詳細画面等）

// ✅ 推奨 - appBarプロパティとして使用
Scaffold(
  appBar: BaseHeader(title: l10n.screenTitle),               // 戻るボタンなし
  body: /* コンテンツ */,
)

Scaffold(
  appBar: BaseHeader(title: l10n.screenTitle, showBackButton: true),  // 戻るボタンあり
  body: /* コンテンツ */,
)

// ✅ 推奨 - body内で使用 + 下部ボタン配置パターン
Scaffold(
  body: Column(
    children: [
      BaseHeader(title: l10n.screenTitle),
      Expanded(child: /* メインコンテンツ */),

      // 下部ボタンエリア
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.appColors.surface,
          boxShadow: const [
            BoxShadow(
              color: ColorUtility.black10,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SecondaryButton(
          text: l10n.close,
          screen: 'ScreenName',
          width: double.infinity,
          callback: () => Navigator.of(context).pop(),
        ),
      ),
    ],
  ),
)

// ✅ 推奨 - 複数ボタンの配置例
child: Row(
  children: [
    Expanded(
      child: SecondaryButton(
        text: l10n.close,
        callback: () => Navigator.pop(context),
      ),
    ),
    wSpace(width: 12),
    Expanded(
      child: PrimaryButton(
        text: l10n.save,
        callback: _handleSave,
      ),
    ),
  ],
),

// ❌ 禁止 - 直接文字列使用
BaseHeader(title: 'タイトル')

// ❌ 禁止 - AppBarの直接使用
AppBar(title: Text('タイトル'))

// ❌ 禁止 - SliverAppBarの使用
SliverAppBar(title: Text('タイトル'))

// ❌ 禁止 - AppBarをappBarプロパティに直接使用
Scaffold(
  appBar: AppBar(title: Text('タイトル')),  // ← AppBar禁止
  body: /* コンテンツ */,
)



// ❌ 禁止 - ヘッダー内にアクションボタンを配置
BaseHeader(
  title: l10n.screenTitle,
  actions: [IconButton(...)],  // アクションは画面下部に配置すること
)
```

**設計原則:**
- ヘッダーはタイトル表示のみに集中
- アクション（保存、追加、削除など）は画面下部のボタンで処理
- 親指で押しやすい下部ボタン配置でモバイルUXを向上
- 全画面で統一されたパターンで保守性を向上
```

**重要**:
- **すべての画面でAppBar/SliverAppBarを直接使用しない**
- ヘッダーは必ず`BaseHeader`（flutter_foundation）を使用
- `appBar`プロパティには`BaseHeader`のみ使用可（AppBar禁止）
- アクションボタンはヘッダーに配置せず、画面下部に配置

### 🛣️ ルート定義管理（必須）

#### ファイル配置ルール
- **必須**: `lib/route/route.dart` で全ルート一元管理
- **禁止**: 各画面ファイル内でのルートパス定義
- **禁止**: プロバイダーファイル内でのルート定義

### ⚠️ 例外処理規則（必須）

#### すべてのcatchにon句を付ける
```dart
// ✅ 必須
try {
  await firebaseOperation();
} on FirebaseException catch (e) {
  logger.e('Firebase error: ${e.message}', e);
  throw DataException('データ操作に失敗しました');
} on Exception catch (e) {
  logger.e('Unexpected error', e);
  rethrow;
}

// ❌ 禁止
try {
  await firebaseOperation();
} catch (e) {
  print(e);
}
```

### 🌐 多言語化対応（必須）

#### l10n使用規則
すべてのテキスト表示でAppLocalizationsを使用:
```dart
// ✅ 必須 - AppLocalizations使用
import '../l10n/app_localizations.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ThemeText(
      text: l10n.productName,
      style: theme.textTheme.h30,
    );
  }
}

// ❌ 禁止 - 直接文字列使用
ThemeText(text: '保存')
Text('エラーが発生しました')
SnackBar(content: Text('処理が完了しました'))
```

#### l10n定義追加方法
新しいテキストを追加する場合は**全ての.arbファイル**に定義:
```bash
# 必須: 全39言語の.arbファイルに同時に追加（市場規模順）
# lib/l10n/app_en.arb (1. 英語 - 最大市場)
# lib/l10n/app_ja.arb (2. 日本語 - 高ARPU)
# lib/l10n/app_zh.arb (3. 中国語 - ユーザー数多)
# lib/l10n/app_ko.arb (4. 韓国語 - 課金率高)
# lib/l10n/app_de.arb (5. ドイツ語 - EU最大iOS)
# lib/l10n/app_fr.arb (6. フランス語 - EU第2位)
# lib/l10n/app_pt.arb (7. ポルトガル語 - LATAM最大)
# lib/l10n/app_es.arb (8. スペイン語 - 広言語圏)
# lib/l10n/app_hi.arb (9. ヒンディー語 - 成長市場)
# lib/l10n/app_it.arb (10. イタリア語 - EU中堅)
```

#### 全言語対応の例
```json
// app_ja.arb (日本語)
{
  "newButtonText": "新しいボタン",
  "@newButtonText": {
    "description": "新しいボタンのテキスト"
  }
}

// app_en.arb (英語)
{
  "newButtonText": "New Button",
  "@newButtonText": {
    "description": "Text for new button"
  }
}

// 他の言語ファイル (es, fr, it, ko, zh) にも同様に追加
```

#### l10nファイル確認
```bash
# 既存のl10nファイル確認
ls lib/l10n/*.arb
# 全39言語のファイルが存在することを確認

# 使用可能なl10nキー確認
grep -o '"[^"]*":' lib/l10n/app_ja.arb | head -10

# 全ファイルで同じキーが定義されているか確認
for file in lib/l10n/app_*.arb; do
  echo "=== $file ==="
  grep -o '"[^"]*":' "$file" | grep -v '@' | head -5
done
```

### 🔍 静的解析ルール（必須）

#### 1. APIドキュメント (`public_member_api_docs`)
すべての公開メンバーに `///` コメントを記述:
```dart
/// 学習カードのデータモデル
@freezed
class LearningCard with _$LearningCard {
  /// LearningCard のインスタンスを作成
  const factory LearningCard({
    /// カードの一意識別子
    required String id,
    /// カードのタイトル（質問文）
    required String title,
  }) = _LearningCard;
}
```

#### 2. Dynamic型 (`avoid_dynamic_calls`)
dynamic への直接アクセスを禁止:
```dart
// ✅ 必須 - 型安全なアクセス
final data = jsonDecode(response.body) as Map<String, dynamic>;
final candidates = data['candidates'] as List<dynamic>?;

// ❌ 禁止 - dynamic への直接アクセス
return result.data['key'];
```

#### 3. パラメータ命名 (`avoid_types_as_parameter_names`)
パラメータ名は型名と重複させない:
```dart
// ✅ 必須
final total = numbers.fold(0, (accumulator, number) => accumulator + number);

// ❌ 禁止
final total = numbers.fold(0, (sum, number) => sum + number);
```

#### 4. 型推論失敗 (`inference_failure_on_function_invocation`)
型引数を明示的に指定:
```dart
// ✅ 必須
final result = await callable.call<Map<String, dynamic>>();
await context.push<void>('/next-screen');

// ❌ 禁止
final result = await callable.call();
```

#### 5. 不要なasync修飾子 (`unnecessary_async`)
awaitを使わない場合はasync修飾子を削除:
```dart
// ✅ 必須 - async修飾子なし
Future<String> getData() {
  return _someOperation();
}

// ❌ 禁止
Future<String> getData() async {
  return _someOperation();
}
```

### 🏷️ 命名規則（必須）

#### ファイル・ディレクトリ
- **ファイル名**: `snake_case.dart`
- **ディレクトリ名**: `snake_case`
- **クラス名**: `PascalCase`
- **変数・関数名**: `camelCase`

#### プライベートメンバー
```dart
// ✅ 外部からアクセスしない場合はプライベートに
final _privateVariable = true;
void _privateMethod() {}
```

#### メソッドパラメータ（必須）
```dart
// ✅ 必須 - 必須パラメータには required 修飾子
Widget buildHeader({
  required String title,
  required VoidCallback onTap,
  required IconData icon,
  String? subtitle,
  Color? backgroundColor,
}) {
  return Container();
}

void processData({
  required List<String> items,
  required Function(String) onItemSelected,
  required bool isEnabled,
  int? maxCount,
}) {
  // 処理
}

Future<Result> fetchUserData({
  required String userId,
  required Map<String, dynamic> parameters,
  bool? includeCache,
}) async {
  return Result();
}

// ❌ 禁止 - 位置引数での必須パラメータ
Widget buildHeader(String title, VoidCallback onTap, IconData icon) {
  return Container();
}

// ❌ 禁止 - required なしの必須パラメータ
Widget buildHeader({
  String title,           // required なし
  VoidCallback onTap,     // required なし
  IconData icon,          // required なし
}) {
  return Container();
}
```

### 📝 TODOコメント規則（必須）

Flutter StyleのTODOコメント形式:
```dart
// ✅ 必須 - Flutter Style準拠
// TODO(username): Implement OCR with Firebase ML Kit
// TODO(username): Add error handling for network timeouts

// ❌ 禁止
// TODO: Implement OCR
// TODO - Add error handling
```

### ⚡ パフォーマンス最適化（必須）

#### const修飾子の使用
```dart
// ✅ 必須 - const修飾子を使用
const SizedBox(height: 16)
const Icon(Icons.star)
const Text('静的テキスト')
const Padding(
  padding: EdgeInsets.all(8.0),
  child: Text('テキスト'),
)

// ❌ 禁止 - const修飾子なし
SizedBox(height: 16)
Icon(Icons.star)
Text('静的テキスト')
Padding(
  padding: EdgeInsets.all(8.0),
  child: Text('テキスト'),
)
```

### 🔄 開発フロー（必須）

#### 1. コーディング前
```bash
# 静的解析の実行
flutter analyze

# 対象ルールの警告確認
flutter analyze | grep "public_member_api_docs"
flutter analyze | grep "avoid_catches_without_on_clauses"
```

#### 2. コーディング中
- **型推論**: 曖昧な場合は明示的に型を指定
- **例外処理**: 具体的な例外型でキャッチ
- **ドキュメント**: 公開メンバーには必ずコメント

#### 3. コーディング後
```bash
# 全体的なチェック
flutter analyze

# 特定ルールの確認
flutter analyze | grep "ルール名" | wc -l

# テスト実行
flutter test

# 最終確認（エラー・アラート0件確認）
flutter analyze && echo "✅ 解析完了: エラー・アラート0件"
```

## 🎯 プロジェクト固有規則（必須）

### Switch文の完全列挙
```dart
// ✅ 必須 - すべての値を列挙
switch (status) {
  case Status.loading:
    return const Loading();
  case Status.success:
    return const SuccessWidget();
  case Status.error:
    return const ErrorWidget();
  // default句は使わない
}

// ❌ 禁止 - default使用
switch (status) {
  case Status.loading:
    return const Loading();
  default:
    return const ErrorWidget();
}
```

### ファイル末尾の改行
```dart
// ✅ 必須 - ファイル末尾に改行
class MyClass {
  // implementation
}
// ← ここに改行必須

// ❌ 禁止 - 改行なし
class MyClass {
  // implementation
}// ← 改行なし
```

### 型注釈の最適化
```dart
// ✅ 必須 - 型推論活用
final items = <String>[];
final count = 0;

// ❌ 禁止 - 不要な型注釈
final List<String> items = <String>[];
final int count = 0;
```

### ログ出力規則
```dart
// ✅ 必須 - loggerを使用
import '../../import/utility.dart';

logger.i('Info message');
logger.e('Error message', error);

// ❌ 禁止 - print使用
print('Debug message');
```

### テーマアクセス規則
```dart
// ✅ 必須 - Riverpodプロバイダー使用
final theme = ref.watch(appThemeProvider);

// ❌ 禁止 - Theme.of(context)使用
final theme = Theme.of(context).extension<AppTheme>()!;
```

### クラス設計規則
```dart
// ✅ 必須 - インスタンスメンバーを持つ
class UserService {
  final String userId;
  UserService(this.userId);

  Future<User> getUser() async {
    return await api.getUser(userId);
  }
}

// ❌ 禁止 - 静的メンバーのみ
class UserService {
  static Future<User> getUser(String userId) async {
    return await api.getUser(userId);
  }
}
```

### 🎨 UIデザイン規則（必須）

#### UIデザイン基本方針
**見やすく使いやすいUIを実現し、対象年齢が若者の場合は最先端デザインを採用する**

##### 1. 見やすさ・使いやすさの基本原則
- **視認性の確保**: 十分なコントラスト比（4.5:1以上）を確保
- **タッチターゲットの最適化**: 最小44pxのタッチターゲットサイズ
- **情報の階層化**: 明確な情報階層でユーザビリティ向上
- **レスポンシブデザイン**: 様々な画面サイズに対応

##### 2. 若者向け最先端デザイン
- **モダンなカラーパレット**: グラデーション、ネオンアクセントカラー
- **ガラスモーフィズム**: 透明感のあるモダンなデザイン
- **ネオモーフィズム**: 立体的で触覚的なデザイン
- **スムーズなアニメーション**: マイクロインタラクション
- **カードベースレイアウト**: モダンな情報表示

##### 3. 実装例
```dart
// ✅ 推奨 - モダンなグラデーション
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [ColorName.gradientStart, ColorName.gradientEnd],
    ),
    borderRadius: BorderRadius.circular(16),
  ),
)

// ✅ 推奨 - ガラスモーフィズム
Container(
  decoration: BoxDecoration(
    color: ColorName.glassEffect,
    borderRadius: BorderRadius.circular(20),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: // コンテンツ
  ),
)
```

### 🔥 Firebase使用規則（必須）

#### Firebase必須サービス使用ルール
**全てのアプリで以下のFirebaseサービスを使用する必要があります：**

##### 1. Firebase Cloud Messaging (FCM) - 必須
```dart
// ✅ 必須 - FCM初期化
import 'package:firebase_messaging/firebase_messaging.dart';

// main.dartで初期化
await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
);
```

##### 2. Firebase Hosting - 必須
```dart
// ✅ 必須 - Web版アプリのホスティング
// firebase.jsonで設定
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
  }
}
```

##### 3. Firebase Analytics - 必須
```dart
// ✅ 必須 - Analytics初期化
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

##### 4. Firebase Crashlytics - 必須
```dart
// ✅ 必須 - Crashlytics初期化
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FlutterError.onError = (errorDetails) {
  FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
};
```

##### 5. Firebase設定ファイル必須
- `ios/Runner/GoogleService-Info.plist` - iOS用設定ファイル
- `lib/firebase_options.dart` - Flutter用設定ファイル

##### 6. Firebase使用時の必須チェックリスト
- [ ] Firebase プロジェクトが作成されている
- [ ] 必要なサービス（FCM, Hosting, Analytics, Crashlytics）が有効化されている
- [ ] 設定ファイルが正しく配置されている
- [ ] プッシュ通知の権限設定が完了している
- [ ] 環境変数でFirebase設定が管理されている

### 📱 AdBanner表示規則（必須）

#### 新規画面作成時のAdBanner追加ルール
**BaseScreen以外の全ての画面にAdBannerを表示する必要があります。**

##### 1. 新規画面作成時の必須チェック
- [ ] 作成する画面がBaseScreenかどうかを確認
- [ ] BaseScreen以外の場合、AdBannerを追加する

##### 2. AdBanner追加方法

###### Columnレイアウトの画面の場合
```dart
// ✅ 必須 - Columnのchildren配列の最後にAdBannerを追加
return Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // 既存のコンテンツ
        Expanded(
          child: // メインコンテンツ
        ),
        const AdBanner(), // ← 必須: 最後に追加
      ],
    ),
  ),
);
```

###### SingleChildScrollViewやListViewの画面の場合
```dart
// ✅ 必須 - body内のColumnでAdBannerを配置
// ⚠️ 注意: bottomNavigationBarにAdBannerを配置するとbodyが表示されなくなるバグあり
return Scaffold(
  body: Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: // メインコンテンツ
        ),
      ),
      const AdBanner(), // ← body内のColumnの最後に配置
    ],
  ),
);
```

##### 3. AdBanner追加対象画面
以下の画面には**必ず**AdBannerを追加してください：
- 設定系画面（ContactScreen、RequestScreen、LanguageSettingScreen等）
- ウォークスルー画面（WalkThroughScreen、WelcomeScreen等）
- サブスクリプション画面（SubscriptionSettingScreen）
- その他BaseScreen以外の全ての画面

##### 4. AdBanner追加対象外
以下の画面にはAdBannerを追加**しない**でください：
- BaseScreen（既にAdBannerが表示されている）

##### 5. 実装例
```dart
// ✅ 正しい実装例
import '../../import/component.dart'; // AdBannerのimport

class NewScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: BackIconHeader(title: l10n.screenTitle),
      body: Column(
        children: [
          Expanded(
            child: // メインコンテンツ
          ),
          const AdBanner(), // ← 必須
        ],
      ),
    );
  }
}
```

##### 6. FloatingActionButtonとの共存
AdBannerをbody内に配置した場合、FABはバナーと重なるため位置調整が必要：
```dart
return Scaffold(
  body: Column(
    children: [
      Expanded(child: /* メインコンテンツ */),
      const AdBanner(),
    ],
  ),
  floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 100), // バナーの高さ分上に移動
    child: FloatingActionButton(
      onPressed: () { /* ... */ },
      child: Icon(Icons.add),
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);
```

### ✅ 実装完了チェックリスト

実装完了前に以下をすべて確認してください。

#### 1. 静的解析（必須）
- [ ] `flutter analyze` でエラー・警告・info 0件（0 issues found!）
- [ ] 0 issues達成後、自動的にコミット・Pushを実行
  ```bash
  git add .
  git commit -m "fix: resolve all warnings and infos - achieve 0 issues ✅"
  git push
  ```

#### 2. 品質ルール準拠（必須）
詳細は `.claude/commands/release/step/10-quality-rules-check.md` を参照:
- [ ] Barrel Import規則準拠（直接import禁止）
- [ ] コンポーネント使用規則準拠（禁止コンポーネント0件）
- [ ] 色管理ルール準拠（`make check-color-usage` でエラーなし）
- [ ] ルート定義一元化（route.dart以外でのルート定義禁止）
- [ ] Snackbar使用規則準拠（SnackbarUtility使用）
- [ ] 例外処理規則準拠（on句必須）
- [ ] 多言語化対応（l10n使用、直接文字列禁止）
- [ ] メソッドパラメータ規則（required修飾子使用）
- [ ] Import順序準拠（4セクション順序）
- [ ] const修飾子使用（静的Widgetに必須）
- [ ] **UIデザイン規則準拠（見やすさ・使いやすさ、若者向け最先端デザイン）**
- [ ] **Firebase使用規則準拠（FCM, Hosting, Analytics, Crashlytics必須）**
- [ ] **AdBanner表示規則準拠（BaseScreen以外の全画面にAdBanner追加）**

#### 3. 実装方針確認（必須）
- [ ] 既存パターンを確認し、同じパターンで実装
- [ ] 新しいプロパティやメソッドを追加せず、既存のものを使用
- [ ] 勝手に独自の実装を作っていない
- [ ] 品質維持のため全チェック項目を実行
- [ ] 未使用のインポートや変数を削除
- [ ] **UIデザイン規則の適用（見やすさ・使いやすさ、若者向け最先端デザイン）**
- [ ] **Firebase必須サービス（FCM, Hosting, Analytics, Crashlytics）の設定完了**
- [ ] **新規画面作成時にAdBanner追加ルールを適用**

#### 4. 最終確認
- [ ] `make check-ready` で全チェック合格
- [ ] すべてのテストがパス
- [ ] **UIデザイン規則の適用確認（見やすさ・使いやすさ、若者向け最先端デザイン）**
- [ ] **Firebase必須サービス（FCM, Hosting, Analytics, Crashlytics）が正常に動作することを確認**
- [ ] **BaseScreen以外の全画面でAdBannerが表示されることを確認**

---

## 🤖 自動チェックコマンド

全12項目のうち10項目は自動チェック可能です。

### 全チェック実行

```bash
# 推奨: 1コマンドで全10項目チェック
make check-quality-rules-full
```

**所要時間:** 1-2分
**チェック項目:** 10項目自動 + 2項目手動確認

---

### 個別チェックコマンド

| コマンド | チェック内容 | 違反時の動作 |
|---------|------------|------------|
| `make check-color-usage` | 色管理ルール | ❌ エラー終了 |
| `make check-barrel-import` | Barrel Import規則 | ❌ エラー終了 |
| `make check-text-usage` | Text()使用規則 | ❌ エラー終了 |
| `make check-i18n-strict` | 多言語化対応 | ❌ エラー終了 |
| `make check-component-usage` | コンポーネント使用規則 | ❌ エラー終了 |
| `make check-logger-usage` | logger使用規則 | ❌ エラー終了 |
| `make check-exception-handling` | 例外処理規則 | ❌ エラー終了 |
| `make check-switch-statements` | Switch文規則 | ⚠️ 警告表示 |
| `make check-ready` | format/analyze/test | ❌ エラー終了 |

---

### 使い分け

**開発中の即座なフィードバック:**
```bash
# コミット前に実行
make check-quality-rules-full
```

**特定のルールだけチェック:**
```bash
# Text()使用だけチェック
make check-text-usage

# 多言語化対応だけチェック
make check-i18n-strict
```

**CI/CD統合:**
```yaml
# .github/workflows/quality-check.yml
- name: Quality Rules Check
  run: make check-quality-rules-full
```

---

### 手動確認が必要な2項目

以下は自動化が困難なため、手動確認が必要:

1. **ルート定義一元化** - `lib/route/route.dart` の構造確認
2. **既存パターン理解** - プロジェクト固有の実装パターン理解（通常はスキップ可）

---

### 前提条件

**ripgrep (rg) のインストール:**
```bash
# macOS
brew install ripgrep

# 確認
rg --version
```

**注:** `rg` がない場合、makeコマンド実行時にエラーメッセージが表示されます。

---

## 多言語（l10n）翻訳ルール（必須）

### 🔴 39言語全て翻訳すること（スキップ禁止）

新しいARBキーを追加した場合、**39言語全てを翻訳する**。主要10言語だけで済ませてはいけない。

```bash
# 1. en/ja のARBにキーを追加
# 2. 全言語に同期
make sync-l10n

# 3. 全39言語を翻訳（英語値のまま残さない）
# en, ja は手動で追加済み
# 残り37言語: zh, zh_Hant, ko, de, fr, fr_CA, es, es_MX, pt, pt_PT,
#   it, hi, ar, nl, pl, ru, sv, da, fi, no, cs, sk, hu, ro, ca,
#   el, he, hr, id, ms, th, tr, uk, vi, en_AU, en_CA, en_GB
```

### 翻訳基準
- 英語バリアント（en_AU, en_CA, en_GB）はスペルを地域に合わせる（例: Travelling for en_GB）
- `spotNameHint` は各言語で有名なランドマーク名を使う
- `{count}` 等のプレースホルダーはそのまま維持
- `@` プレフィックスのメタデータキーは変更しない
