---
description: App Store用スクリーンショット生成（39言語・195枚）- AI画面選定＋コード自動生成
---

# Step 16a: iOS Screenshot生成（AI駆動方式）

<!-- PROGRESS_COMMAND_ID: 16-ios-screenshot -->
<!-- PROGRESS_PHASE: phase5 -->
<!-- PROGRESS_NAME: iOSスクリーンショット生成 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->

## 📥 企画書参照（品質向上）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
[ -f "$SPEC_PATH" ] && echo "企画書あり → 差別化ポイントを強調する画面を優先選定"
```

企画書が存在する場合、差別化ポイントとMVP機能を読み取り、「アプリの価値が最も伝わる画面」を優先的にスクショ対象に選定する。

## 📋 CEO確認ポイント（完了時に必ず実行）

RELEASE_CHECKLIST.md の「CEO確認ポイント」セクションに以下を追記する:
```
- [ ] Step 16: スクショのビジュアル確認
```

---

## 概要

このコマンドはAIがプロジェクトを分析し、**App Storeでアピールすべき5画面を自動選定**してスクリーンショットテストコードを生成します。タブを順番にタップするだけの旧方式とは異なり、アプリのコア価値・差別化ポイントを最大限に示す画面を選びます。

---

## Claude Code 実行指示

以下のStepを順番に実行してください。

---

### Step 1: プロジェクト画面分析

以下のファイルを読み込み、このアプリの画面構成を把握する。

```bash
# ルート一覧（GoRouter）
cat lib/route/route.dart

# タブ構成・ベース画面
cat lib/screen/base_screen.dart

# 各画面ファイルの一覧
find lib/screen -name "*.dart" | sort

# 各画面の先頭30行を確認
for f in $(find lib/screen -name "*.dart" | sort); do
  echo "=== $f ==="
  head -30 "$f"
  echo ""
done

# 要件定義（存在する場合）
[ -f docs/project/requirements.md ] && cat docs/project/requirements.md || echo "requirements.md not found"
```

**この分析で把握すべき情報:**
- 全画面の一覧と各画面の主な機能・UI要素
- タブ構成（BottomNavigationBar のアイコン・ラベル）
- GoRouterで定義されたルート画面（サブページ含む）
- アプリのコア機能（課金、AI、統計、コンテンツ等）

---

### Step 2: App Store用5画面の選定と提案

分析結果をもとに、以下の評価軸でスコアリングして**5枚の画面**を選定する。

| 評価軸 | 説明 | 重み |
|--------|------|------|
| コア価値度 | そのアプリが解決する課題を最もよく体現している | 高 |
| 視覚的魅力 | グラフ・カード・画像・カラフルなUIなど視覚的要素が多い | 高 |
| 差別化 | ライバルアプリにない固有機能を示している | 中 |
| 初見インパクト | 「使ってみたい」と思わせる場面 | 中 |
| 到達可能性 | テストで再現しやすい（複雑な操作が不要） | 低 |

**重要な選定ルール:**
- タブ画面は「候補の一つ」に過ぎない。サブスク画面・詳細画面・AIチャット画面・モーダル・BottomSheet等も積極的に評価対象とすること
- ホーム画面（01-home）は必ず含める
- 設定画面だけで複数枚を埋めない
- テンプレートのままの「SettingScreen」が複数タブに表示されている場合は、そのタブを避けて他の画面を優先する

**ユーザーへの提案形式:**

```
## 📸 App Store スクリーンショット 選定結果

| # | 画面名 | ファイル | 選定理由 | 遷移方法 |
|---|--------|---------|---------|---------|
| 01 | ホーム画面 | lib/screen/home/home_screen.dart | ... | BottomNavigationBar タブ0 |
| 02 | ... | ... | ... | ... |
| 03 | ... | ... | ... | ... |
| 04 | ... | ... | ... | ... |
| 05 | ... | ... | ... | ... |

この選定でよろしいですか？変更したい場合はお知らせください。
```

ユーザーの確認後、Step 3 に進む。

---

### Step 3: テストコードの生成

選定した5画面をもとに、以下の2ファイルを生成・上書きする。

#### ⚠️ モックデータの注入（必須）

スクリーンショットは**データが入った「使用中の状態」**を撮る必要がある。空の状態では App Store でのアピール力がゼロになる。

**生成前にプロジェクトを分析して以下を特定すること:**

```bash
# 1. ウォークスルー完了フラグのキー名を確認
grep -r "walk_through\|onboarding\|isFirst" lib/provider/ lib/utility/ lib/hook/ --include="*.dart" -l

# 2. 選定した各画面のデータプロバイダーを確認
grep -r "ref\.watch\|ref\.read" lib/screen/ --include="*.dart" | grep -v "theme\|l10n\|navigator"

# 3. モデルクラスの確認（モックデータ生成に使用）
find lib/model -name "*.dart" | head -20
```

**モックデータ注入の方針:**

| 対象 | 方法 |
|------|------|
| ウォークスルー完了フラグ | `SharedPreferences.setMockInitialValues({'walk_through_completed': true, ...})` |
| Firestoreからのデータ | `streamProvider.overrideWith((_) => Stream.value([mockItem1, mockItem2, ...]))` |
| FutureProvider のデータ | `futureProvider.overrideWith((_) async => [mockItem1, mockItem2, ...])` |
| 認証状態 | `authStateProvider.overrideWith(...)` でログイン済みユーザーを返す |

**モックデータの品質ルール:**
- アプリのジャンルに合った**リアルなサンプルデータ**を作成する（「テスト」「サンプル」等の文言は使わない）
- リスト表示は**3〜5件**のデータを用意して画面を埋める
- 日付・数値・テキストは**それらしい具体的な値**にする
- 言語ごとにデータを切り替える必要はない（UIの言語だけ変わればOK）

---

#### 3a. `integration_test/screenshot_test_all_locales.dart` を生成

以下のテンプレートに従い、`# --- SCENARIOS ---` の部分を選定画面に応じた遷移コードに、`# --- MOCK DATA ---` の部分をプロジェクト分析結果に基づくモックデータに置き換えてファイルを出力する。

**遷移コードの選択基準:**

| 画面タイプ | 遷移方法 |
|-----------|---------|
| BottomNavigationBar のタブ画面 | `tester.tap(find.byIcon(Icons.xxx).first)` |
| GoRouter で `.push()` が必要な画面 | `unawaited(navigatorKey.currentContext!.push(const XxxRoute()))` |
| BottomSheet / モーダル | ボタンやListTileをタップ |
| IndexedStack 内のサブ画面 | 親タブに遷移後、内部ウィジェットをタップ |

**生成するファイルの構造:**

```dart
// ignore_for_file: avoid_redundant_argument_values, unawaited_futures

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/firebase_options.dart';
import 'package:flutter_template/import/screen.dart';
import 'package:flutter_template/import/utility.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late final String screenshotsBasePath;

  setUpAll(() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    final currentPath = Directory.current.path;
    // ignore: avoid_print
    print('🔍 Current directory: $currentPath');

    final String projectRoot;
    if (currentPath.isEmpty || currentPath == '/') {
      projectRoot = Platform.environment['PWD'] ?? Directory.current.path;
      // ignore: avoid_print
      print('⚠️  Using fallback project root: $projectRoot');
    } else {
      projectRoot = currentPath;
    }

    screenshotsBasePath = '$projectRoot/screenshots';
    // ignore: avoid_print
    print('📁 Screenshots will be saved to: $screenshotsBasePath');

    final screenshotsDir = Directory(screenshotsBasePath);
    if (screenshotsDir.existsSync()) {
      screenshotsDir.deleteSync(recursive: true);
    }
    screenshotsDir.createSync(recursive: true);
  });

  // App Store Connect対応39言語
  final locales = [
    const Locale('en', 'US'),
    const Locale('ja'),
    const Locale('zh', 'Hans'),
    const Locale('ko'),
    const Locale('de', 'DE'),
    const Locale('fr', 'FR'),
    const Locale('pt', 'BR'),
    const Locale('es', 'ES'),
    const Locale('hi'),
    const Locale('it'),
    const Locale('ar', 'SA'),
    const Locale('ca'),
    const Locale('zh', 'Hant'),
    const Locale('hr'),
    const Locale('cs'),
    const Locale('da'),
    const Locale('nl', 'NL'),
    const Locale('en', 'AU'),
    const Locale('en', 'CA'),
    const Locale('en', 'GB'),
    const Locale('fi'),
    const Locale('fr', 'CA'),
    const Locale('el'),
    const Locale('he'),
    const Locale('hu'),
    const Locale('id'),
    const Locale('ms'),
    const Locale('no'),
    const Locale('pl'),
    const Locale('pt', 'PT'),
    const Locale('ro'),
    const Locale('ru'),
    const Locale('sk'),
    const Locale('es', 'MX'),
    const Locale('sv'),
    const Locale('th'),
    const Locale('tr'),
    const Locale('uk'),
    const Locale('vi'),
  ];

  group('Screenshot capture for all locales', () {
    for (final locale in locales) {
      testWidgets(
        'Capture screenshots for $locale',
        (WidgetTester tester) async {
          final localeName = locale.countryCode != null
              ? '${locale.languageCode}-${locale.countryCode}'
              : locale.languageCode;
          final localeDir = Directory('$screenshotsBasePath/$localeName');
          if (!localeDir.existsSync()) {
            localeDir.createSync(recursive: true);
          }

          // ignore: avoid_print
          print('📸 Capturing screenshots for $localeName');

          // --- MOCK DATA ---
          // ウォークスルー完了フラグ（実際のキー名はプロジェクトに合わせて変更）
          SharedPreferences.setMockInitialValues({
            'walk_through_completed': true,
            // 他に必要なフラグがあればここに追加
            // 例: 'is_onboarding_done': true,
          });
          final prefs = await SharedPreferences.getInstance();
          // --- END MOCK DATA ---

          final navigatorKey = GlobalKey<NavigatorState>();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                sharedPreferencesProvider.overrideWithValue(prefs),
                aiServiceProvider.overrideWithValue(GeminiService()),
                adConfigProvider.overrideWithValue(
                  AdConfig(
                    bannerAdUnitId: Env.iOSBannerAdUnitId,
                    interstitialAdUnitId: Env.iOSInterstitialAdUnitId,
                    rewardedAdUnitId: Env.iOSRewardedAdUnitId,
                    appOpenAdUnitId: Env.iOSAppOpenAdUnitId,
                    minIntervalSeconds: Env.adMinIntervalSeconds,
                    dailyMaxInterstitialCount: Env.adDailyMaxInterstitialCount,
                    dailyMaxRewardedCount: Env.adDailyMaxRewardedCount,
                    sessionMaxInterstitialCount:
                        Env.adSessionMaxInterstitialCount,
                    isProduction: !isNotProduction(),
                  ),
                ),
                ratingConfigProvider.overrideWithValue(
                  const RatingConfig(
                    storeReviewUrl: ExternalPageList.iosAppReviewLink,
                  ),
                ),
                updateConfigProvider.overrideWithValue(
                  const UpdateConfig(
                    minSupportedVersion: minSupportedVersion,
                    storeAppUrl: ExternalPageList.iosAppLink,
                  ),
                ),
                revenueCatInitializedProvider.overrideWithValue(false),
                // --- MOCK PROVIDERS ---
                // 選定した画面で使われるデータプロバイダーをここでオーバーライドする
                // 例（記録系アプリ）:
                // itemListProvider.overrideWith((_) => Stream.value([
                //   Item(id: '1', title: 'スイーツ日和', date: DateTime(2025, 3, 1), ...),
                //   Item(id: '2', title: 'カフェ巡り', date: DateTime(2025, 2, 28), ...),
                //   Item(id: '3', title: 'チョコレートケーキ', date: DateTime(2025, 2, 25), ...),
                // ])),
                // 例（統計・グラフ系）:
                // statsProvider.overrideWith((_) async => Stats(total: 42, streak: 7, ...)),
                // --- END MOCK PROVIDERS ---
              ],
              child: MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                home: Builder(
                  builder: (context) => const BaseScreen(),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle(const Duration(seconds: 3));

          Future<void> takeScreenshot(String name) async {
            await binding.convertFlutterSurfaceToImage();
            await tester.pumpAndSettle();
            final screenshot = await binding.takeScreenshot(name);
            final file = File('$screenshotsBasePath/$localeName/$name.png');
            await file.writeAsBytes(screenshot);
            // ignore: avoid_print
            print('  ✅ $localeName/$name.png');
          }

          // --- SCENARIOS ---
          // ここをAIが選定した5画面の遷移コードに置き換える
          // 例:
          // 01: ホーム画面（タブ0）
          await takeScreenshot('01-home');

          // 02: [選定画面2] - 遷移コードをここに記述
          // await tester.tap(find.byIcon(Icons.explore_outlined).first);
          // await tester.pumpAndSettle(const Duration(seconds: 2));
          // await takeScreenshot('02-xxx');

          // 03: [選定画面3]
          // ...

          // 04: [選定画面4]
          // ...

          // 05: [選定画面5]
          // ...
          // --- END SCENARIOS ---

          // ignore: avoid_print
          print('✅ Completed: $localeName');
        },
        timeout: const Timeout(Duration(minutes: 60)),
      );
    }
  });
}
```

**重要**: `# --- SCENARIOS ---` セクションを実際のシナリオコードで置き換えること。コメント行は残さず、選定した5画面の実際の遷移コードを記述すること。

#### 3b. `integration_test/screenshot_test_quick.dart` を生成

`screenshot_test_all_locales.dart` と同じシナリオコードを使用し、`locales` リストを `ja` と `en-US` のみに変更する。

```dart
// integration_test/screenshot_test_quick.dart
// （screenshot_test_all_locales.dart と同一ロジック、言語を2つのみに絞る）

// locales の部分のみ変更:
final locales = [
  const Locale('ja'),        // Japanese
  const Locale('en', 'US'), // English (US)
];

// group名も変更:
group('Quick screenshot capture for testing', () {
```

他はすべて `screenshot_test_all_locales.dart` と同一のコードにする。

---

### Step 4: シミュレーターの準備

```bash
# iPhone 16 Pro Max シミュレーターの確認
SIMULATOR_ID=$(xcrun simctl list devices | grep "iPhone 16 Pro Max" | grep -v "unavailable" | head -1 | grep -o "[0-9A-F-]\{36\}")

if [ -z "$SIMULATOR_ID" ]; then
  echo "❌ iPhone 16 Pro Max simulator not found"
  echo "📥 Creating simulator..."
  xcrun simctl create "iPhone 16 Pro Max" "com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro-Max"
  SIMULATOR_ID=$(xcrun simctl list devices | grep "iPhone 16 Pro Max" | grep -v "unavailable" | head -1 | grep -o "[0-9A-F-]\{36\}")
else
  echo "✅ Simulator found: $SIMULATOR_ID"
fi

# シミュレーターを起動
echo "🚀 Booting simulator..."
xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || echo "Already booted"
open -a Simulator
sleep 5
```

---

### Step 5: 1言語で動作確認

まず `screenshot_test_quick.dart` で日本語のみ動作確認する。

```bash
# クイック版で動作確認（ja + en-US）
flutter test integration_test/screenshot_test_quick.dart \
  --dart-define=FLUTTER_TEST_ENV=test

# 生成されたスクリーンショットを確認
ls -lh screenshots/ja/
echo ""
echo "期待されるファイル数: 5枚"
echo "実際のファイル数: $(ls screenshots/ja/*.png 2>/dev/null | wc -l | tr -d ' ')枚"
```

**確認ポイント:**
- ✅ 選定した5画面のスクリーンショットが生成されている
- ✅ 各画面が正しく表示されている（真っ白・クラッシュがない）
- ✅ **データが入った状態で表示されている（空リスト・空グラフでない）**
- ✅ **ウォークスルー画面が出ていない（BaseScreen が表示されている）**
- ✅ テストが最後まで完走した

**⚠️ 動作確認で問題が出た場合:**
- 真っ白な画面 → `pumpAndSettle` の待機時間を増やす
- 特定の画面に遷移できない → 遷移コードを修正してStep 3に戻る
- クラッシュ → エラーログを確認して原因を修正

---

### Step 6: 全言語で本番実行

動作確認完了後、全39言語で実行する。

```bash
flutter test integration_test/screenshot_test_all_locales.dart \
  --dart-define=FLUTTER_TEST_ENV=test
```

**所要時間**: 約10-30分（言語数・画面数による）

進捗確認:
```bash
watch -n 5 'echo "生成済み: $(find screenshots -name "*.png" | wc -l | tr -d " ")枚 / 195枚"'
```

---

### Step 7: 完了確認

```bash
FINAL_COUNT=$(find screenshots -name "*.png" -not -name "background.png" -not -name "*_framed.png" -not -name "*_ai.png" 2>/dev/null | wc -l | tr -d ' ')
LOCALE_COUNT=$(ls -d screenshots/*/ 2>/dev/null | wc -l | tr -d ' ')

echo "📊 生成枚数: $FINAL_COUNT"
echo "📊 言語数: $LOCALE_COUNT"

# サンプル確認
open screenshots/ja/01-home.png 2>/dev/null || echo "screenshots/ja/01-home.png を確認してください"
open screenshots/en-US/01-home.png 2>/dev/null || echo "screenshots/en-US/01-home.png を確認してください"
```

---

## ⚠️ App Store Connect対応ロケールコード

スクリーンショットのディレクトリ名は、**App Store Connectが受け入れるロケールコードに厳密に従う**必要があります。

| 言語 | 正しいコード | NGコード |
|------|------------|---------|
| アラビア語 | `ar-SA` | ❌ `ar` |
| 英語 | `en-US`, `en-GB`, `en-AU`, `en-CA` | ❌ `en` |
| 中国語簡体字 | `zh-Hans` | ❌ `zh` |
| 中国語繁体字 | `zh-Hant` | ❌ `zh-TW` |
| ドイツ語 | `de-DE` | ❌ `de` |
| フランス語 | `fr-FR`, `fr-CA` | ❌ `fr` |
| ポルトガル語 | `pt-BR`, `pt-PT` | ❌ `pt` |
| スペイン語 | `es-ES`, `es-MX` | ❌ `es` |
| オランダ語 | `nl-NL` | ❌ `nl` |
| 日本語 | `ja` | （国コード不要） |

---

## トラブルシューティング

### 真っ白なスクリーンショット

待機時間を増やす:
```dart
await tester.pumpAndSettle(const Duration(seconds: 5));
```

### Navigator.push でハングする

```dart
import 'dart:async';

// NG: Navigator.push を await する
// OK: unawaited で起動してから pumpAndSettle
unawaited(
  navigatorKey.currentContext!.push(const XxxRoute()),
);
await tester.pumpAndSettle(const Duration(seconds: 3));
```

### データが空（空リスト・空グラフ）で表示される

該当画面のデータプロバイダーを特定して override を追加する:

```dart
// Step 3 のコード分析コマンドで特定したプロバイダーを override
// Stream 系（Firestore など）
yourListProvider.overrideWith((_) => Stream.value([
  YourModel(id: '1', title: 'サンプルタイトル1', date: DateTime(2025, 3, 1)),
  YourModel(id: '2', title: 'サンプルタイトル2', date: DateTime(2025, 2, 20)),
  YourModel(id: '3', title: 'サンプルタイトル3', date: DateTime(2025, 2, 15)),
])),

// Future 系
yourStatsProvider.overrideWith((_) async => YourStats(total: 42, streak: 7)),
```

### ウォークスルー画面が出てしまう

`SharedPreferences.setMockInitialValues` に実際のキーを確認して追加する:

```bash
# ウォークスルー完了フラグのキー名を検索
grep -r "SharedPreferences\|prefs\.set" lib/provider/ lib/hook/ --include="*.dart"
```

```dart
SharedPreferences.setMockInitialValues({
  'actual_key_name': true,  // 実際のキー名に変更
});
```

### エラーダイアログが出る

```dart
// 閉じるボタンがあれば先に閉じる
final closeBtn = find.text('閉じる');
if (tester.any(closeBtn)) {
  await tester.tap(closeBtn.first);
  await tester.pumpAndSettle();
}
```

### タブアイコンが見つからない

```dart
// byIcon の代わりに find.ancestor を使う
final tabFinder = find.ancestor(
  of: find.byIcon(Icons.explore_outlined),
  matching: find.byType(InkResponse),
);
if (tester.any(tabFinder)) {
  await tester.tap(tabFinder.first);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}
```

---

## 完了時アクション

```markdown
# 更新対象: .claude/commands/release/RELEASE_CHECKLIST.md
- [ ] → - [x] **`/release:step:16a-ios-screenshot`**
```

## 次のステップ

```bash
/release:step:16b-frame-auto
```

生成したスクリーンショットにフレームを適用します。
