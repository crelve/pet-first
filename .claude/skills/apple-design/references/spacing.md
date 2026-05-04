# Apple Design System - Spacing & Layout

一貫した余白とレイアウトシステム。

## Spacing Scale

Apple HIG に基づく8ポイントグリッドシステム。

| Token | Value | Use Case |
|-------|-------|----------|
| xxxs | 2px | アイコン内パディング |
| xxs | 4px | 密接な要素間 |
| xs | 8px | 関連要素間の最小余白 |
| sm | 12px | コンパクトなグループ内 |
| md | 16px | 標準的な要素間余白 |
| lg | 24px | セクション間余白 |
| xl | 32px | 大きなセクション間 |
| xxl | 48px | 画面セクション間 |
| xxxl | 64px | 主要セクション分離 |

## Spacing Constants

```dart
class AppleSpacing {
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // Screen edge insets
  static const double screenHorizontal = 16;
  static const double screenVertical = 20;

  // Safe area additions
  static const double safeAreaBottom = 34; // iPhone X+ home indicator
}

// EdgeInsets helpers
class AppleInsets {
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: AppleSpacing.screenHorizontal,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(AppleSpacing.md);

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: AppleSpacing.md,
    vertical: AppleSpacing.sm,
  );

  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    vertical: AppleSpacing.lg,
  );

  static EdgeInsets safeArea(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }
}
```

## Gap Widgets

```dart
class AppleGap {
  static SizedBox xxxs = const SizedBox(height: AppleSpacing.xxxs);
  static SizedBox xxs = const SizedBox(height: AppleSpacing.xxs);
  static SizedBox xs = const SizedBox(height: AppleSpacing.xs);
  static SizedBox sm = const SizedBox(height: AppleSpacing.sm);
  static SizedBox md = const SizedBox(height: AppleSpacing.md);
  static SizedBox lg = const SizedBox(height: AppleSpacing.lg);
  static SizedBox xl = const SizedBox(height: AppleSpacing.xl);
  static SizedBox xxl = const SizedBox(height: AppleSpacing.xxl);
  static SizedBox xxxl = const SizedBox(height: AppleSpacing.xxxl);

  // Horizontal gaps
  static SizedBox hXxxs = const SizedBox(width: AppleSpacing.xxxs);
  static SizedBox hXxs = const SizedBox(width: AppleSpacing.xxs);
  static SizedBox hXs = const SizedBox(width: AppleSpacing.xs);
  static SizedBox hSm = const SizedBox(width: AppleSpacing.sm);
  static SizedBox hMd = const SizedBox(width: AppleSpacing.md);
  static SizedBox hLg = const SizedBox(width: AppleSpacing.lg);
  static SizedBox hXl = const SizedBox(width: AppleSpacing.xl);
}
```

## Layout Patterns

### Screen Layout

```dart
class AppleScreenLayout extends StatelessWidget {
  final Widget? navigationBar;
  final Widget body;
  final Widget? bottomBar;
  final bool extendBody;
  final Color? backgroundColor;

  const AppleScreenLayout({
    super.key,
    this.navigationBar,
    required this.body,
    this.bottomBar,
    this.extendBody = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ??
          AppleSemanticColors.background(context),
      extendBody: extendBody,
      appBar: navigationBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(96),
              child: navigationBar!,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomBar,
    );
  }
}
```

### Content Container

```dart
class AppleContentContainer extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsets? padding;

  const AppleContentContainer({
    super.key,
    required this.child,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? AppleInsets.screenPadding,
      child: child,
    );

    if (scrollable) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: content,
      );
    }

    return content;
  }
}
```

### Grouped Content

```dart
class AppleGroupedContent extends StatelessWidget {
  final List<Widget> sections;

  const AppleGroupedContent({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppleSemanticColors.groupedBackground(context),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(
          top: AppleSpacing.md,
          bottom: MediaQuery.of(context).padding.bottom + AppleSpacing.md,
        ),
        itemCount: sections.length,
        separatorBuilder: (_, __) => AppleGap.lg,
        itemBuilder: (_, index) => Padding(
          padding: AppleInsets.screenPadding,
          child: sections[index],
        ),
      ),
    );
  }
}
```

## Touch Targets

```dart
class AppleTouchTarget {
  /// Minimum touch target size (44x44 points)
  static const double minSize = 44;

  /// Recommended touch target size
  static const double recommendedSize = 48;

  /// Minimum spacing between touch targets
  static const double minSpacing = 8;

  static Widget ensure({
    required Widget child,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width ?? minSize,
      height: height ?? minSize,
      child: Center(child: child),
    );
  }
}
```

## Border Radius

```dart
class AppleBorderRadius {
  /// Small elements (badges, tags)
  static const double xs = 4;

  /// Buttons, inputs
  static const double sm = 8;

  /// Cards, containers
  static const double md = 12;

  /// Large cards, modals
  static const double lg = 16;

  /// Bottom sheets, full-screen modals
  static const double xl = 20;

  /// Continuous corners (iOS squircle approximation)
  static BorderRadius continuous(double radius) {
    return BorderRadius.circular(radius);
  }
}
```

## Responsive Breakpoints

```dart
class AppleBreakpoints {
  /// iPhone SE, compact
  static const double compact = 320;

  /// iPhone standard
  static const double regular = 375;

  /// iPhone Plus/Max
  static const double expanded = 414;

  /// iPad
  static const double tablet = 768;

  /// iPad Pro
  static const double desktop = 1024;

  static bool isCompact(BuildContext context) {
    return MediaQuery.of(context).size.width < regular;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}

class AppleResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AppleResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= AppleBreakpoints.desktop && desktop != null) {
      return desktop!;
    }
    if (width >= AppleBreakpoints.tablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
```

## Safe Area Handling

```dart
class AppleSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets minimum;

  const AppleSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum,
      child: child,
    );
  }
}
```

## Layout Best Practices

### Do's
- 8pt グリッドに揃える
- 画面端から16pt のマージン
- 関連要素をグループ化
- 十分な余白で呼吸感を出す
- タッチターゲット44pt以上確保

### Don'ts
- 要素を詰め込みすぎる
- 不規則な余白値を使う
- SafeAreaを無視する
- 小さすぎるタップ領域
- 一貫性のないパディング

### Content Density Guidelines

| Screen Type | Density | Spacing Multiplier |
|------------|---------|-------------------|
| Dashboard | Comfortable | 1.0x |
| List | Standard | 1.0x |
| Form | Comfortable | 1.25x |
| Detail | Spacious | 1.5x |
| Settings | Standard | 1.0x |
