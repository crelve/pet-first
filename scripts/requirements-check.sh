#!/bin/bash

# 要件定義適合性チェックスクリプト
# 実装内容が要件定義書の受け入れ基準を満たしているかチェック

set -e

# 設定
REQUIREMENTS_FILE="docs/project/requirements.md"
TEST_RESULTS_FILE="test_results.json"
COVERAGE_FILE="coverage/lcov.info"

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <要件ID> [テストオプション]"
    echo "例: $0 F001"
    echo "例: $0 F001 --with-performance"
    exit 1
fi

REQUIREMENT_ID=$1
WITH_PERFORMANCE=${2:-""}

echo "🔍 要件定義適合性チェック開始"
echo "要件ID: $REQUIREMENT_ID"
echo "要件定義ファイル: $REQUIREMENTS_FILE"

# 要件定義書の存在確認
if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "❌ 要件定義書が見つかりません: $REQUIREMENTS_FILE"
    exit 1
fi

# 要件IDの存在確認
if ! grep -q "**要件ID**: $REQUIREMENT_ID" "$REQUIREMENTS_FILE"; then
    echo "❌ 要件ID '$REQUIREMENT_ID' が要件定義書に見つかりません"
    exit 1
fi

echo "✅ 要件ID '$REQUIREMENT_ID' を確認"

# 要件詳細の抽出
REQUIREMENT_SECTION=$(awk "/\*\*要件ID\*\*: $REQUIREMENT_ID/,/\*\*要件ID\*\*: [^$REQUIREMENT_ID]/" "$REQUIREMENTS_FILE" | head -n -1)

echo "📋 要件詳細:"
echo "$REQUIREMENT_SECTION" | grep "**説明**:" | sed 's/\*\*説明\*\*: //'

# 受け入れ基準の抽出
echo ""
echo "✅ 受け入れ基準チェック:"
ACCEPTANCE_CRITERIA=$(echo "$REQUIREMENT_SECTION" | sed -n '/\*\*受け入れ基準\*\*:/,/^$/p' | grep '- \[ \]')

if [ -z "$ACCEPTANCE_CRITERIA" ]; then
    echo "⚠️  受け入れ基準が見つかりません"
else
    echo "$ACCEPTANCE_CRITERIA"
fi

# テストの実行
echo ""
echo "🧪 関連テスト実行:"

# ユニットテスト
echo "- Unit テスト実行中..."
if fvm flutter test --coverage > /dev/null 2>&1; then
    echo "  ✅ Unit テスト: 合格"
else
    echo "  ❌ Unit テスト: 失敗"
    exit 1
fi

# Widget テスト (該当する場合)
WIDGET_TESTS=$(find test -name "*_test.dart" -exec grep -l "testWidgets\|WidgetTester" {} \;)
if [ -n "$WIDGET_TESTS" ]; then
    echo "- Widget テスト実行中..."
    if fvm flutter test $WIDGET_TESTS > /dev/null 2>&1; then
        echo "  ✅ Widget テスト: 合格"
    else
        echo "  ❌ Widget テスト: 失敗"
        exit 1
    fi
fi

# コードカバレッジチェック
if [ -f "$COVERAGE_FILE" ]; then
    COVERAGE_PERCENT=$(lcov --summary "$COVERAGE_FILE" 2>/dev/null | grep "lines" | awk '{print $2}' | sed 's/%//')
    if [ -n "$COVERAGE_PERCENT" ]; then
        if (( $(echo "$COVERAGE_PERCENT >= 80" | bc -l) )); then
            echo "  ✅ コードカバレッジ: ${COVERAGE_PERCENT}% (目標: 80%以上)"
        else
            echo "  ⚠️  コードカバレッジ: ${COVERAGE_PERCENT}% (目標: 80%以上)"
        fi
    fi
fi

# コード品質チェック
echo "- コード品質チェック中..."
if fvm flutter analyze > /dev/null 2>&1; then
    echo "  ✅ Flutter Analyze: 問題なし"
else
    echo "  ❌ Flutter Analyze: 問題あり"
    echo "  詳細: fvm flutter analyze"
    exit 1
fi

# 要件固有のチェック
echo ""
echo "🎯 要件固有チェック:"

case $REQUIREMENT_ID in
    "F001")
        echo "- F001: 天気情報表示機能チェック"
        
        # API統合チェック
        if grep -r "OpenWeatherMap\|weather.*api" lib/ > /dev/null 2>&1; then
            echo "  ✅ 天気API統合確認"
        else
            echo "  ❌ 天気API統合が見つかりません"
        fi
        
        # 位置情報チェック
        if grep -r "geolocator\|location" lib/ > /dev/null 2>&1; then
            echo "  ✅ 位置情報機能確認"
        else
            echo "  ❌ 位置情報機能が見つかりません"
        fi
        
        # キャッシュ機構チェック
        if grep -r "cache\|shared_preferences\|hive" lib/ > /dev/null 2>&1; then
            echo "  ✅ キャッシュ機構確認"
        else
            echo "  ⚠️  キャッシュ機構が見つかりません"
        fi
        ;;
        
    "F002")
        echo "- F002: 服装提案機能チェック"
        
        # 服装提案アルゴリズムチェック
        if grep -r "outfit.*algorithm\|clothing.*suggestion" lib/ > /dev/null 2>&1; then
            echo "  ✅ 服装提案アルゴリズム確認"
        else
            echo "  ❌ 服装提案アルゴリズムが見つかりません"
        fi
        ;;
        
    "F003")
        echo "- F003: 通知機能チェック"
        
        # FCM統合チェック
        if grep -r "firebase_messaging\|notification" lib/ > /dev/null 2>&1; then
            echo "  ✅ 通知機能確認"
        else
            echo "  ❌ 通知機能が見つかりません"
        fi
        ;;
        
    "F004")
        echo "- F004: ユーザー設定機能チェック"
        
        # 設定画面チェック
        if find lib/screen -name "*setting*" > /dev/null 2>&1; then
            echo "  ✅ 設定画面確認"
        else
            echo "  ❌ 設定画面が見つかりません"
        fi
        ;;
esac

# パフォーマンステスト (オプション)
if [ "$WITH_PERFORMANCE" = "--with-performance" ]; then
    echo ""
    echo "⚡ パフォーマンステスト:"
    
    case $REQUIREMENT_ID in
        "F001")
            echo "- 天気データ取得速度チェック (目標: 3秒以内)"
            echo "  📝 手動確認が必要です"
            ;;
        "F002")
            echo "- 服装提案生成速度チェック (目標: 1秒以内)"
            echo "  📝 手動確認が必要です"
            ;;
    esac
fi

# 依存関係チェック
echo ""
echo "🔗 依存関係チェック:"

# pubspec.yamlの必要パッケージ確認
case $REQUIREMENT_ID in
    "F001")
        REQUIRED_PACKAGES=("http" "geolocator" "shared_preferences")
        ;;
    "F002")
        REQUIRED_PACKAGES=("freezed" "json_annotation")
        ;;
    "F003")
        REQUIRED_PACKAGES=("firebase_messaging" "flutter_local_notifications")
        ;;
    "F004")
        REQUIRED_PACKAGES=("shared_preferences")
        ;;
    *)
        REQUIRED_PACKAGES=()
        ;;
esac

for package in "${REQUIRED_PACKAGES[@]}"; do
    if grep -q "$package:" pubspec.yaml; then
        echo "  ✅ $package: インストール済み"
    else
        echo "  ❌ $package: 未インストール"
    fi
done

# ファイル存在チェック
echo ""
echo "📁 必要ファイル存在チェック:"

case $REQUIREMENT_ID in
    "F001")
        REQUIRED_FILES=(
            "lib/model/weather_model.dart"
            "lib/provider/weather_provider.dart"
            "lib/utility/weather_api_client.dart"
        )
        ;;
    "F002")
        REQUIRED_FILES=(
            "lib/model/outfit_model.dart"
            "lib/provider/outfit_provider.dart"
            "lib/utility/outfit_algorithm.dart"
        )
        ;;
    "F003")
        REQUIRED_FILES=(
            "lib/utility/notification_service.dart"
            "lib/provider/notification_provider.dart"
        )
        ;;
    "F004")
        REQUIRED_FILES=(
            "lib/model/user_profile_model.dart"
            "lib/provider/user_profile_provider.dart"
            "lib/screen/setting/profile_setting_screen.dart"
        )
        ;;
    *)
        REQUIRED_FILES=()
        ;;
esac

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file: 存在"
    else
        echo "  ❌ $file: 未作成"
    fi
done

# 結果サマリー
echo ""
echo "📊 チェック結果サマリー:"
echo "要件ID: $REQUIREMENT_ID"
echo "実行日時: $(date)"
echo ""

# 全体的な判定
echo "🎯 要件定義適合性: 手動で受け入れ基準をご確認ください"
echo ""
echo "📝 次のアクション:"
echo "1. 上記チェック結果を確認"
echo "2. 不合格項目の修正"
echo "3. 手動テストの実施"
echo "4. 受け入れ基準の最終確認"

echo ""
echo "✅ 要件定義適合性チェック完了"