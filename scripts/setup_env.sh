#!/bin/bash
# CocoaPods環境設定スクリプト
# UTF-8エンコーディングを設定してCocoaPodsの文字化けエラーを防止

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "✓ Environment variables set:"
echo "  LANG=$LANG"
echo "  LC_ALL=$LC_ALL"
echo ""
echo "Running: $@"
exec "$@"
