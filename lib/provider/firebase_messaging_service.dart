import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';

/// FirebaseMessagingを操作するサービスクラス
///
/// FCMトークンの取得・管理は flutter_foundation の `PushNotificationStateNotifier` が担う。
/// トークンが必要な場合は呼び出し側で以下のように取得すること:
/// ```dart
/// final token = ref.read(pushNotificationStateNotifierProvider).token;
/// ```
class FirebaseMessagingService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-northeast1',
  );

  /// Push通知を送信します
  ///
  /// `ref.read(pushNotificationStateNotifierProvider).token` から取得して渡す。
  Future<void> sendPushNotification({
    required String title,
    required String body,
    required String token,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (title.isEmpty || body.isEmpty || token.isEmpty) {
      logger.e('Invalid arguments: title, body, or token is empty');
      return;
    }

    try {
      final callable = _functions.httpsCallable('sendPushNotification');
      // ignore: inference_failure_on_function_invocation
      final result = await callable.call({
        'title': title,
        'body': body,
        'token': token,
      });
      logger.d('result.data: ${result.data}');
    } on Exception catch (e) {
      logger.e('FCM notification error: $e');
      final dialogStateNotifier = ref.watch(
        dialogStateNotifierProvider.notifier,
      );
      if (context.mounted) {
        await dialogStateNotifier.showActionDialog(
          screen: l10n.fcmNotification,
          title: l10n.error,
          content: e.toString(),
          buttonLabel: l10n.close,
          barrierDismissible: false,
          callback: () {},
          context: context,
        );
      }
    }
  }
}
