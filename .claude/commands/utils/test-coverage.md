## Test Coverage

テストカバレッジの測定と品質向上、テスト戦略の最適化を支援します。

### 使い方

```bash
# 基本カバレッジ測定
make test
「テスト実行結果とカバレッジを分析し、改善点を提案してください」

# 詳細カバレッジレポート
fvm flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
「カバレッジレポートを解析し、テスト不足箇所と優先度を評価してください」

# 特定ディレクトリのテスト
fvm flutter test test/unit/ --coverage
「ユニットテストのカバレッジと品質を分析してください」
```

### カバレッジ分析

```
📊 Coverage Metrics
├─ Line Coverage (行カバレッジ)
├─ Function Coverage (関数カバレッジ)
├─ Branch Coverage (分岐カバレッジ)
└─ Statement Coverage (文カバレッジ)

🎯 Coverage Targets
├─ Critical Path: 90%+
├─ Business Logic: 80%+
├─ UI Components: 60%+
└─ Utilities: 95%+

🔍 Quality Indicators
├─ Test Maintainability
├─ Test Performance
├─ Test Reliability
└─ Test Documentation
```

### 詳細分析

```bash
# ファイル別カバレッジ
fvm flutter test --coverage && lcov --list coverage/lcov.info
「ファイル別カバレッジ状況を分析し、優先的にテストすべきファイルを特定してください」

# 未テスト関数の特定
fvm flutter test --coverage && lcov --list-full-path -q coverage/lcov.info | grep -E "0\.0%|no data"
「テストされていない関数とクラスを特定し、テスト追加の優先度を評価してください」

# カバレッジ品質評価
find test/ -name "*.dart" -exec wc -l {} + | sort -rn
「テストコードの量と質を評価し、改善機会を提案してください」
```

### テスト戦略分析

```bash
# テストタイプ別分析
find test/ -name "*_test.dart" | grep -E "unit|widget|integration"
「ユニット・Widget・統合テストのバランスを評価してください」

# テスト実行時間分析
time fvm flutter test
「テスト実行時間とパフォーマンスボトルネックを分析してください」

# テストファイル構造分析
tree test/
「テスト構造の組織化と保守性を評価してください」
```

### カバレッジレポート形式

```markdown
## テストカバレッジレポート

### 全体サマリー
- **総合カバレッジ**: X.X%
- **実行テスト数**: X個
- **テスト時間**: X秒
- **成功率**: X.X%

### カバレッジ詳細

| Category | Lines | Functions | Branches | Target | Status |
|----------|-------|-----------|----------|--------|--------|
| Models | X% | X% | X% | 95% | ✅/⚠️/❌ |
| Providers | X% | X% | X% | 90% | ✅/⚠️/❌ |
| Screens | X% | X% | X% | 70% | ✅/⚠️/❌ |
| Components | X% | X% | X% | 80% | ✅/⚠️/❌ |
| Utilities | X% | X% | X% | 95% | ✅/⚠️/❌ |

### 優先改善箇所

#### 🔴 Critical (カバレッジ < 50%)
1. **lib/provider/auth_provider.dart** (25.3%)
   - 未テスト: signIn, signOut, refreshToken
   - 影響度: High (認証機能)
   - 推奨: 認証フロー統合テスト追加

#### 🟡 Moderate (カバレッジ < 70%)
[同様の形式]

#### 🟢 Good (カバレッジ >= 70%)
[同様の形式]

### テスト品質分析

#### Test Pyramid Balance
```
    /\     Integration (5%)  目標: 10%
   /  \    Widget (25%)      目標: 20%  
  /____\   Unit (70%)        目標: 70%
```

#### Test Performance
- 平均実行時間: X秒
- 最遅テスト: test_name (X秒)
- 最多実行: test_name (X回)

### 推奨アクション

#### 即座対応 (Critical Coverage)
1. **認証プロバイダー**
   ```dart
   // test/provider/auth_provider_test.dart
   group('AuthProvider', () {
     test('signIn success', () async { /* ... */ });
     test('signIn failure', () async { /* ... */ });
   });
   ```

2. **データモデル**
   ```dart
   // test/model/user_model_test.dart
   test('User.fromJson', () { /* ... */ });
   ```

#### 短期対応 (Moderate Coverage)
[具体的なテストケース提案]

#### 長期対応 (Quality Improvement)
[リファクタリングとテスト戦略改善]
```

### Flutter特化テスト戦略

```bash
# Widget テスト分析
find test/ -name "*_test.dart" -exec grep -l "testWidgets" {} \;
「Widgetテストのカバレッジと相互作用テストを評価してください」

# 状態管理テスト
grep -r "ProviderScope\|ProviderContainer" test/ --include="*.dart"
「Riverpod/Provider状態管理のテスト戦略を評価してください」

# ゴールデンテスト
find test/ -name "*.png" | head -10
「ゴールデンテストの活用状況とUI回帰テストを確認してください」
```

### 自動化設定

```bash
# カバレッジ自動測定
# .github/workflows/coverage.yml
name: Coverage
on: [push, pull_request]
jobs:
  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### カバレッジ改善テクニック

```dart
// 1. テスタブル設計
class UserService {
  final HttpClient client;
  UserService({required this.client}); // 依存注入
  
  Future<User> getUser(String id) => client.get('/users/$id');
}

// 2. モック活用
void main() {
  late MockHttpClient mockClient;
  late UserService service;
  
  setUp(() {
    mockClient = MockHttpClient();
    service = UserService(client: mockClient);
  });
}

// 3. エッジケース網羅
test('handles network error', () async {
  when(mockClient.get(any)).thenThrow(NetworkException());
  expect(() => service.getUser('123'), throwsA(isA<NetworkException>()));
});
```

### 継続的改善

```
📈 Coverage Trends
├─ 週次カバレッジ推移
├─ 新機能カバレッジ義務
├─ リグレッションテスト強化
└─ パフォーマンステスト追加

🎯 Quality Gates
├─ PR時最低カバレッジ
├─ Critical Path 100%
├─ New Code 80%+
└─ Overall 70%+

🔄 Review Process
├─ テストコードレビュー
├─ カバレッジレポート確認
├─ エッジケース追加
└─ リファクタリング時テスト更新
```