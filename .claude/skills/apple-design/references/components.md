# Apple Design System - Components

再利用可能なApple風UIコンポーネント集。

## Buttons

### Primary Button

```dart
class AppleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppleButtonStyle style;
  final bool isLoading;
  final IconData? icon;

  const AppleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppleButtonStyle.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(context, isDark);

    return TapScaleWidget(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: onPressed == null
              ? colors.background.withOpacity(0.5)
              : colors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colors.foreground),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: colors.foreground, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: AppleTextStyles.headline(context)
                          .copyWith(color: colors.foreground),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _ButtonColors _getColors(BuildContext context, bool isDark) {
    switch (style) {
      case AppleButtonStyle.primary:
        return _ButtonColors(
          background: isDark ? AppleColorsDark.systemBlue : AppleColors.systemBlue,
          foreground: Colors.white,
        );
      case AppleButtonStyle.secondary:
        return _ButtonColors(
          background: isDark ? AppleColorsDark.systemGray5 : AppleColors.systemGray6,
          foreground: isDark ? AppleColorsDark.systemBlue : AppleColors.systemBlue,
        );
      case AppleButtonStyle.destructive:
        return _ButtonColors(
          background: isDark ? AppleColorsDark.systemRed : AppleColors.systemRed,
          foreground: Colors.white,
        );
      case AppleButtonStyle.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? AppleColorsDark.systemBlue : AppleColors.systemBlue,
        );
    }
  }
}

enum AppleButtonStyle { primary, secondary, destructive, text }

class _ButtonColors {
  final Color background;
  final Color foreground;
  const _ButtonColors({required this.background, required this.foreground});
}
```

### Icon Button

```dart
class AppleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const AppleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return TapScaleWidget(
      onTap: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            icon,
            color: color ?? AppleSemanticColors.accentBlue(context),
            size: 22,
          ),
        ),
      ),
    );
  }
}
```

## Cards

### Standard Card

```dart
class AppleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const AppleCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TapScaleWidget(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isDark
              ? AppleColorsDark.secondarySystemBackground
              : Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
```

### Frosted Glass Card

```dart
class AppleFrostedCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const AppleFrostedCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.7,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isDark
                ? Colors.black.withOpacity(opacity)
                : Colors.white.withOpacity(opacity),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

## List Items

### Standard List Tile

```dart
class AppleListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool showChevron;

  const AppleListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TapScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? AppleColorsDark.secondarySystemBackground
              : Colors.white,
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: AppleSemanticColors.separator(context),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppleTextStyles.body(context)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppleTextStyles.footnote(context)),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
            if (onTap != null && showChevron) ...[
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.chevron_right,
                color: isDark
                    ? AppleColorsDark.systemGray2
                    : AppleColors.systemGray2,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Grouped List Section

```dart
class AppleListSection extends StatelessWidget {
  final String? header;
  final String? footer;
  final List<Widget> children;

  const AppleListSection({
    super.key,
    this.header,
    this.footer,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              header!.toUpperCase(),
              style: AppleTextStyles.footnote(context),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppleColorsDark.secondarySystemBackground
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: children,
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              footer!,
              style: AppleTextStyles.footnote(context),
            ),
          ),
      ],
    );
  }
}
```

## Navigation

### Navigation Bar

```dart
class AppleNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool largeTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool blurred;

  const AppleNavigationBar({
    super.key,
    required this.title,
    this.largeTitle = true,
    this.actions,
    this.leading,
    this.blurred = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(largeTitle ? 96 : 56);

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: Text(
                title,
                style: largeTitle
                    ? AppleTextStyles.largeTitle(context)
                    : AppleTextStyles.headline(context),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );

    if (!blurred) {
      return Container(
        color: AppleSemanticColors.background(context),
        child: content,
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppleGradients.vibrancyOverlay(context),
            border: Border(
              bottom: BorderSide(
                color: AppleSemanticColors.separator(context),
                width: 0.5,
              ),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
```

## Form Elements

### Text Field

```dart
class AppleTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;

  const AppleTextField({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppleTextStyles.subheadline(context)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppleColorsDark.tertiarySystemBackground
                : AppleColors.systemGray6,
            borderRadius: BorderRadius.circular(10),
            border: errorText != null
                ? Border.all(color: AppleColors.systemRed, width: 1)
                : null,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppleTextStyles.body(context),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppleTextStyles.body(context).copyWith(
                color: AppleSemanticColors.tertiaryLabel(context),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppleTextStyles.caption1(context).copyWith(
              color: AppleColors.systemRed,
            ),
          ),
        ],
      ],
    );
  }
}
```

### Toggle Switch

```dart
class AppleToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppleToggle({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppleColors.systemGreen,
    );
  }
}
```

## Tap Scale Widget (Core Interaction)

```dart
class TapScaleWidget extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;

  const TapScaleWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.97,
  });

  @override
  Widget build(BuildContext context) {
    final scale = useState(1.0);

    return GestureDetector(
      onTapDown: onTap != null ? (_) => scale.value = scaleValue : null,
      onTapUp: onTap != null
          ? (_) {
              scale.value = 1.0;
              onTap?.call();
            }
          : null,
      onTapCancel: onTap != null ? () => scale.value = 1.0 : null,
      child: AnimatedScale(
        scale: scale.value,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}
```
