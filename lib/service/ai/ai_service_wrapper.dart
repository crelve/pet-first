import 'dart:async';

import 'package:flutter_foundation/flutter_foundation.dart';

import 'ai_exception.dart';

/// タイムアウト・エラーハンドリング付きAIサービスラッパー
///
/// GeminiServiceをラップして以下の機能を追加:
/// - 30秒タイムアウト
/// - 型付きエラーハンドリング
/// - ログ出力
class AiServiceWrapper {
  /// コンストラクタ
  ///
  /// [locale] を指定すると、AIがそのロケールの言語で回答する（例: 'ja', 'en', 'zh'）
  AiServiceWrapper({
    GeminiService? geminiService,
    this.timeout = defaultTimeout,
    String? locale,
  }) : _geminiService = geminiService ?? GeminiService(locale: locale);

  /// デフォルトタイムアウト: 30秒
  static const defaultTimeout = Duration(seconds: 30);

  final GeminiService _geminiService;

  /// タイムアウト時間
  final Duration timeout;

  /// テキストメッセージを送信（タイムアウト付き）
  ///
  /// [message] ユーザーからのメッセージ
  /// [conversationHistory] 会話履歴（オプション）
  ///
  /// Returns: AIからの応答テキスト
  ///
  /// Throws: [AiException] タイムアウトまたはエラー時
  Future<String> sendMessage({
    required String message,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final response = await _geminiService
          .sendMessage(
            message: message,
            conversationHistory: conversationHistory,
          )
          .timeout(
            timeout,
            onTimeout: () => throw AiTimeoutException(timeout: timeout),
          );
      return response;
    } on AiException {
      rethrow;
    } on Exception catch (e) {
      throw e.toAiException();
    }
  }

  /// ストリーミング形式でメッセージを送信（タイムアウト付き）
  ///
  /// 最初のチャンクが30秒以内に届かない場合タイムアウト
  ///
  /// [message] ユーザーからのメッセージ
  /// [conversationHistory] 会話履歴（オプション）
  ///
  /// Returns: AIからの応答テキストのストリーム
  ///
  /// Throws: [AiException] タイムアウトまたはエラー時
  Stream<String> streamMessage({
    required String message,
    List<Map<String, String>>? conversationHistory,
  }) async* {
    try {
      final stream = _geminiService.streamMessage(
        message: message,
        conversationHistory: conversationHistory,
      );

      var isFirstChunk = true;
      Timer? timeoutTimer;

      await for (final chunk in stream) {
        if (isFirstChunk) {
          isFirstChunk = false;
          timeoutTimer?.cancel();
        } else {
          // 各チャンク間のタイムアウトをリセット
          timeoutTimer?.cancel();
          timeoutTimer = Timer(timeout, () {
            throw AiTimeoutException(timeout: timeout);
          });
        }
        yield chunk;
      }

      timeoutTimer?.cancel();
    } on AiException {
      rethrow;
    } on Exception catch (e) {
      throw e.toAiException();
    }
  }

  /// ストリーミング形式でメッセージを送信（初回タイムアウト付き）
  ///
  /// 最初のチャンクが[timeout]秒以内に届かない場合タイムアウト
  /// チャンク間のタイムアウトは発生しない（長いレスポンス対応）
  Stream<String> streamMessageWithInitialTimeout({
    required String message,
    List<Map<String, String>>? conversationHistory,
  }) {
    final controller = StreamController<String>();

    () async {
      try {
        final stream = _geminiService.streamMessage(
          message: message,
          conversationHistory: conversationHistory,
        );

        var isFirstChunk = true;
        Timer? initialTimer;

        // 初回タイムアウトタイマーを設定
        initialTimer = Timer(timeout, () {
          if (isFirstChunk) {
            controller
              ..addError(AiTimeoutException(timeout: timeout))
              ..close();
          }
        });

        await for (final chunk in stream) {
          if (isFirstChunk) {
            isFirstChunk = false;
            initialTimer.cancel();
          }
          controller.add(chunk);
        }

        await controller.close();
      } on AiException catch (e) {
        controller.addError(e);
        await controller.close();
      } on Object catch (e) {
        controller.addError(e.toAiException());
        await controller.close();
      }
    }();

    return controller.stream;
  }

  /// 会話履歴をクリア
  void clearHistory() {
    _geminiService.clearHistory();
  }

  /// APIキーが設定されているかチェック
  bool get isConfigured => _geminiService.isConfigured;
}
