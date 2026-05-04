# Apple Design System - Typography

SF Pro フォントシステムに基づくタイポグラフィ設計。

## Type Scale

| Style | Size | Weight | Letter Spacing | Line Height |
|-------|------|--------|----------------|-------------|
| Large Title | 34pt | Bold (700) | 0.37 | 1.2 |
| Title 1 | 28pt | Bold (700) | 0.36 | 1.2 |
| Title 2 | 22pt | Bold (700) | 0.35 | 1.3 |
| Title 3 | 20pt | Semibold (600) | 0.38 | 1.25 |
| Headline | 17pt | Semibold (600) | -0.41 | 1.3 |
| Body | 17pt | Regular (400) | -0.41 | 1.3 |
| Callout | 16pt | Regular (400) | -0.32 | 1.3 |
| Sub Headline | 15pt | Regular (400) | -0.24 | 1.35 |
| Footnote | 13pt | Regular (400) | -0.08 | 1.4 |
| Caption 1 | 12pt | Regular (400) | 0 | 1.35 |
| Caption 2 | 11pt | Regular (400) | 0.07 | 1.2 |

## Text Styles Implementation

```dart
class AppleTextStyles {
  static TextStyle largeTitle(BuildContext context) => TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    height: 1.2,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle title1(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.36,
    height: 1.2,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle title2(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.35,
    height: 1.3,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle title3(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.25,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle callout(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.3,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle subheadline(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.35,
    color: AppleSemanticColors.label(context),
  );

  static TextStyle footnote(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.4,
    color: AppleSemanticColors.secondaryLabel(context),
  );

  static TextStyle caption1(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.35,
    color: AppleSemanticColors.secondaryLabel(context),
  );

  static TextStyle caption2(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.2,
    color: AppleSemanticColors.tertiaryLabel(context),
  );
}
```

## Emphasized Variants

```dart
extension AppleTextStyleVariants on TextStyle {
  TextStyle get emphasized => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle get secondary => copyWith(
    color: color?.withOpacity(0.6),
  );

  TextStyle get tertiary => copyWith(
    color: color?.withOpacity(0.3),
  );
}
```

## Dynamic Type Support

```dart
class AppleDynamicType {
  static double scaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.textScaler.scale(1.0).clamp(0.8, 1.5);
  }

  static TextStyle scaled(BuildContext context, TextStyle style) {
    final scale = scaleFactor(context);
    return style.copyWith(
      fontSize: (style.fontSize ?? 17) * scale,
    );
  }
}
```

## AppTextTheme スタイルマッピング（必須）

> ⚠️ **命名の罠**: `h` の数字は**小さいほど小さいフォント**。直感と逆に見えるので要注意。

| AppTextTheme | pt（SP） | Apple Type Scale 相当 | 用途 |
|---|---|---|---|
| `theme.textTheme.h10` | **10pt** | Caption 2 | バッジ・タグ・ラベルの最小テキスト |
| `theme.textTheme.h20` | **12pt** | Caption 1 | 日付・補助テキスト・サブラベル |
| `theme.textTheme.h30` | **14pt** | Footnote | 補足情報・二次テキスト |
| `theme.textTheme.h40` | **16pt** | Callout / Body | リストアイテムのタイトル |
| `theme.textTheme.h45` | **18pt** | Body (large) | セクションタイトル |
| `theme.textTheme.h50` | **20pt** | Title 3 | ページ内見出し・統計数値 |
| `theme.textTheme.h60` | **24pt** | Title 2 | 大見出し・ヒーロー数値 |
| `theme.textTheme.h70` | **32pt** | Title 1 | 大型ディスプレイ数値 |
| `theme.textTheme.h80` | **40pt** | Large Title | 特大表示（ほぼ不使用） |

### カード・リストアイテムでの正しい使い方

**テキスト階層のルール: バッジ < 補助テキスト < タイトル**

```dart
// ✅ 正しい例（サイズが意味と一致）
_CategoryBadge:  theme.textTheme.h10  // 10pt - バッジは最小
craftCard date:  theme.textTheme.h20  // 12pt - 補助情報
craftCard cost:  theme.textTheme.h20  // 12pt - 補助情報
craftCard title: theme.textTheme.h40  // 16pt - メインタイトル

// ❌ よくある誤り（h60 でバッジを作るとタイトルより大きくなる）
_CategoryBadge:  theme.textTheme.h60  // 24pt - バッジが見出しより大きい！
craftCard title: theme.textTheme.h30  // 14pt - タイトルがバッジより小さい → 逆転
```

### 用途別クイックリファレンス

| 用途 | スタイル | pt |
|------|---------|-----|
| バッジ・チップ・タグのテキスト | `h10` | 10pt |
| 日付・メタ情報・サブラベル | `h20` | 12pt |
| 補足テキスト・二次情報 | `h30` | 14pt |
| **リストアイテムのタイトル（主な用途）** | `h40` | 16pt |
| セクション見出し | `h45` | 18pt |
| サマリーカードのラベル | `h45` | 18pt |
| **サマリーカードの大きな数値** | `h50`〜`h60` | 20〜24pt |

## Typography Best Practices

### Hierarchy

1. **One Large Title** per screen (navigation bar)
2. **Title 1-3** for section headers
3. **Headline** for list item titles
4. **Body** for main content
5. **Footnote/Caption** for supplementary info

### Line Length

- Optimal: 50-75 characters per line
- Maximum: 80 characters
- Minimum: 40 characters

### Alignment

- **Left-aligned** for body text (LTR languages)
- **Center-aligned** only for short headlines or buttons
- **Right-aligned** sparingly, for numerical data

### Usage Examples

```dart
// Navigation title
Text(
  'Settings',
  style: AppleTextStyles.largeTitle(context),
)

// Section header
Text(
  'Account',
  style: AppleTextStyles.title3(context),
)

// List item title with subtitle
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Profile', style: AppleTextStyles.body(context)),
    Text('Manage your account', style: AppleTextStyles.footnote(context)),
  ],
)

// Emphasized text
Text(
  'Important',
  style: AppleTextStyles.body(context).emphasized,
)

// Link text
Text(
  'Learn more',
  style: AppleTextStyles.body(context).withColor(
    AppleSemanticColors.accentBlue(context),
  ),
)
```
