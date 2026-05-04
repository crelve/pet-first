# Apple Design System - Colors

iOS Human Interface Guidelinesに準拠したカラーシステム。

## System Colors

### Light Mode - AppleColors

```dart
class AppleColors {
  // Primary Colors
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemIndigo = Color(0xFF5856D6);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemPink = Color(0xFFFF2D55);
  static const Color systemPurple = Color(0xFFAF52DE);
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemTeal = Color(0xFF5AC8FA);
  static const Color systemYellow = Color(0xFFFFCC00);

  // Gray Scale (6 levels)
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(0xFFF2F2F7);

  // Backgrounds
  static const Color systemBackground = Color(0xFFFFFFFF);
  static const Color secondarySystemBackground = Color(0xFFF2F2F7);
  static const Color tertiarySystemBackground = Color(0xFFFFFFFF);
  static const Color groupedBackground = Color(0xFFF2F2F7);
  static const Color secondaryGroupedBackground = Color(0xFFFFFFFF);

  // Labels (with alpha)
  static const Color label = Color(0xFF000000);
  static const Color secondaryLabel = Color(0x993C3C43);  // 60% opacity
  static const Color tertiaryLabel = Color(0x4D3C3C43);   // 30% opacity
  static const Color quaternaryLabel = Color(0x2E3C3C43); // 18% opacity

  // Separators
  static const Color separator = Color(0x4A3C3C43);       // 29% opacity
  static const Color opaqueSeparator = Color(0xFFC6C6C8);

  // Fill Colors
  static const Color systemFill = Color(0x33787880);      // 20% opacity
  static const Color secondarySystemFill = Color(0x29787880);
  static const Color tertiarySystemFill = Color(0x1F787880);
  static const Color quaternarySystemFill = Color(0x14787880);
}
```

### Dark Mode - AppleColorsDark

```dart
class AppleColorsDark {
  // Primary Colors (vibrant for dark backgrounds)
  static const Color systemBlue = Color(0xFF0A84FF);
  static const Color systemGreen = Color(0xFF30D158);
  static const Color systemIndigo = Color(0xFF5E5CE6);
  static const Color systemOrange = Color(0xFFFF9F0A);
  static const Color systemPink = Color(0xFFFF375F);
  static const Color systemPurple = Color(0xFFBF5AF2);
  static const Color systemRed = Color(0xFFFF453A);
  static const Color systemTeal = Color(0xFF64D2FF);
  static const Color systemYellow = Color(0xFFFFD60A);

  // Gray Scale (inverted hierarchy)
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFF636366);
  static const Color systemGray3 = Color(0xFF48484A);
  static const Color systemGray4 = Color(0xFF3A3A3C);
  static const Color systemGray5 = Color(0xFF2C2C2E);
  static const Color systemGray6 = Color(0xFF1C1C1E);

  // Backgrounds (elevated surfaces)
  static const Color systemBackground = Color(0xFF000000);
  static const Color secondarySystemBackground = Color(0xFF1C1C1E);
  static const Color tertiarySystemBackground = Color(0xFF2C2C2E);
  static const Color groupedBackground = Color(0xFF000000);
  static const Color secondaryGroupedBackground = Color(0xFF1C1C1E);

  // Elevated Backgrounds (for modal sheets, popovers)
  static const Color elevatedBackground = Color(0xFF1C1C1E);
  static const Color secondaryElevatedBackground = Color(0xFF2C2C2E);
  static const Color tertiaryElevatedBackground = Color(0xFF3A3A3C);

  // Labels
  static const Color label = Color(0xFFFFFFFF);
  static const Color secondaryLabel = Color(0x99EBEBF5);  // 60% opacity
  static const Color tertiaryLabel = Color(0x4DEBEBF5);   // 30% opacity
  static const Color quaternaryLabel = Color(0x29EBEBF5); // 16% opacity

  // Separators
  static const Color separator = Color(0x99545458);
  static const Color opaqueSeparator = Color(0xFF38383A);

  // Fill Colors
  static const Color systemFill = Color(0x5C787880);
  static const Color secondarySystemFill = Color(0x52787880);
  static const Color tertiarySystemFill = Color(0x3D787880);
  static const Color quaternarySystemFill = Color(0x2E787880);
}
```

## Semantic Colors Helper

```dart
class AppleSemanticColors {
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.systemBackground
        : AppleColors.systemBackground;
  }

  static Color secondaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.secondarySystemBackground
        : AppleColors.secondarySystemBackground;
  }

  static Color label(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.label
        : AppleColors.label;
  }

  static Color secondaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.secondaryLabel
        : AppleColors.secondaryLabel;
  }

  static Color separator(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.separator
        : AppleColors.separator;
  }

  static Color accentBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.systemBlue
        : AppleColors.systemBlue;
  }

  static Color destructive(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.systemRed
        : AppleColors.systemRed;
  }

  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.systemGreen
        : AppleColors.systemGreen;
  }

  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppleColorsDark.systemOrange
        : AppleColors.systemOrange;
  }
}
```

## Gradient Patterns

```dart
class AppleGradients {
  // Subtle top-to-bottom gradient for cards
  static LinearGradient cardGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [
              AppleColorsDark.systemGray5,
              AppleColorsDark.systemGray6,
            ]
          : [
              Colors.white,
              AppleColors.systemGray6,
            ],
    );
  }

  // Mesh gradient simulation for backgrounds
  static List<Color> meshGradientColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
            AppleColorsDark.systemIndigo.withOpacity(0.3),
            AppleColorsDark.systemPurple.withOpacity(0.2),
            AppleColorsDark.systemPink.withOpacity(0.2),
          ]
        : [
            AppleColors.systemIndigo.withOpacity(0.1),
            AppleColors.systemPurple.withOpacity(0.08),
            AppleColors.systemPink.withOpacity(0.08),
          ];
  }

  // Vibrancy overlay for blur effects
  static Color vibrancyOverlay(BuildContext context, {double opacity = 0.7}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.black.withOpacity(opacity)
        : Colors.white.withOpacity(opacity);
  }
}
```

## Usage Guidelines

### Color Selection Priority

1. **Semantic colors first**: Use `AppleSemanticColors` for common patterns
2. **Context-aware**: Always check `Theme.of(context).brightness`
3. **Consistency**: Use the same color token across related elements

### Contrast Requirements

| Element Type | Minimum Contrast Ratio |
|-------------|----------------------|
| Body text | 4.5:1 |
| Large text (18pt+) | 3:1 |
| UI components | 3:1 |
| Decorative | No requirement |

### Do's and Don'ts

**Do:**
- Use system colors for semantic meaning
- Maintain consistent color hierarchy
- Test in both light and dark modes
- Use opacity variants for layering

**Don't:**
- Mix light and dark mode colors
- Use pure black (#000000) on white backgrounds
- Ignore color blindness accessibility
- Hardcode hex values inline
