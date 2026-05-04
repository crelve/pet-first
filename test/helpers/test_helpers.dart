import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;

/// テスト用のProviderScopeをラップしたWidget
class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.child, this.overrides = const []});

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

/// テスト用のヘルパー関数
class TestHelpers {
  TestHelpers._(); // private constructor to prevent instantiation

  /// ProviderContainerを作成する
  static ProviderContainer createContainer({
    List<Override> overrides = const [],
  }) {
    return ProviderContainer(overrides: overrides);
  }

  /// 非同期処理をテストする際のヘルパー
  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    var found = false;
    final end = DateTime.now().add(timeout);

    while (!found && DateTime.now().isBefore(end)) {
      await tester.pump();
      found = tester.any(finder);

      if (!found) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }

    if (!found) {
      throw Exception('Widget not found within timeout period');
    }
  }

  /// テスト用のダミーVoidCallback
  static void dummyCallback() {
    // ダミーのコールバック関数
  }

  /// テスト用の非同期ダミー処理
  static Future<void> dummyAsyncCallback() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  /// エラーをスローするダミー処理
  static void throwingCallback() {
    throw Exception('Test exception');
  }

  /// エラーをスローする非同期ダミー処理
  static Future<void> throwingAsyncCallback() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    throw Exception('Test async exception');
  }
}

/// テスト用の定数
class TestConstants {
  TestConstants._(); // private constructor to prevent instantiation

  /// テスト用の文字列
  static const testString = 'Test String';
  static const testButtonText = 'Test Button';
  static const testScreenName = 'test_screen';

  /// テスト用の数値
  static const testNumber = 42;
  static const testWidth = 200;
  static const testHeight = 50;

  /// テスト用のDuration
  static const shortDelay = Duration(milliseconds: 10);
  static const mediumDelay = Duration(milliseconds: 100);
  static const longDelay = Duration(seconds: 1);
}
