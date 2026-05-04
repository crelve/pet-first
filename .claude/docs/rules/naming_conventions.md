# 命名規則ガイド (Naming Conventions Guide)

## 概要

このドキュメントでは、flutter-templateプロジェクトにおける命名規則を定義します。特にFirebase統合においては、厳格な命名制約を遵守する必要があります。

---

## 📋 目次

1. [プロジェクト名 (Project Name)](#プロジェクト名-project-name)
2. [Firebase プロジェクトID](#firebase-プロジェクトid)
3. [Dartパッケージ名](#dartパッケージ名)
5. [iOS Bundle ID](#ios-bundle-id)
6. [ファイル・ディレクトリ名](#ファイルディレクトリ名)
7. [クラス・変数名](#クラス変数名)

---

## プロジェクト名 (Project Name)

### 基本ルール

プロジェクト名は **Firebase プロジェクトID制約** に準拠する必要があります。

### 必須制約

- **長さ**: 6-30文字
- **文字種**: **小文字、数字、ハイフン（`-`）のみ**
- **使用不可文字**:
  - ❌ アンダースコア（`_`）
  - ❌ 大文字
  - ❌ 特殊文字（`!@#$%^&*()+=[]{}|;:'",.<>?/\`~`）
- **先頭・末尾**: アルファベット（ハイフン不可）
- **形式**: ケバブケース（kebab-case）

### ✅ 正しい例

```
habit-flow
quick-shop
study-timer-pro
daily-planner
fitness-tracker
budget-keeper
note-master
task-flow
meal-plan
travel-log
```

### ❌ 誤った例

```
habit_flow          # アンダースコア不可
HabitFlow           # 大文字不可
habitFlow           # キャメルケース不可
habit-flow-         # 末尾ハイフン不可
-habit-flow         # 先頭ハイフン不可
habit.flow          # ドット不可
habit flow          # スペース不可
habit_flow-pro      # アンダースコアとハイフン混在不可
h-f                 # 6文字未満
very-long-project-name-exceeding-limit  # 30文字超過
```

### 理由

Firebase プロジェクトIDは Google Cloud Platform 全体で一意である必要があり、厳格な制約があります。プロジェクト名がこの制約に違反すると：

1. Firebase プロジェクト作成が失敗する
2. 自動化スクリプト（`make create-firebase-project`）がエラーになる
3. 手動での名前変換が必要になり、工数が増加する

---

## Firebase プロジェクトID

### 命名パターン

```
{project-name}-{environment}
```

### 環境別サフィックス

- **開発環境**: `-dev`
- **本番環境**: `-prod`

### 例

```
# プロジェクト名: habit-flow
habit-flow-dev      # 開発環境
habit-flow-prod     # 本番環境

# プロジェクト名: quick-shop
quick-shop-dev      # 開発環境
quick-shop-prod     # 本番環境
```

### 自動生成

以下のコマンドでFirebaseプロジェクトが自動生成されます：

```bash
make create-firebase-project PROJECT_NAME=habit-flow
# → 生成: habit-flow-dev, habit-flow-prod
```

---

## Dartパッケージ名

### 変換ルール

プロジェクト名のハイフン（`-`）をアンダースコア（`_`）に変換します。

### 命名パターン

```
{project_name}
```

### 例

```
# プロジェクト名: habit-flow
# Dartパッケージ名: habit_flow

# pubspec.yaml
name: habit_flow

# Dartインポート
import 'package:habit_flow/screen/home/home_screen.dart';
```

### 自動変換

```bash
make replace-content PROJECT_NAME=habit-flow
# → pubspec.yaml の name: habit_flow に自動変換
# → 全Dartファイルのインポート文を自動置換
```

---

## iOS Bundle ID

### 命名パターン

```
com.example.{project.name}.mobile
```

### 変換ルール

iOSパッケージ名と同一の形式を使用します。

### 例

```
# プロジェクト名: habit-flow
com.example.habit.flow.mobile

# プロジェクト名: quick-shop
com.example.quick.shop.mobile
```

### Flavor対応

```
# 開発環境 (dev flavor)
com.example.habit.flow.mobile.dev

# 本番環境 (prod flavor)
com.example.habit.flow.mobile.prod
```

### 設定ファイル

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>

<key>CFBundleDisplayName</key>
<string>Habit Flow</string>

<key>CFBundleName</key>
<string>habit-flow</string>
```

---

## ファイル・ディレクトリ名

### Dartファイル

**形式**: `snake_case.dart`

```
✅ 正しい例:
home_screen.dart
user_profile_card.dart
auth_provider.dart
firebase_service.dart

❌ 誤った例:
HomeScreen.dart        # パスカルケース不可
home-screen.dart       # ケバブケース不可
homeScreen.dart        # キャメルケース不可
```

### ディレクトリ

**形式**: `snake_case`

```
✅ 正しい例:
lib/screen/home/
lib/component/button/
lib/provider/auth/
lib/utility/date_helper/

❌ 誤った例:
lib/Screen/Home/       # パスカルケース不可
lib/component-button/  # ケバブケース不可
```

### アセット

**形式**: `kebab-case` または `snake_case`

```
✅ 正しい例:
assets/images/logo-icon.png
assets/images/user_avatar.png
assets/fonts/roboto-regular.ttf
```

---

## クラス・変数名

### クラス名

**形式**: `PascalCase`

```dart
✅ 正しい例:
class HomeScreen extends HookConsumerWidget {}
class UserProfileCard extends StatelessWidget {}
class AuthProvider extends StateNotifier<AuthState> {}

❌ 誤った例:
class homeScreen {}        // 小文字始まり不可
class home_screen {}       // スネークケース不可
class home-screen {}       // ケバブケース不可
```

### 変数・関数名

**形式**: `camelCase`

```dart
✅ 正しい例:
final userName = 'John';
int calculateTotal() {}
bool isLoggedIn = false;
TextEditingController searchController;

❌ 誤った例:
final UserName = 'John';       // パスカルケース不可
int calculate_total() {}       // スネークケース不可
bool is-logged-in = false;     // ケバブケース不可
```

### 定数

**形式**: `lowerCamelCase` または `SCREAMING_SNAKE_CASE`

```dart
✅ 正しい例:
const apiUrl = 'https://api.example.com';
const MAX_RETRY_COUNT = 3;
const defaultTimeout = Duration(seconds: 30);

❌ 誤った例:
const APIUrl = 'https://api.example.com';  // 一部大文字不可
const max-retry-count = 3;                  // ケバブケース不可
```

### プライベート変数

**形式**: `_camelCase` (アンダースコアプレフィックス)

```dart
✅ 正しい例:
String _userId;
int _calculateScore() {}
final _authService = AuthService();

❌ 誤った例:
String userId_;           // サフィックス不可
int __calculateScore() {} // 二重アンダースコア不可
```

---

## 自動変換スクリプト

### プロジェクト名一括置換

```bash
# Makefileで自動変換
make replace-content PROJECT_NAME=habit-flow

# 実行される処理:
# 1. pubspec.yaml: name: habit_flow
# 2. Dartインポート: package:habit_flow/...
# 3. iOS: com.example.habit.flow.mobile
# 4. Firebase: habit-flow-dev, habit-flow-prod
```

### 検証コマンド

```bash
# プロジェクト名の妥当性を検証（今後実装予定）
make validate-project-name PROJECT_NAME=habit-flow

# 期待される出力:
# ✅ Project name is valid
# ✅ Length: 10 characters (6-30)
# ✅ Format: kebab-case
# ✅ Characters: lowercase, digits, hyphens only
# ✅ Start/End: alphabetic characters
```

---

## チェックリスト

新しいプロジェクトを作成する際は、以下を確認してください：

### プロジェクト名
- [ ] 6-30文字の範囲内
- [ ] 小文字、数字、ハイフン（`-`）のみ使用
- [ ] アンダースコア（`_`）を使用していない
- [ ] 大文字を使用していない
- [ ] 先頭・末尾がアルファベット
- [ ] ケバブケース（kebab-case）形式

### Firebase プロジェクトID
- [ ] `{project-name}-dev` 形式で開発環境作成済み
- [ ] `{project-name}-prod` 形式で本番環境作成済み
- [ ] `.firebaserc` に正しく登録済み

### Dartパッケージ名
- [ ] `pubspec.yaml` の `name` がスネークケース（`habit_flow`）
- [ ] 全Dartファイルのインポートが `package:habit_flow/...` 形式

### ネイティブパッケージ名
- [ ] iOS: `com.example.habit.flow.mobile` 形式
- [ ] Flavor別設定が正しい（`.dev` / `.prod`）

---

## トラブルシューティング

### Q: プロジェクト名にアンダースコアを使ってしまった

```bash
# 誤: habit_flow
# 正: habit-flow

# 対処法: プロジェクト名を変更して再実行
make replace-content PROJECT_NAME=habit-flow
```

### Q: Firebase プロジェクト作成でエラー

```
Error: Invalid project ID: underscores are not allowed
```

**対処法**: プロジェクト名をケバブケースに変更

```bash
# 誤: habit_flow
firebase projects:create habit_flow-dev  # エラー

# 正: habit-flow
firebase projects:create habit-flow-dev  # 成功
```

### Q: Dartインポートでエラー

```dart
// 誤:
import 'package:habit-flow/screen/home/home_screen.dart';  // エラー

// 正:
import 'package:habit_flow/screen/home/home_screen.dart';  // 成功
```

---

## 参考リンク

- [Firebase Project ID Constraints](https://firebase.google.com/docs/projects/learn-more#project-id)
- [Dart Package Naming](https://dart.dev/tools/pub/pubspec#name)
- [Effective Dart: Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [iOS Bundle ID](https://developer.apple.com/documentation/appstoreconnectapi/bundle_ids)

---

## 更新履歴

- **2025-10-10**: 初版作成 - Firebase制約に準拠したプロジェクト命名規則を定義
