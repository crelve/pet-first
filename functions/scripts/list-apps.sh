#!/bin/bash
# 登録済みアプリ一覧を表示するスクリプト

echo "登録済みアプリ一覧を取得中..."
echo ""

curl -s "https://us-central1-kikiki-flutter-template-prod.cloudfunctions.net/listApps" | python3 -m json.tool
