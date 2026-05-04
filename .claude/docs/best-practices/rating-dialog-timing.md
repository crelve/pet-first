# レビューダイアログ表示タイミング ベストプラクティス

## 概要

アプリのレビューリクエストは、ユーザーがポジティブな体験をした直後に表示することで、高評価を獲得しやすくなります。このガイドでは、`useRatingDialog` フックを使用した最適なタイミングでのレビューダイアログ表示方法を解説します。

## 基本原則

### 1. UX心理学に基づくタイミング

**ピーク・エンドの法則**（`.claude/skills/apple-design/references/ux-psychology.md` 参照）:
- ユーザーがポジティブな体験のピークを迎えた直後が最適
- 満足感が高い状態でレビューを依頼することで、高評価につながる

### 2. 避けるべきタイミング

- ❌ アプリ起動直後（まだ価値を体験していない）
- ❌ エラー発生直後
- ❌ タスク失敗直後
- ❌ ユーザーが焦っている状況
- ❌ 短時間に複数回表示

### 3. 最適なタイミング

- ✅ タスク完了直後
- ✅ 目標達成直後
- ✅ 便利な機能を使用した直後
- ✅ ポジティブな結果を得た直後
- ✅ 一定回数の成功体験を積んだ後

## 実装パターン

### パターン1: タスク完了時

```dart
class TaskCompletionScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タスク完了のポジティブな体験の直後にレビューリクエスト
    useEffect(() {
      Future.microtask(() {
        useRatingDialog(
          context: context,
          ref: ref,
          screen: 'task_completed',
        );
      });
      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            Text('タスク完了!', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
```

### パターン2: 目標達成時

```dart
Future<void> onGoalAchieved(BuildContext context, WidgetRef ref) async {
  // 目標達成の演出後にレビューリクエスト
  await showCelebrationAnimation();

  if (context.mounted) {
    // 達成感が高まったタイミングでレビューリクエスト
    useRatingDialog(
      context: context,
      ref: ref,
      screen: 'goal_achieved',
    );
  }
}
```

### パターン3: 使用回数ベース

```dart
class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUsageCount = ref.watch(appUsageCountProvider);

    useEffect(() {
      // 特定の使用回数（3回、5回、10回など）でレビューリクエスト
      if (appUsageCount == 5 || appUsageCount == 10) {
        Future.microtask(() {
          useRatingDialog(
            context: context,
            ref: ref,
            screen: 'home_milestone',
          );
        });
      }
      return null;
    }, [appUsageCount]);

    return Scaffold(
      // ...
    );
  }
}
```

### パターン4: 機能使用後

```dart
Future<void> onFeatureUsed(BuildContext context, WidgetRef ref) async {
  // 便利な機能を使用した直後
  final result = await usefulFeature();

  if (result.isSuccess && context.mounted) {
    // 成功体験の直後にレビューリクエスト
    useRatingDialog(
      context: context,
      ref: ref,
      screen: 'feature_success',
    );
  }
}
```

## 実装時のチェックリスト

### 表示タイミングの検討

- [ ] ユーザーがポジティブな体験をしたか？
- [ ] タスクや目標を達成した直後か？
- [ ] エラーやストレスがない状態か？
- [ ] ユーザーに時間的余裕があるか？
- [ ] アプリの価値を十分に体験したか？

### 技術的な実装

- [ ] `useRatingDialog` フックを適切な画面で使用
- [ ] 表示頻度の制限（初回のみ、または適切な間隔）
- [ ] コンテキストのマウント状態を確認
- [ ] 非同期処理の適切なハンドリング

### テストとモニタリング

- [ ] 表示タイミングのログ記録
- [ ] レビュー率のトラッキング
- [ ] ユーザーフィードバックの収集
- [ ] A/Bテストによる最適化

## `useRatingDialog` フックの使用方法

### 基本的な使用法

```dart
useRatingDialog(
  context: context,
  ref: ref,
  screen: 'screen_name', // 表示元の画面名（Analytics用）
);
```

### 主な機能

1. **自動的な表示条件管理**:
   - 初回のみ表示（ユーザーごと）
   - 適切な遅延時間の設定
   - システムのレビューダイアログを使用

2. **Analytics連携**:
   - レビューリクエスト表示のログ記録
   - ユーザー行動の分析

3. **プラットフォーム対応**:
   - iOS: `StoreKit` の `requestReview()`
   - Android: `in_app_review` パッケージ

## 推奨されるシナリオ例

### To-Doアプリの場合

```dart
// シナリオ: ユーザーが5個のタスクを完了した時
void onTaskCompleted(BuildContext context, WidgetRef ref, int completedCount) {
  if (completedCount == 5) {
    // 達成感が高いタイミングでレビューリクエスト
    useRatingDialog(context: context, ref: ref, screen: 'task_milestone');
  }
}
```

### フィットネスアプリの場合

```dart
// シナリオ: 初めての目標達成時
void onWorkoutGoalAchieved(BuildContext context, WidgetRef ref) {
  // 目標達成の喜びが高いタイミングでレビューリクエスト
  useRatingDialog(context: context, ref: ref, screen: 'goal_achieved');
}
```

### 学習アプリの場合

```dart
// シナリオ: クイズで高得点を獲得した時
void onQuizCompleted(BuildContext context, WidgetRef ref, int score) {
  if (score >= 80) {
    // 成功体験の直後にレビューリクエスト
    useRatingDialog(context: context, ref: ref, screen: 'quiz_high_score');
  }
}
```

## 注意事項

### Appleのガイドライン準拠

- ユーザーに過度な負担をかけない
- 年間3回までのレビューリクエスト制限を遵守
- システムのレビューダイアログを使用（カスタムUIは非推奨）

### ユーザー体験の最優先

- レビューリクエストはオプション（強制しない）
- 否定的な体験の直後は避ける
- タイミングが適切かどうかを継続的に検証

## まとめ

レビューダイアログの表示タイミングは、アプリのレビュー評価に大きく影響します。ユーザーがポジティブな体験をした直後に、控えめにレビューを依頼することで、高評価を獲得しやすくなります。

このテンプレートでは、`useRatingDialog` フックを実装時に最適なタイミングで使用することを推奨します。アプリの特性に応じて、上記のパターンを参考に実装してください。
