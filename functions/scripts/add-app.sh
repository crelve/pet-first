#!/bin/bash
# 日次メトリクスレポートにアプリを追加するスクリプト
#
# 使い方:
#   ./add-app.sh "アプリ名" "App Store ID" "Analytics Property ID"
#
# 例:
#   ./add-app.sh "My App" "1234567890" "123456789"
#
# 注意: 追加後、Google Analytics にサービスアカウントを追加してください
#   513162290068-compute@developer.gserviceaccount.com

if [ $# -ne 3 ]; then
    echo "使い方: $0 \"アプリ名\" \"App Store ID\" \"Analytics Property ID\""
    echo ""
    echo "例: $0 \"My App\" \"1234567890\" \"123456789\""
    exit 1
fi

APP_NAME="$1"
APP_STORE_ID="$2"
ANALYTICS_ID="$3"

# アプリIDを生成（アプリ名から英数字のみ抽出してケバブケースに）
APP_ID=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

echo "アプリを登録中..."
echo "  アプリ名: $APP_NAME"
echo "  App Store ID: $APP_STORE_ID"
echo "  Analytics ID: $ANALYTICS_ID"
echo "  生成されたID: $APP_ID"
echo ""

RESPONSE=$(curl -s -X POST "https://us-central1-kikiki-flutter-template-prod.cloudfunctions.net/addApp" \
  -H "Content-Type: application/json" \
  -d "{
    \"appId\": \"$APP_ID\",
    \"appName\": \"$APP_NAME\",
    \"appStoreAppId\": \"$APP_STORE_ID\",
    \"analyticsPropertyId\": \"$ANALYTICS_ID\"
  }")

echo "結果: $RESPONSE"
echo ""
echo "=========================================="
echo "重要: Google Analytics にサービスアカウントを追加してください"
echo "  メール: 513162290068-compute@developer.gserviceaccount.com"
echo "  役割: 閲覧者"
echo "=========================================="
