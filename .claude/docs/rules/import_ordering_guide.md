# Import/Export 順序管理ガイド

## 🎯 目的

Flutter/Dartの `directives_ordering` ルールに従い、import/export文を正しい順序で管理するためのガイドです。

## 📋 基本ルール

### 1. Import文の4つのセクション

```dart
// セクション1: Dart SDK
import 'dart:async';
import 'dart:convert';

// セクション2: Flutter Framework  
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// セクション3: 外部パッケージ
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// セクション4: 相対パス
import '../model/app_error.dart';
import '../utility/logger.dart';
import 'auth_service.dart';
```

### 2. Export文の順序（lib/import/ディレクトリ）

```dart
// ディレクトリ名でアルファベット順
export '../component/button/primary_button.dart';
export '../component/card/message_card.dart';
export '../component/chip/multi_select_chip.dart';
export '../component/dialog/action_dialog.dart';

// 同一ディレクトリ内もアルファベット順
export '../component/button/cancel_button.dart';
export '../component/button/primary_button.dart';
export '../component/button/secondary_button.dart';
```

## 🛠️ 実践的な修正手順

### Step 1: 警告の確認

```bash
# 警告をチェック
flutter analyze | grep "directives_ordering"

# 結果例:
# info • Sort directive sections alphabetically • lib/import/component.dart:16:1 • directives_ordering
```

### Step 2: 該当ファイルの修正

1. **問題の特定**
   - 警告が出た行番号を確認
   - 前後の行との順序を比較

2. **正しい位置への移動**
   ```dart
   // 修正前（警告発生）
   export '../component/chip/multi_select_chip.dart';
   export '../component/question/adaptive_question_card.dart';  // ← 16行目
   export '../component/chip/single_select_chip.dart';
   
   // 修正後（アルファベット順）
   export '../component/chip/multi_select_chip.dart';
   export '../component/chip/single_select_chip.dart';
   export '../component/question/adaptive_question_card.dart';  // ← 正しい位置
   ```

### Step 3: 修正確認

```bash
# 警告数の確認
flutter analyze | grep "directives_ordering" | wc -l

# 0 になれば完了
```

## 📚 具体的な修正例

### Case 1: Import文のセクション順序違反

```dart
// ❌ 問題: 相対パスがpackageより前にある
import '../utility/logger.dart';
import 'package:flutter/material.dart';

// ✅ 修正: 正しい順序
import 'package:flutter/material.dart';
import '../utility/logger.dart';
```

### Case 2: 同一セクション内の順序違反

```dart
// ❌ 問題: アルファベット順でない
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';

// ✅ 修正: アルファベット順
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
```

### Case 3: Export文のディレクトリ順序違反

```dart
// ❌ 問題: dialog が button より前にある
export '../component/dialog/action_dialog.dart';
export '../component/button/primary_button.dart';

// ✅ 修正: ディレクトリ名のアルファベット順
export '../component/button/primary_button.dart';
export '../component/dialog/action_dialog.dart';
```

## 🚀 自動化のヒント

### 1. IDE設定でソート機能を活用

**VSCode の場合:**
```json
{
  "dart.organizeImportsOnSave": true,
  "editor.codeActionsOnSave": {
    "source.organizeImports": true
  }
}
```

### 2. Git pre-commit hookで自動チェック

```bash
#!/bin/sh
# .git/hooks/pre-commit

# import順序チェック
DIRECTIVES_COUNT=$(flutter analyze | grep "directives_ordering" | wc -l)

if [ "$DIRECTIVES_COUNT" -gt 0 ]; then
  echo "❌ Import/Export順序エラーが$DIRECTIVES_COUNT件見つかりました"
  echo "以下のコマンドで確認してください:"
  echo "flutter analyze | grep 'directives_ordering'"
  exit 1
fi

echo "✅ Import/Export順序チェック完了"
```

### 3. 定期的なチェックコマンド

```bash
# エイリアスとして登録推奨
alias import-check="flutter analyze | grep 'directives_ordering' | wc -l"
alias import-list="flutter analyze | grep 'directives_ordering'"

# 使用例
$ import-check
0  # 警告なし

$ import-list
# 警告がある場合に一覧表示
```

## 📖 よくある質問

### Q1: なぜimport順序が重要なのか？

**A:** 
- コードの可読性向上
- チーム間での一貫性保持
- コンフリクト時の解決簡素化
- Flutterの推奨ベストプラクティスに準拠

### Q2: 自動ソートツールはないか？

**A:** 
- IDEの機能（VSCode）を活用
- `flutter format` では import順序は修正されない
- サードパーティツール: `import_sorter` packageが利用可能

### Q3: ルールを無効にしたい場合は？

**A:**
```yaml
# analysis_options.yaml
linter:
  rules:
    directives_ordering: false
```

ただし、チームでの一貫性のため有効にしておくことを強く推奨します。

## 🎯 まとめ

1. **4つのセクション** を意識したimport順序
2. **各セクション内はアルファベット順**
3. **Export文はディレクトリ構造を考慮**
4. **警告が出たら即座に修正**
5. **IDEの自動ソート機能を活用**

このガイドに従うことで、`directives_ordering` 警告を根本的に解決し、保守性の高いコードを維持できます。