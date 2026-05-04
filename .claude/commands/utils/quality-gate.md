# 品質ゲートコマンド

## 概要
コード品質・テスト・要件適合性を総合的にチェックし、リリース可能かを判定します。

## 実行内容
1. コード品質チェック（Flutter Analyze）
2. テスト実行・カバレッジ確認
3. 要件定義適合性チェック
4. パフォーマンス要件確認
5. セキュリティチェック
6. リリース判定

## 使用方法
```bash
/quality-gate [対象] [オプション]
```

### 対象
- `all`: 全機能をチェック（デフォルト）
- `core`: Core機能のみ（F001-F004）
- `premium`: Premium機能のみ（F101-F103）
- `[要件ID]`: 特定要件のみ

### オプション
- `--strict`: 厳格モード（すべての品質基準を満たす必要）
- `--fix`: 自動修正可能な問題を修正
- `--report`: 詳細レポート生成
- `--ci`: CI/CD環境用（非対話モード）

### 例
```bash
/quality-gate
/quality-gate core --strict
/quality-gate F001 --fix --report
/quality-gate all --ci
```

## チェック項目

### 1. コード品質 (Weight: 25%)
```bash
# 静的解析
fvm flutter analyze

# コードスタイル
dart format --dry-run lib/ test/

# 複雑度チェック
dart analyze --fatal-warnings
```

**合格基準:**
- ✅ Flutter Analyze エラー: 0件
- ✅ Warning: 5件以下
- ✅ コードフォーマット準拠: 100%

### 2. テスト品質 (Weight: 30%)
```bash
# Unit テスト
flutter test

# Widget テスト
flutter test --tags widget

# Integration テスト
flutter test integration_test/

# カバレッジ
flutter test --coverage
```

**合格基準:**
- ✅ Unit テスト成功率: 100%
- ✅ Widget テスト成功率: 100%
- ✅ コードカバレッジ: 80%以上
- ✅ 重要機能カバレッジ: 95%以上

### 3. 要件適合性 (Weight: 25%)
```bash
# 各要件の受け入れ基準チェック
./scripts/requirements-check.sh F001
./scripts/requirements-check.sh F002
./scripts/requirements-check.sh F003
./scripts/requirements-check.sh F004
```

**合格基準:**
- ✅ Core機能受け入れ基準: 100%達成
- ✅ 必須ファイル存在: 100%
- ✅ 依存関係解決: 100%

### 4. パフォーマンス (Weight: 15%)
```bash
# アプリ起動時間
flutter drive --target=test_driver/startup_test.dart

# メモリ使用量
flutter drive --target=test_driver/memory_test.dart

# ビルドサイズ
flutter build apk --analyze-size
```

**合格基準:**
- ✅ 起動時間: 3秒以内
- ✅ メモリ使用量: 100MB以下
- ✅ APKサイズ: 50MB以下
- ✅ API応答時間: 3秒以内

### 5. セキュリティ (Weight: 5%)
```bash
# APIキー・シークレット漏洩チェック
grep -r "sk_\|pk_\|api_key" --exclude-dir=.git .

# 権限チェック
grep -A 5 -B 5 "uses-permission" ios/Runner/Info.plist

# Firebase Security Rules
firebase rules:get
```

**合格基準:**
- ✅ シークレット漏洩: 0件
- ✅ 不要権限: 0件
- ✅ Firebase Rules設定: 適切

## 品質スコア算出

### 総合スコア計算
```
総合スコア = (コード品質 × 0.25) + (テスト品質 × 0.30) + 
           (要件適合性 × 0.25) + (パフォーマンス × 0.15) + 
           (セキュリティ × 0.05)
```

### 判定基準
- 🟢 **PASS** (90-100点): リリース可能
- 🟡 **WARN** (70-89点): 修正推奨
- 🔴 **FAIL** (0-69点): リリース不可

## 出力例

### 概要表示
```
🔍 WeatherWear 品質ゲート実行

📊 チェック結果:
✅ コード品質: 95点 (エラー: 0件, Warning: 2件)
✅ テスト品質: 88点 (カバレッジ: 85%)
✅ 要件適合性: 100点 (F001-F004: すべて適合)
✅ パフォーマンス: 92点 (起動: 2.1秒, メモリ: 87MB)
✅ セキュリティ: 100点 (問題なし)

🎯 総合スコア: 94点
🟢 判定: PASS - リリース可能

📝 改善提案:
- Warning 2件の解決 (+2点)
- テストカバレッジ90%達成 (+4点)
```

### 詳細レポート (--report)
```markdown
# WeatherWear 品質ゲートレポート

**実行日時**: 2024-01-10 14:30:00
**対象**: 全機能
**総合スコア**: 94点 (PASS)

## 詳細結果

### コード品質 (95点)
- ✅ Flutter Analyze: 0エラー
- ⚠️ Warning: 2件
  - lib/utility/cache_service.dart:45: Unused import
  - lib/provider/weather_provider.dart:123: Prefer const constructors

### テスト品質 (88点)
- ✅ Unit テスト: 45/45 成功
- ✅ Widget テスト: 12/12 成功
- ✅ Integration テスト: 8/8 成功
- ⚠️ カバレッジ: 85% (目標: 90%)

### 要件適合性 (100点)
- ✅ F001: 天気情報表示 - 適合
- ✅ F002: 服装提案機能 - 適合
- ✅ F003: 通知機能 - 適合
- ✅ F004: ユーザー設定 - 適合

### パフォーマンス (92点)
- ✅ アプリ起動時間: 2.1秒
- ✅ メモリ使用量: 87MB
- ✅ APKサイズ: 48MB
- ✅ API応答時間: 2.3秒

### セキュリティ (100点)
- ✅ シークレット漏洩: なし
- ✅ 権限設定: 適切
- ✅ Firebase Rules: 適切

## 改善提案
1. Warning 2件の解決
2. テストカバレッジ90%達成
3. パフォーマンステストの自動化

## リリース判定
🟢 **PASS**: リリース可能
```

## 自動修正機能 (--fix)

### 自動修正可能な項目
```bash
# コードフォーマット
dart format lib/ test/

# 未使用import削除
dart fix --apply

# Lintルール適用
dart analyze --fatal-warnings
```

### 半自動修正項目
- 複雑度の高いメソッドのリファクタリング提案
- テストカバレッジ向上のための不足テスト特定
- パフォーマンス改善提案

## CI/CD統合

### GitHub Actions連携
```yaml
# .github/workflows/quality-gate.yml
- name: Quality Gate
  run: /quality-gate all --ci --strict
  
- name: Quality Report
  if: failure()
  run: /quality-gate all --report --ci
```

### 合格時アクション
- リリースブランチへの自動マージ
- デプロイパイプライン起動
- Slack通知送信

### 不合格時アクション
- PR をブロック
- 詳細レポート生成
- 開発者への通知

## 設定カスタマイズ

### 品質基準調整
```json
// .claude/quality-standards.json
{
  "code_quality": {
    "max_warnings": 5,
    "max_errors": 0,
    "complexity_threshold": 10
  },
  "test_quality": {
    "min_coverage": 80,
    "critical_coverage": 95
  },
  "performance": {
    "max_startup_time": 3000,
    "max_memory_usage": 100,
    "max_apk_size": 50
  }
}
```