---
name: apple-design
description: Create Apple-inspired elegant UI designs in Flutter with SF Pro typography, frosted glass effects, subtle animations, and iOS Human Interface Guidelines compliance. Use when designing premium UI, creating iOS-style components, implementing blur effects, or building Apple-aesthetic screens.
---

# Apple Design Skill

FlutterでApple風のエレガントなUIデザインを実現するためのスキルです。

## When to Use This Skill

- Apple風のプレミアムUIを作成する時
- iOS Human Interface Guidelinesに準拠したデザインが必要な時
- すりガラス効果（Frosted Glass）を実装する時
- SF Pro系フォントを活用したタイポグラフィを設計する時
- 微細なアニメーションでUXを向上させる時
- ダークモード対応のエレガントなUIを構築する時
- **UX心理学に基づいた設計が必要な時**（応答性、労働の錯覚、選択肢の最適化など）

## Core Design Principles

### 1. Clarity（明瞭性）
テキストは読みやすく、アイコンは認識しやすく、装飾は最小限に。

### 2. Deference（控えめさ）
コンテンツが主役。余白を活用し、控えめなグラデーションとシャドウで。

### 3. Depth（深度）
レイヤー、ブラー効果、影と光で視覚的階層と立体感を表現。

## Quick Reference

### Colors
```dart
// Light Mode
AppleColors.systemBlue      // #007AFF - Primary accent
AppleColors.systemGray6     // #F2F2F7 - Background
AppleColors.label           // #000000 - Primary text

// Dark Mode
AppleColorsDark.systemBlue  // #0A84FF - Primary accent
AppleColorsDark.systemGray6 // #1C1C1E - Background
AppleColorsDark.label       // #FFFFFF - Primary text

// Semantic (auto dark/light)
AppleSemanticColors.background(context)
AppleSemanticColors.label(context)
AppleSemanticColors.accentBlue(context)
```

### Typography
```dart
AppleTextStyles.largeTitle(context)  // 34pt Bold - Screen titles
AppleTextStyles.title1(context)      // 28pt Bold - Section headers
AppleTextStyles.headline(context)    // 17pt Semibold - List titles
AppleTextStyles.body(context)        // 17pt Regular - Body text
AppleTextStyles.footnote(context)    // 13pt Regular - Secondary text
```

### Spacing (8pt Grid)
```dart
AppleSpacing.xs   // 8px  - Minimum gap
AppleSpacing.sm   // 12px - Compact spacing
AppleSpacing.md   // 16px - Standard spacing
AppleSpacing.lg   // 24px - Section spacing
AppleSpacing.xl   // 32px - Large sections
```

### Components
```dart
// Buttons
AppleButton(label: 'Continue', onPressed: () {})
AppleButton(label: 'Delete', style: AppleButtonStyle.destructive)

// Cards
AppleCard(child: content)
AppleFrostedCard(child: content, blur: 20)

// Lists
AppleListTile(title: 'Settings', onTap: () {})
AppleListSection(header: 'ACCOUNT', children: [...])
```

### Animations
```dart
// Durations
AppleDurations.instant   // 100ms - Tap feedback
AppleDurations.quick     // 200ms - State changes
AppleDurations.standard  // 300ms - Transitions

// Widgets
AppleFadeIn(child: widget)
AppleScaleTap(child: widget, onTap: () {})
```

## Detailed References

詳細な実装コードとガイドラインは以下を参照:

- **[Colors](references/colors.md)**: カラーシステム、セマンティックカラー、グラデーション
- **[Typography](references/typography.md)**: テキストスタイル、Dynamic Type対応
- **[Components](references/components.md)**: ボタン、カード、リスト、フォーム要素
- **[Animations](references/animations.md)**: タイミング、カーブ、アニメーションウィジェット
- **[Spacing](references/spacing.md)**: 余白システム、レイアウトパターン、レスポンシブ
- **[UX Psychology](references/ux-psychology.md)**: UX心理学コンセプト、ユーザー体験向上の法則

## Best Practices Summary

| Category | Do | Don't |
|----------|-----|-------|
| Colors | セマンティックカラーを使用 | ハードコードされた色 |
| Typography | AppleTextStylesを使用 | カスタムフォントサイズ |
| Spacing | 8ptグリッドに揃える | 不規則な余白値 |
| Animation | 200-500msで控えめに | 1秒超のアニメーション |
| Touch | 44pt以上のタップ領域 | 小さすぎるボタン |
| Response | 400ms以内の応答（ドハティ閾値） | 遅延時のフィードバック無し |
| Choices | 5-7個以下の選択肢 | 多すぎる選択肢 |

## AI Assistant Instructions

When this skill is activated:

**Always:**
1. iOS Human Interface Guidelinesに準拠
2. ダークモード対応を含める（AppleSemanticColorsを使用）
3. AppleTextStylesでタイポグラフィを統一
4. 8ptグリッドシステムでレイアウト
5. 控えめなアニメーション（200-500ms、EaseOut）
6. 44pt以上のタッチターゲット
7. 400ms以内の応答時間を目指す（ドハティの閾値）
8. 長時間処理には「労働の錯覚」を活用（プログレス表示）

**Never:**
1. 原色をそのまま使用（#FF0000等）
2. 過度な装飾やシャドウ
3. 1秒を超えるアニメーション
4. ハードコードされた色やサイズ
5. アクセシビリティ設定（Reduced Motion等）を無視

**Workflow:**
1. 既存コンポーネントを確認（flutter_foundation優先）
2. AppleColors/AppleTextStylesを適用
3. すりガラス効果が適切か検討
4. アニメーションを控えめに追加
5. Light/Darkモード両方で動作確認

## Additional Resources

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Cupertino Widgets](https://docs.flutter.dev/ui/widgets/cupertino)
