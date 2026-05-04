# Apple Design System - Animations

控えめで洗練されたアニメーションパターン集。

## Core Principles

1. **Purpose-driven**: アニメーションには意味がある
2. **Subtle**: 控えめで邪魔にならない
3. **Responsive**: ユーザー操作に即座に反応
4. **Consistent**: 同じ種類の操作には同じアニメーション

## Timing & Curves

### Standard Durations

| Type | Duration | Use Case |
|------|----------|----------|
| Instant | 100ms | タップフィードバック |
| Quick | 200ms | 小さな状態変更 |
| Standard | 300ms | 画面遷移、モーダル |
| Slow | 500ms | 複雑な状態変更 |

### Apple Curves

```dart
class AppleCurves {
  /// システム標準 - ほとんどのアニメーションに使用
  static const Curve standard = Curves.easeInOut;

  /// 要素の出現 - 画面に入ってくる要素
  static const Curve enter = Curves.easeOut;

  /// 要素の退出 - 画面から出ていく要素
  static const Curve exit = Curves.easeIn;

  /// スプリング - インタラクティブな要素
  static const Curve spring = Curves.elasticOut;

  /// 減速 - 自然な停止感
  static const Curve decelerate = Curves.decelerate;

  /// iOS標準のスプリングに近い挙動
  static const Curve iosSpring = Cubic(0.25, 0.1, 0.25, 1.0);
}
```

### Duration Constants

```dart
class AppleDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 350);
}
```

## Animation Widgets

### Fade In Animation

```dart
class AppleFadeIn extends HookWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset? slideOffset;

  const AppleFadeIn({
    super.key,
    required this.child,
    this.duration = AppleDurations.standard,
    this.delay = Duration.zero,
    this.slideOffset,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);
    final animation = useAnimation(
      CurvedAnimation(parent: controller, curve: AppleCurves.enter),
    );

    useEffect(() {
      Future.delayed(delay, () {
        if (context.mounted) controller.forward();
      });
      return null;
    }, []);

    return Opacity(
      opacity: animation,
      child: slideOffset != null
          ? Transform.translate(
              offset: Offset(
                slideOffset!.dx * (1 - animation),
                slideOffset!.dy * (1 - animation),
              ),
              child: child,
            )
          : child,
    );
  }
}
```

### Staggered List Animation

```dart
class AppleStaggeredList extends HookWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;

  const AppleStaggeredList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = AppleDurations.standard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return AppleFadeIn(
          duration: itemDuration,
          delay: itemDelay * index,
          slideOffset: const Offset(0, 20),
          child: children[index],
        );
      }),
    );
  }
}
```

### Scale Tap Animation

```dart
class AppleScaleTap extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double minScale;

  const AppleScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.minScale = 0.97,
  });

  @override
  Widget build(BuildContext context) {
    final scale = useState(1.0);
    final isPressed = useState(false);

    return GestureDetector(
      onTapDown: onTap != null
          ? (_) {
              scale.value = minScale;
              isPressed.value = true;
            }
          : null,
      onTapUp: onTap != null
          ? (_) {
              scale.value = 1.0;
              isPressed.value = false;
              onTap?.call();
            }
          : null,
      onTapCancel: onTap != null
          ? () {
              scale.value = 1.0;
              isPressed.value = false;
            }
          : null,
      child: AnimatedScale(
        scale: scale.value,
        duration: AppleDurations.instant,
        curve: AppleCurves.iosSpring,
        child: child,
      ),
    );
  }
}
```

### Shimmer Loading Effect

```dart
class AppleShimmer extends HookWidget {
  final Widget child;
  final bool isLoading;

  const AppleShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final animation = useAnimation(controller);

    useEffect(() {
      if (isLoading) {
        controller.repeat();
      } else {
        controller.stop();
      }
      return null;
    }, [isLoading]);

    if (!isLoading) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? [
                  AppleColorsDark.systemGray5,
                  AppleColorsDark.systemGray4,
                  AppleColorsDark.systemGray5,
                ]
              : [
                  AppleColors.systemGray6,
                  AppleColors.systemGray5,
                  AppleColors.systemGray6,
                ],
          stops: [
            animation - 0.3,
            animation,
            animation + 0.3,
          ].map((e) => e.clamp(0.0, 1.0)).toList(),
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
```

### Hero-style Page Transition

```dart
class ApplePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ApplePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppleDurations.pageTransition,
          reverseTransitionDuration: AppleDurations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: AppleCurves.iosSpring,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}
```

### Modal Bottom Sheet Animation

```dart
Future<T?> showAppleBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  double initialChildSize = 0.5,
  double maxChildSize = 0.9,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: 0.25,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppleColorsDark.secondarySystemBackground
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppleColorsDark.systemGray3
                        : AppleColors.systemGray3,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: child,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
```

## Micro-interactions

### Haptic Feedback Integration

```dart
class AppleHaptics {
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void selection() {
    HapticFeedback.selectionClick();
  }

  static void success() {
    // iOS success notification pattern
    HapticFeedback.mediumImpact();
  }

  static void error() {
    // iOS error notification pattern
    HapticFeedback.heavyImpact();
  }
}
```

### Button Press Animation with Haptics

```dart
class AppleInteractiveButton extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHaptics;

  const AppleInteractiveButton({
    super.key,
    required this.child,
    this.onTap,
    this.enableHaptics = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppleScaleTap(
      onTap: () {
        if (enableHaptics) AppleHaptics.light();
        onTap?.call();
      },
      child: child,
    );
  }
}
```

## Animation Best Practices

### Do's
- 200-500msの範囲でアニメーション
- ease-out を入場アニメーションに使用
- ease-in を退場アニメーションに使用
- ユーザー操作には即座に反応（100ms以内）
- 重要な操作にはハプティックフィードバック

### Don'ts
- 1秒を超えるアニメーション
- 過度なバウンスやスプリング
- 複数の同時アニメーション
- アクセシビリティ設定を無視
- 無意味な装飾アニメーション

### Reduced Motion Support

```dart
class AppleMotion {
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  static Duration duration(BuildContext context, Duration normal) {
    return shouldReduceMotion(context) ? Duration.zero : normal;
  }

  static Curve curve(BuildContext context, Curve normal) {
    return shouldReduceMotion(context) ? Curves.linear : normal;
  }
}
```
