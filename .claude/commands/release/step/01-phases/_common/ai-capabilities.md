# AI機能対応表（Gemini API）

**唯一対応**: Firebase AI経由 Gemini 2.5 Flash

## 対応機能

| 機能 | メソッド | 用途例 |
|------|---------|--------|
| テキスト生成 | `sendMessage()` | チャット、要約、コンテンツ生成 |
| ストリーミング | `streamMessage()` | リアルタイム応答表示 |
| 画像理解 | マルチモーダル入力 | 画像分析、OCR的処理 |
| 音声理解 | 音声ファイル入力 | 音声→テキスト変換 |
| 会話履歴 | `conversationHistory` | マルチターン会話 |

## 非対応機能（設計に含めない）

| 機能 | 理由 |
|------|------|
| 音声合成（TTS） | Gemini API非対応 |
| リアルタイム音声会話 | TTS必要 |
| 動画生成 | 非対応 |
| OpenAI/Claude API | 非対応 |

## 実装方法

```dart
import 'package:flutter_foundation/flutter_foundation.dart';

final geminiService = GeminiService();

// 一括応答
final response = await geminiService.sendMessage(message: 'こんにちは');

// ストリーミング
await for (final chunk in geminiService.streamMessage(message: '説明して')) {
  print(chunk);
}
```
