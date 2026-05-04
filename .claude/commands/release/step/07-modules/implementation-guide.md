# 🛠️ 実装ガイド


## 目的
本番環境品質での完全実装（プロトタイプ・部分実装禁止）

---

## 実装完了の定義

✅ すべての要件が実装済み（部分実装禁止）
✅ TODOコメント・FIXMEコメントが0件
✅ ハードコードされた仮データが0件
✅ すべてのエッジケースでエラーハンドリング実装済み
✅ ユーザー向け本番環境品質のUI/UX実装済み
✅ パフォーマンス最適化実装済み（lazy loading等）

---

## 実装プロセス

### 1. プロジェクト構造の確認

```bash
# Serena で既存構造を効率的に確認
mcp__serena__list_dir relative_path="lib" recursive=true
mcp__serena__get_symbols_overview relative_path="lib/provider/example_provider.dart"
```

### 2. モデル実装（Freezed使用）

```dart
// lib/model/example/example_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

@freezed
class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
    required String title,
    String? description,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
}
```

### 3. Provider実装（Riverpod）

```dart
// lib/provider/example/example_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../import/model.dart';

part 'example_provider.g.dart';

@riverpod
class ExampleNotifier extends _$ExampleNotifier {
  @override
  List<ExampleModel> build() => [];

  void addItem(ExampleModel item) {
    state = [...state, item];
  }
}
```

### 4. コンポーネント実装（HookConsumerWidget）

**重要**: Text()を直接使用せず、必ず`ThemeText()`を使用すること

```dart
// lib/component/example/example_card.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../import/component.dart';  // ThemeTextをimport
import '../../import/theme.dart';
import '../../import/model.dart';

class ExampleCard extends HookConsumerWidget {
  const ExampleCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final ExampleModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return Card(
      child: ListTile(
        title: ThemeText(
          text: item.title,
          color: theme.appColors.black,
          style: theme.textTheme.h30.bold(),
        ),
        subtitle: item.description != null
            ? ThemeText(
                text: item.description!,
                color: theme.appColors.textSecondary,
                style: theme.textTheme.h20,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
```

**❌ 禁止**: `Text()`, `Text.rich()` の直接使用
**✅ 必須**: `ThemeText()` を使用（色・スタイル統一）
```

### 5. エラーハンドリング実装

```dart
// 本番環境品質のエラーハンドリング
try {
  await someAsyncOperation();
} on NetworkException catch (e) {
  // ユーザーフレンドリーなエラーメッセージ
  showSnackBar(context, 'ネットワーク接続を確認してください');
  logger.error('Network error: $e');
} on ValidationException catch (e) {
  showSnackBar(context, '入力内容を確認してください');
  logger.error('Validation error: $e');
} catch (e) {
  showSnackBar(context, '予期しないエラーが発生しました');
  logger.error('Unexpected error: $e');
}
```

### 6. テスト実装

```dart
// test/unit/provider/example_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('ExampleNotifier', () {
    test('初期状態は空リスト', () {
      final container = ProviderContainer();
      final notifier = container.read(exampleNotifierProvider);
      expect(notifier, isEmpty);
    });

    test('アイテムを追加できる', () {
      final container = ProviderContainer();
      final notifier = container.read(exampleNotifierProvider.notifier);

      final item = ExampleModel(id: '1', title: 'Test');
      notifier.addItem(item);

      final state = container.read(exampleNotifierProvider);
      expect(state, contains(item));
    });
  });
}
```

---

## コード生成

```bash
# Freezed/Riverpod コード生成
make update-gen

# または
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🤖 Claude Code への指示

**トークン効率化:**
- 既存コードは Serena でシンボル単位読み込み
- コード生成後の確認は `flutter analyze` で代替
- テストは並列実行可能
