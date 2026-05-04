# API ドキュメントコメント 実践ガイド

## 🎯 目的

Flutter/Dartの `public_member_api_docs` ルールに従い、すべての公開メンバーに適切なドキュメントコメントを記述するためのガイドです。

## 📋 基本ルール

### 1. 必須対象

以下の公開メンバーには **必ず** ドキュメントコメントが必要：

- ✅ **public クラス**
- ✅ **public プロパティ** 
- ✅ **public メソッド**
- ✅ **public getter/setter**
- ✅ **public constructor**
- ✅ **enum の値**
- ✅ **extension の public メソッド**

### 2. 対象外（private メンバー）

- ❌ `_` で始まるプライベートメンバー
- ❌ `@internal` アノテーション付きメンバー
- ❌ test ファイル内のメンバー

## 🛠️ パターン別テンプレート

### Pattern 1: Freezed データクラス

```dart
/// [テンプレート] Freezed データクラス
/// 
/// [説明] このクラスの用途と責務
@freezed
class ClassName with _$ClassName {
  const factory ClassName({
    /// [説明] このプロパティの用途
    required String propertyName,
    
    /// [説明] このプロパティの用途（デフォルト値あり）
    @Default(value) Type propertyWithDefault,
  }) = _ClassName;

  /// JSON からインスタンスを作成
  factory ClassName.fromJson(Map<String, dynamic> json) =>
      _$ClassNameFromJson(json);
}

/// [テンプレート] Freezed 拡張メソッド
extension ClassNameExtension on ClassName {
  /// [説明] この computed property の用途
  bool get computedProperty => /* 実装 */;
  
  /// [説明] このメソッドの用途
  /// 
  /// [param] パラメータの説明
  /// Returns: 戻り値の説明
  ReturnType methodName(ParamType param) {
    // 実装
  }
}
```

### Pattern 2: HookConsumerWidget

```dart
/// [テンプレート] Widget コンポーネント
/// 
/// [説明] このWidgetの用途と表示内容
class WidgetName extends HookConsumerWidget {
  /// [説明] このプロパティの用途
  final String requiredProperty;
  
  /// [説明] このプロパティの用途（オプション）
  final VoidCallback? optionalProperty;

  /// WidgetName を作成
  /// 
  /// [requiredProperty] 必須プロパティの説明
  /// [optionalProperty] オプションプロパティの説明
  const WidgetName({
    super.key,
    required this.requiredProperty,
    this.optionalProperty,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 実装
  }
}
```

### Pattern 3: Riverpod Provider

```dart
/// [テンプレート] Riverpod Provider クラス
/// 
/// [説明] この Provider の責務とデータ
@riverpod
class ProviderName extends _$ProviderName {
  @override
  Future<DataType> build() async {
    // 初期化処理
  }

  /// [説明] このメソッドの用途
  /// 
  /// [param] パラメータの説明
  /// 
  /// Throws: [ExceptionType] エラー条件の説明
  Future<void> methodName(ParamType param) async {
    // 実装
  }
}

/// [テンプレート] 単純な Provider 関数
/// 
/// [説明] この Provider の責務
@riverpod
Future<DataType> providerFunction(ProviderFunctionRef ref) async {
  // 実装
}
```

### Pattern 4: Service/Repository クラス

```dart
/// [テンプレート] Service クラス
/// 
/// [説明] このサービスの責務と提供機能
class ServiceName {
  /// [説明] 依存関係の説明
  final DependencyType _dependency;

  /// ServiceName を作成
  /// 
  /// [dependency] 依存関係の説明。nullの場合はデフォルト実装
  ServiceName({
    DependencyType? dependency,
  }) : _dependency = dependency ?? DefaultImplementation();

  /// [説明] このメソッドの用途
  /// 
  /// [param1] パラメータ1の説明
  /// [param2] パラメータ2の説明（オプション）
  /// 
  /// Returns: 戻り値の説明
  /// Throws: [ExceptionType] エラー条件の説明
  Future<ReturnType> methodName(
    ParamType1 param1, {
    ParamType2? param2,
  }) async {
    // 実装
  }
}
```

### Pattern 5: Enum

```dart
/// [テンプレート] Enum 型
/// 
/// [説明] この列挙型の用途
enum EnumName {
  /// [説明] この値の意味
  value1('value1'),
  
  /// [説明] この値の意味
  value2('value2');

  /// [説明] コンストラクタの説明
  const EnumName(this.rawValue);
  
  /// [説明] このプロパティの用途
  final String rawValue;

  /// [説明] このメソッドの用途
  /// 
  /// [rawValue] パラメータの説明
  /// Returns: 戻り値の説明。見つからない場合は null
  static EnumName? fromRawValue(String rawValue) {
    // 実装
  }
}
```

## 🚀 効率的な修正フロー

### Step 1: 警告の一覧取得

```bash
# 全体の警告数を確認
flutter analyze | grep "public_member_api_docs" | wc -l

# ファイル別の警告数を確認
flutter analyze | grep "public_member_api_docs" | cut -d':' -f1 | sort | uniq -c

# 特定ファイルの警告詳細
flutter analyze lib/model/learning_card.dart | grep "public_member_api_docs"
```

### Step 2: 優先順位付け

1. **High Priority**: データモデル（Freezed クラス）
2. **Medium Priority**: Widget コンポーネント
3. **Low Priority**: Extension メソッド

### Step 3: バッチ修正

同じファイル内の警告をまとめて修正：

```bash
# 1つのファイルの警告を全て表示
flutter analyze lib/model/learning_card.dart | grep "public_member_api_docs"

# 結果例:
# info • Missing documentation for a public member • lib/model/learning_card.dart:39:3
# info • Missing documentation for a public member • lib/model/learning_card.dart:41:3  
# info • Missing documentation for a public member • lib/model/learning_card.dart:43:3
```

## 📝 実際の修正例

### Before (警告あり)

```dart
// ❌ 警告が発生するコード
@freezed
class LearningCard with _$LearningCard {
  const factory LearningCard({
    required String id,           // ← 警告: line 39
    required String title,        // ← 警告: line 41  
    required String content,      // ← 警告: line 43
    required DateTime createdAt,  // ← 警告: line 45
    @Default(1) int difficulty,   // ← 警告: line 47
  }) = _LearningCard;

  factory LearningCard.fromJson(Map<String, dynamic> json) =>
      _$LearningCardFromJson(json);
}

extension LearningCardExtension on LearningCard {
  bool get isEasy => difficulty <= 2;     // ← 警告
  bool get isHard => difficulty >= 4;     // ← 警告
}
```

### After (修正後)

```dart
// ✅ 警告が解消されるコード
/// 学習カードのデータモデル
/// 
/// ユーザーが作成した学習カードの情報を管理
@freezed
class LearningCard with _$LearningCard {
  const factory LearningCard({
    /// カードの一意識別子
    required String id,
    
    /// カードのタイトル（質問文）
    required String title,
    
    /// カードの回答内容  
    required String content,
    
    /// カードの作成日時
    required DateTime createdAt,
    
    /// カードの難易度レベル（1-5）
    @Default(1) int difficulty,
  }) = _LearningCard;

  /// JSON からインスタンスを作成
  factory LearningCard.fromJson(Map<String, dynamic> json) =>
      _$LearningCardFromJson(json);
}

/// 学習カードの拡張メソッド
extension LearningCardExtension on LearningCard {
  /// カードが簡単かどうかを判定
  bool get isEasy => difficulty <= 2;
  
  /// カードが難しいかどうかを判定
  bool get isHard => difficulty >= 4;
}
```

## 🎯 品質チェックリスト

### ✅ 良いドキュメントコメントの特徴

- [ ] **簡潔明瞭** - 1行で要点を説明
- [ ] **目的志向** - 「何をするか」を重視  
- [ ] **パラメータ説明** - 引数の意味と制約を記載
- [ ] **戻り値説明** - 複雑な戻り値の場合は詳述
- [ ] **例外説明** - 想定されるエラーを記載
- [ ] **例示** - 複雑なAPIは使用例を記載

### ❌ 避けるべきドキュメントコメント

- [ ] **実装詳細の露出** - 内部処理の説明は不要
- [ ] **型情報の重複** - Dartで自明な情報は省略
- [ ] **意味のない説明** - 「IDを返す」など当然の内容
- [ ] **コードとの不整合** - 実装と異なる説明
- [ ] **過度な詳細** - API利用者に不要な情報

## 🔧 自動化ツール

### 1. VSCode Extension設定

```json
{
  "dart.showTodos": true,
  "dart.analysisExcludedFolders": [
    "build"
  ],
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

### 2. Git Pre-commit Hook

```bash
#!/bin/sh
# .git/hooks/pre-commit

# API ドキュメント不足チェック
DOCS_COUNT=$(flutter analyze | grep "public_member_api_docs" | wc -l)

if [ "$DOCS_COUNT" -gt 0 ]; then
  echo "❌ API ドキュメント不足が$DOCS_COUNT件見つかりました"
  echo "以下のコマンドで確認してください:"
  echo "flutter analyze | grep 'public_member_api_docs'"
  exit 1
fi

echo "✅ API ドキュメントチェック完了"
```

### 3. 定期的な品質チェック

```bash
# エイリアス設定推奨
alias doc-check="flutter analyze | grep 'public_member_api_docs' | wc -l"
alias doc-list="flutter analyze | grep 'public_member_api_docs'"
alias doc-files="flutter analyze | grep 'public_member_api_docs' | cut -d':' -f1 | sort | uniq -c"

# 使用例
$ doc-check
42  # 42件の警告

$ doc-files  
   5 lib/model/learning_card.dart
   3 lib/model/learning_goal.dart
   8 lib/service/auth/auth_service.dart
```

## 📚 参考リソース

### Dart公式ドキュメント

- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)
- [dartdoc Documentation](https://dart.dev/tools/dart-doc)

### コメント記法

- `///` - ドキュメントコメント
- `[paramName]` - パラメータ参照
- `Returns:` - 戻り値説明
- `Throws:` - 例外説明
- `` `code` `` - インラインコード
- ```` ```dart ... ``` ```` - コードブロック

## 🎉 まとめ

1. **全公開メンバーに `///` コメント必須**
2. **テンプレートを活用して効率化**
3. **警告は見つけ次第即座に修正**
4. **自動化ツールで品質担保**
5. **チーム全体でルール共有**

このガイドに従うことで、`public_member_api_docs` 警告を根本的に解決し、保守性の高いAPIドキュメントを維持できます。