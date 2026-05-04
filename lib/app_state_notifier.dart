import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../import/provider.dart';

/// アプリ全体の状態管理対象データの更新通知を管理するプロバイダ
final appStateNotifierProvider = NotifierProvider<AppStateNotifier, TransitLog>(
  AppStateNotifier.new,
);

/// アプリ全体の状態管理対象データの変更を通知するクラス
class AppStateNotifier extends Notifier<TransitLog> {
  @override
  TransitLog build() {
    return TransitLog(from: '', to: '');
  }

  /// 画面遷移を記録します
  Future<void> _logTransitScreen() async {
    final goRouter = ref.read(goRouterProvider);
    state = state.copyWith(from: state.to, to: goRouter.location);
    await ref
        .read(firebaseAnalyticsServiceProvider)
        .transitScreen(parameters: state);
  }

  /// 画面遷移後の処理を行います
  void handleTransit({required BuildContext context}) {
    Future(_logTransitScreen);
  }
}
