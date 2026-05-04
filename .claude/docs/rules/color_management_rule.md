# 🎨 色管理ルール (Color Management Rule)

> **📖 このドキュメントが色管理に関する唯一の信頼できる情報源です**
>
> すべての色使用はここで定義されたルールに従ってください。

## 🚀 クイックスタート

```bash
# 1. ルールチェック
make check-color-usage

# 2. 色の生成
make generate-colors

# 3. ヘルプ表示
make help-color
```

**🎯 基本ルール**: `Colors.` 直接使用禁止 → 優先順位に従って色を選択

## 📋 目次

1. [基本方針](#基本方針)
2. [色の優先順位](#色の優先順位)
3. [禁止事項](#禁止事項)
4. [推奨事項](#推奨事項)
5. [色の定義方法](#色の定義方法)
6. [使用方法](#使用方法)
7. [検証方法](#検証方法)
8. [例外規則](#例外規則)
9. [移行ガイド](#移行ガイド)

---

## 🎯 基本方針

### 色の一元管理

**すべての色は `assets/color/colors.xml` で定義し、Flutter コードで直接 `Colors.` を使用することを禁止する**

### 目的

- **統一性**: アプリ全体で一貫した色使用
- **保守性**: 色の変更が一箇所で完結
- **テーマ対応**: ライト/ダークテーマの統一管理
- **デザインシステム**: デザイナーとの協業促進

---

## 🥇 色の優先順位

### 使用する色の選択基準

| 優先順位 | 色システム | 用途 | 特徴 |
|---------|-----------|------|------|
| **1位** | `AppleSemanticColors` | 汎用的なUI要素 | iOS HIG準拠、ダーク/ライトモード自動対応、アクセシビリティ対応 |
| **2位** | `theme.appColors.*` | アプリ固有のブランド色 | テーマ対応、Riverpod経由 |
| **3位** | `ColorName.*` | 静的な色指定 | テーマなしコンポーネント用 |

### AppleSemanticColors（第一優先）

**汎用的なUI要素には `AppleSemanticColors` を使用する**

```dart
import 'package:flutter_foundation/flutter_foundation.dart';

// ✅ 推奨 - 汎用的なUI要素
Scaffold(
  backgroundColor: AppleSemanticColors.background(context),
)

// ✅ 推奨 - ラベル色
ThemeText(
  text: '補助テキスト',
  color: AppleSemanticColors.secondaryLabel(context),
)

// ✅ 推奨 - セパレーター
Divider(
  color: AppleSemanticColors.separator(context),
)
```

**AppleSemanticColorsの利点:**
- **iOS Human Interface Guidelines準拠**: Appleのデザインガイドラインに沿った色
- **ダーク/ライトモード自動対応**: システム設定に自動追従
- **アクセシビリティ対応**: コントラスト比が保証されている
- **システム統一感**: OSのネイティブ要素と調和

**利用可能な主要色:**
| メソッド | 用途 |
|---------|------|
| `background(context)` | 画面背景 |
| `secondaryBackground(context)` | セカンダリ背景 |
| `label(context)` | プライマリラベル |
| `secondaryLabel(context)` | セカンダリラベル |
| `tertiaryLabel(context)` | 第三ラベル（非アクティブ要素など） |
| `separator(context)` | セパレーター/区切り線 |
| `fill(context)` | 塗りつぶし |

### theme.appColors（第二優先）

**アプリ固有のブランド色には `theme.appColors` を使用する**

```dart
// ✅ 推奨 - ブランドアクセント（グラデーション・ヘッダー・カラーバー）
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [theme.appColors.main, theme.appColors.main.withValues(alpha: 0.75)],
    ),
  ),
)

// ✅ 推奨 - テキスト・アイコン（高コントラスト）
ThemeText(
  text: 'タイトル',
  color: theme.appColors.primary,
)
```

#### ⚠️ `main` と `primary` の使い分け（重要）

| プロパティ | 実際の色 | 意味 | 正しい用途 | ❌ 誤った用途 |
|-----------|---------|------|-----------|------------|
| `theme.appColors.main` | ブランドアクセント色（プロジェクト毎に異なる） | ブランドアクセント色 | グラデーション、カラーヘッダー、アクセントバー | テキストカラー |
| `theme.appColors.primary` | `#212121`（ほぼ黒） | テキスト・アイコン色 | テキスト、アイコン、ダークな前景要素 | グラデーション背景、カラーUI要素 |

```dart
// ✅ 正しい使い方
// 背景グラデーション → main（ブランドアクセント）
gradient: LinearGradient(
  colors: [theme.appColors.main, theme.appColors.main.withValues(alpha: 0.75)],
)

// テキストカラー → primary（高コントラスト黒）
ThemeText(text: 'タイトル', color: theme.appColors.primary)

// ❌ 間違った使い方
// グラデーション背景に primary (#212121) を使うと真っ黒・暗鬱になる
gradient: LinearGradient(
  colors: [theme.appColors.primary, theme.appColors.primary.withValues(alpha: 0.75)],
)
```

#### ❌ 禁止: 以下の `theme.appColors` プロパティは使用しない

```dart
// ❌ 禁止 - AppleSemanticColors を使用すること
theme.appColors.background   // → AppleSemanticColors.background(context)
theme.appColors.black        // → AppleSemanticColors.label(context)
theme.appColors.white        // → AppleSemanticColors.background(context)
theme.appColors.grey         // → AppleSemanticColors.secondaryLabel(context)
theme.appColors.secondary    // → AppleSemanticColors.secondaryLabel(context)
```

### ColorName（第三優先）

**テーマなしコンポーネントでは `ColorName` を使用する**

```dart
// ✅ 推奨 - 静的な色指定
const Icon(
  Icons.star,
  color: ColorName.starGold,
)
```

---

## ❌ 禁止事項

### 1. Material Colors の直接使用

```dart
// ❌ 禁止 - Material Colors の直接使用
Container(
  color: Colors.white,
  child: Text(
    'テキスト',
    style: TextStyle(color: Colors.black),
  ),
)

// ❌ 禁止 - 透明度指定も含む
BoxShadow(
  color: Colors.black.withOpacity(0.5),
  blurRadius: 4,
)

// ❌ 禁止 - withValues も含む
Container(
  color: Colors.red.withValues(alpha: 0.8),
)
```

### 2. Color クラスの直接インスタンス化

```dart
// ❌ 禁止 - 16進数カラーコード
Container(color: Color(0xFF000000))
Container(color: Color.fromRGBO(255, 255, 255, 1.0))
Container(color: Color.fromARGB(255, 255, 255, 255))
```

### 3. ハードコードされた色値

```dart
// ❌ 禁止 - ハードコードされた色
const Color primaryColor = Color(0xFF2196F3);
final backgroundColor = Color.fromRGBO(248, 248, 248, 1.0);
```

---

## ✅ 推奨事項

### 1. ColorName の使用

```dart
// ✅ 推奨 - ColorName を使用（テーマなしコンポーネント）
Container(
  color: ColorName.white,
  child: Text(
    'テキスト',
    style: TextStyle(color: ColorName.black),
  ),
)

// ✅ 推奨 - 透明度指定
BoxShadow(
  color: ColorName.black.withValues(alpha: 0.5),
  blurRadius: 4,
)
```

### 2. AppColors の使用

```dart
// ✅ 推奨 - AppColors を使用（テーマありコンポーネント）
Container(
  color: theme.appColors.background,
  child: ThemeText(
    text: 'テキスト',
    color: theme.appColors.primary,
    style: theme.textTheme.bodyMedium,
  ),
)
```

### 3. 透明度の適切な指定

```dart
// ✅ 推奨 - withValues を使用
Container(
  decoration: BoxDecoration(
    color: ColorName.primary.withValues(alpha: 0.8),
    boxShadow: [
      BoxShadow(
        color: ColorName.black.withValues(alpha: 0.1),
        blurRadius: 8,
      ),
    ],
  ),
)
```

---

## 🎨 色の定義方法

### colors.xml の構造

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- アプリのメインブランドカラー - プライマリーアクション、ボタン、ハイライトに使用 -->
    <color name="main">#2196F3</color>

    <!-- プライマリーカラー - メインの文字色、アイコン、重要な要素に使用 -->
    <color name="primary">#212121</color>

    <!-- プログレスバー、ローディングインジケーターに使用 -->
    <color name="progress">#2196F3</color>

    <!-- セカンダリ背景、カード背景、微妙な区切りに使用 -->
    <color name="blueGrey">#F5F5F5</color>

    <!-- アプリの基本背景色 -->
    <color name="backGround">#FFFFFF</color>

    <!-- ヘッダー、ナビゲーションバーの背景色 -->
    <color name="headerBackground">#FAFAFA</color>

    <!-- エラー状態、警告、削除アクションに使用 -->
    <color name="error">#F44336</color>

    <!-- アクセントカラー - セカンダリアクション、強調表示に使用 -->
    <color name="accent">#FF9800</color>

    <!-- セカンダリテキスト、サブタイトル、無効状態に使用 -->
    <color name="secondary">#757575</color>

    <!-- 成功状態、完了アクション、ポジティブフィードバックに使用 -->
    <color name="success">#4CAF50</color>

    <!-- 基本色 -->
    <color name="white">#FFFFFF</color>
    <color name="black">#000000</color>

    <!-- 透明度付きの色 -->
    <color name="white70">#B3FFFFFF</color>
    <color name="white38">#61FFFFFF</color>
    <color name="transparent">#00FFFFFF</color>

    <!-- 追加の色 -->
    <color name="grey">#9E9E9E</color>
    <color name="red">#F44336</color>
    <color name="orange">#FF9800</color>
    <color name="green">#4CAF50</color>
    <color name="blue">#2196F3</color>
    <color name="purple">#9C27B0</color>
    <color name="yellow">#FFEB3B</color>
</resources>
```

### 色の命名規則

1. **用途を表す名前**: `primary`, `secondary`, `background`
2. **状態を表す名前**: `error`, `success`, `warning`
3. **透明度付きの色**: `white70` (70%不透明度)
4. **特別な色**: `transparent` (完全透明)

### 新しい色の追加手順

1. **colors.xml に色を定義**
   ```xml
   <!-- 新しい色の説明コメント -->
   <color name="newColor">#RRGGBB</color>
   ```

2. **build_runner で生成**
   ```bash
   fvm flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **AppColors クラスに追加**
   ```dart
   /// 新しい色の説明
   final Color newColor;

   // ファクトリーメソッドで ColorName.newColor を指定
   newColor: ColorName.newColor,
   ```

---

## 🔧 使用方法

### 1. 基本的な使用

```dart
// ColorName を直接使用
import '../import/gen.dart';

Container(
  color: ColorName.primary,
  child: Text(
    'テキスト',
    style: TextStyle(color: ColorName.white),
  ),
)
```

### 2. テーマコンポーネントでの使用

```dart
// AppTheme を通じて使用
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return Container(
      color: theme.appColors.background,
      child: ThemeText(
        text: 'テキスト',
        color: theme.appColors.primary,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
```

### 3. 透明度の指定

```dart
// withValues を使用
Container(
  decoration: BoxDecoration(
    color: ColorName.primary.withValues(alpha: 0.8),
    border: Border.all(
      color: ColorName.grey.withValues(alpha: 0.3),
    ),
  ),
)
```

### 4. グラデーション

```dart
// LinearGradient での使用
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        ColorName.primary,
        ColorName.accent,
      ],
    ),
  ),
)
```

---

## 🔍 検証方法

### 1. 静的解析での検出

```bash
# Colors. の直接使用をチェック
grep -r "Colors\." lib/ --exclude-dir=gen

# 16進数カラーコードをチェック
grep -r "Color(0x" lib/ --exclude-dir=gen

# Color.fromRGBO をチェック
grep -r "Color\.from" lib/ --exclude-dir=gen
```

### 2. IDE での設定

**VSCode settings.json**
```json
{
  "files.associations": {
    "*.dart": "dart"
  },
  "dart.analysisExcludedFolders": [
    "lib/gen"
  ]
}
```

### 3. プリコミットフック

```bash
#!/bin/bash
# pre-commit hook

echo "色管理ルールチェック中..."

# Colors. の直接使用をチェック
COLORS_USAGE=$(grep -r "Colors\." lib/ --exclude-dir=gen | wc -l)
if [ $COLORS_USAGE -gt 0 ]; then
  echo "❌ エラー: Colors. の直接使用が検出されました"
  grep -r "Colors\." lib/ --exclude-dir=gen
  echo "colors.xml で定義された ColorName を使用してください"
  exit 1
fi

# 16進数カラーコードをチェック
HEX_COLORS=$(grep -r "Color(0x" lib/ --exclude-dir=gen | wc -l)
if [ $HEX_COLORS -gt 0 ]; then
  echo "❌ エラー: 16進数カラーコードの直接使用が検出されました"
  grep -r "Color(0x" lib/ --exclude-dir=gen
  echo "colors.xml で定義された ColorName を使用してください"
  exit 1
fi

echo "✅ 色管理ルールチェック完了"
```

### 4. CI/CD での自動チェック

**GitHub Actions workflow**
```yaml
name: Color Management Check

on: [push, pull_request]

jobs:
  color-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check direct Colors usage
        run: |
          if grep -r "Colors\." lib/ --exclude-dir=gen; then
            echo "❌ Direct Colors usage found"
            exit 1
          fi

      - name: Check hex color codes
        run: |
          if grep -r "Color(0x" lib/ --exclude-dir=gen; then
            echo "❌ Direct hex color codes found"
            exit 1
          fi

      - name: Check Color.from usage
        run: |
          if grep -r "Color\.from" lib/ --exclude-dir=gen; then
            echo "❌ Direct Color.from usage found"
            exit 1
          fi
```

---

## 🚫 例外規則

### 1. 許可される Colors 使用

```dart
// ✅ 例外 - Colors.transparent は特別な定数として許可
// ただし、ColorName.transparent が利用可能な場合はそちらを優先
Colors.transparent  // 特別な場合のみ

// ✅ 例外 - システム色（カーソル色など）で代替がない場合
CupertinoTextField(
  cursorColor: CupertinoColors.activeBlue, // iOS システム色
)
```

### 2. サードパーティライブラリ

```dart
// ✅ 例外 - サードパーティライブラリが要求する場合
SomeThirdPartyWidget(
  themeData: ThemeData(
    primaryColor: ColorName.primary, // 変換して使用
  ),
)
```

### 3. テスト環境

```dart
// ✅ 例外 - テスト用の色（テストファイル内のみ）
// test/widget_test.dart などでのみ許可
testWidgets('色のテスト', (tester) async {
  await tester.pumpWidget(
    Container(color: Colors.red), // テスト用途のみ
  );
});
```

---

## 🔄 移行ガイド

### 1. 既存コードの移行手順

**Step 1: 色の特定**
```bash
# 現在使用されている色を特定
grep -r "Colors\." lib/ --exclude-dir=gen > colors_usage.txt
```

**Step 2: colors.xml に定義**
```xml
<!-- 特定された色を colors.xml に追加 -->
<color name="customColor">#RRGGBB</color>
```

**Step 3: build_runner 実行**
```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Step 4: コード置換**
```dart
// 置換前
color: Colors.blue

// 置換後
color: ColorName.blue
```

### 2. 一括置換スクリプト

```bash
#!/bin/bash
# colors_migration.sh

echo "Colors.の一括置換を開始..."

# よく使用される色の置換
find lib -name "*.dart" -not -path "*/gen/*" -exec sed -i '' 's/Colors\.white/ColorName.white/g' {} \;
find lib -name "*.dart" -not -path "*/gen/*" -exec sed -i '' 's/Colors\.black/ColorName.black/g' {} \;
find lib -name "*.dart" -not -path "*/gen/*" -exec sed -i '' 's/Colors\.red/ColorName.red/g' {} \;
find lib -name "*.dart" -not -path "*/gen/*" -exec sed -i '' 's/Colors\.blue/ColorName.blue/g' {} \;
find lib -name "*.dart" -not -path "*/gen/*" -exec sed -i '' 's/Colors\.green/ColorName.green/g' {} \;

echo "一括置換完了"
```

### 3. AppColors の拡張

```dart
// lib/theme/app_colors.dart
class AppColors {
  const AppColors({
    // 既存の色
    required this.primary,
    required this.background,

    // 新しく追加した色
    required this.customColor,
  });

  factory AppColors.light() {
    return const AppColors(
      // 既存の色
      primary: ColorName.primary,
      background: ColorName.backGround,

      // 新しく追加した色
      customColor: ColorName.customColor,
    );
  }

  // プロパティ定義
  final Color customColor;
}
```

---

## 📚 ベストプラクティス

### 1. 色の命名

```xml
<!-- ✅ 良い例 - 用途が明確 -->
<color name="primaryButton">#2196F3</color>
<color name="errorText">#F44336</color>
<color name="successBackground">#E8F5E8</color>

<!-- ❌ 悪い例 - 色名のみ -->
<color name="blue">#2196F3</color>
<color name="lightGray">#F0F0F0</color>
```

### 2. 透明度の管理

```xml
<!-- ✅ 推奨 - 透明度付きの色も定義 -->
<color name="overlay">#80000000</color>
<color name="divider">#1F000000</color>
<color name="shadow">#29000000</color>
```

### 3. セマンティックカラー

```xml
<!-- ✅ 推奨 - 意味のある色名 -->
<color name="textPrimary">#212121</color>
<color name="textSecondary">#757575</color>
<color name="textDisabled">#BDBDBD</color>

<color name="surfacePrimary">#FFFFFF</color>
<color name="surfaceSecondary">#F5F5F5</color>
```

---

## ✅ チェックリスト

### 開発時

- [ ] 新しい色は colors.xml で定義
- [ ] Colors. の直接使用なし
- [ ] 16進数カラーコードの直接使用なし
- [ ] 適切な透明度指定（withValues）
- [ ] import '../import/gen.dart' の追加

### コードレビュー時

- [ ] 色管理ルールに準拠
- [ ] ColorName または AppColors の使用
- [ ] 新しい色が適切に定義されている
- [ ] テーマ対応が考慮されている
- [ ] ドキュメントコメントの記述

### リリース前

- [ ] 静的解析での色使用チェック
- [ ] 全色が colors.xml で定義済み
- [ ] ライト/ダークテーマでの表示確認
- [ ] デザインシステムとの整合性確認

---

**この色管理ルールに従うことで、統一性と保守性の高い色使用を実現できます。** 🎨

---

## 🎨 UIデザインルール（必須）

### 基本方針
**見やすく使いやすいUIを実現し、対象年齢が若者の場合は最先端デザインを採用する**

### 1. 見やすさ・使いやすさの基本原則

#### 1.1 視認性の確保
```dart
// ✅ 推奨 - 十分なコントラスト比を確保
ThemeText(
  text: l10n.importantMessage,
  color: theme.appColors.primary, // 高コントラスト
  style: theme.textTheme.h30.bold(),
)

// ✅ 推奨 - 適切なフォントサイズ
ThemeText(
  text: l10n.bodyText,
  style: theme.textTheme.h30, // 読みやすいサイズ
)
```

#### 1.2 タッチターゲットの最適化
```dart
// ✅ 推奨 - 最小44px（11.0 * 4）のタッチターゲット
PrimaryButton(
  text: l10n.actionButton,
  width: getScreenSize(context).width * 0.8,
  height: 48, // 十分な高さ
  callback: () {},
)

// ✅ 推奨 - 適切な余白
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: ListTile(
    title: ThemeText(text: l10n.menuItem),
    onTap: () {},
  ),
)
```

#### 1.3 情報の階層化
```dart
// ✅ 推奨 - 明確な情報階層
Column(
  children: [
    ThemeText(
      text: l10n.mainTitle,
      style: theme.textTheme.h60.bold(), // 最上位
      color: theme.appColors.primary,
    ),
    hSpace(height: 8),
    ThemeText(
      text: l10n.subtitle,
      style: theme.textTheme.h40, // 中位
      color: theme.appColors.secondary,
    ),
    hSpace(height: 4),
    ThemeText(
      text: l10n.description,
      style: theme.textTheme.h30, // 下位
      color: theme.appColors.grey,
    ),
  ],
)
```

### 2. 若者向け最先端デザイン

#### 2.1 モダンなカラーパレット
```xml
<!-- colors.xml - 若者向け最先端カラー -->
<color name="gradientStart">#667eea</color>
<color name="gradientEnd">#764ba2</color>
<color name="neonAccent">#00f5ff</color>
<color name="darkSurface">#1a1a1a</color>
<color name="glassEffect">#40ffffff</color>
```

#### 2.2 グラデーションとエフェクト
```dart
// ✅ 推奨 - モダンなグラデーション
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorName.gradientStart,
        ColorName.gradientEnd,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: ColorName.neonAccent.withValues(alpha: 0.3),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  ),
)
```

#### 2.3 ガラスモーフィズム効果
```dart
// ✅ 推奨 - ガラスモーフィズム
Container(
  decoration: BoxDecoration(
    color: ColorName.glassEffect,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: ColorName.white.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: ColorName.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: // コンテンツ
    ),
  ),
)
```

#### 2.4 アニメーションとマイクロインタラクション
```dart
// ✅ 推奨 - スムーズなアニメーション
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(isPressed ? 0.95 : 1.0),
  child: PrimaryButton(
    text: l10n.interactiveButton,
    callback: () {
      // ハプティックフィードバック
      HapticFeedback.lightImpact();
    },
  ),
)
```

#### 2.5 ネオモーフィズム
```dart
// ✅ 推奨 - ネオモーフィズム効果
Container(
  decoration: BoxDecoration(
    color: theme.appColors.background,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: ColorName.white.withValues(alpha: 0.7),
        offset: const Offset(-5, -5),
        blurRadius: 15,
      ),
      BoxShadow(
        color: ColorName.black.withValues(alpha: 0.15),
        offset: const Offset(5, 5),
        blurRadius: 15,
      ),
    ],
  ),
)
```

### 3. レスポンシブデザイン

#### 3.1 画面サイズ対応
```dart
// ✅ 推奨 - レスポンシブレイアウト
LayoutBuilder(
  builder: (context, constraints) {
    final isTablet = constraints.maxWidth > 600;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: isTablet ? 1.2 : 1.0,
        crossAxisSpacing: isTablet ? 24 : 16,
        mainAxisSpacing: isTablet ? 24 : 16,
      ),
      itemBuilder: (context, index) => // アイテム
    );
  },
)
```

#### 3.2 動的フォントサイズ
```dart
// ✅ 推奨 - 画面サイズに応じたフォント
ThemeText(
  text: l10n.responsiveText,
  style: theme.textTheme.h30.copyWith(
    fontSize: getScreenSize(context).width * 0.04,
  ),
)
```

### 4. アクセシビリティ

#### 4.1 セマンティクス
```dart
// ✅ 推奨 - アクセシビリティ対応
Semantics(
  label: l10n.buttonAccessibilityLabel,
  hint: l10n.buttonAccessibilityHint,
  child: PrimaryButton(
    text: l10n.actionButton,
    callback: () {},
  ),
)
```

#### 4.2 高コントラスト対応
```dart
// ✅ 推奨 - 高コントラストモード対応
ThemeText(
  text: l10n.importantText,
  color: MediaQuery.of(context).highContrast
      ? ColorName.black
      : theme.appColors.primary,
  style: theme.textTheme.h30.bold(),
)
```

### 5. 若者向けデザインパターン

#### 5.1 カードベースレイアウト
```dart
// ✅ 推奨 - モダンなカードデザイン
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          ColorName.gradientStart.withValues(alpha: 0.1),
          ColorName.gradientEnd.withValues(alpha: 0.1),
        ],
      ),
    ),
    child: // コンテンツ
  ),
)
```

#### 5.2 フローティングアクションボタン
```dart
// ✅ 推奨 - モダンなFAB
FloatingActionButton.extended(
  onPressed: () {},
  backgroundColor: ColorName.gradientStart,
  icon: const Icon(Icons.add, color: ColorName.white),
  label: ThemeText(
    text: l10n.addAction,
    color: ColorName.white,
    style: theme.textTheme.h30.bold(),
  ),
)
```

### 6. デザインシステム

#### 6.1 一貫したスペーシング
```dart
// ✅ 推奨 - 統一されたスペーシング
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// 使用例
Padding(
  padding: const EdgeInsets.all(Spacing.md),
  child: // コンテンツ
)
```

#### 6.2 統一されたボーダーラディウス
```dart
// ✅ 推奨 - 統一された角丸
class BorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}
```

### 7. パフォーマンス最適化

#### 7.1 画像最適化
```dart
// ✅ 推奨 - 最適化された画像表示
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const Loading(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: (getScreenSize(context).width * 2).toInt(),
  memCacheHeight: (getScreenSize(context).height * 0.3).toInt(),
)
```

### 8. チェックリスト

#### 8.1 基本UIチェック
- [ ] 十分なコントラスト比（4.5:1以上）
- [ ] 適切なタッチターゲットサイズ（44px以上）
- [ ] 明確な情報階層
- [ ] 一貫したスペーシング
- [ ] レスポンシブデザイン対応

#### 8.2 若者向けデザインチェック
- [ ] モダンなカラーパレット
- [ ] グラデーション効果の活用
- [ ] スムーズなアニメーション
- [ ] ガラスモーフィズムやネオモーフィズム
- [ ] マイクロインタラクション

#### 8.3 アクセシビリティチェック
- [ ] セマンティクスラベルの設定
- [ ] 高コントラストモード対応
- [ ] スクリーンリーダー対応
- [ ] キーボードナビゲーション対応

**このUIデザインルールに従うことで、見やすく使いやすく、若者にアピールする最先端のUIを実現できます。** 🎨✨