#!/bin/bash
set -e

# スクリーンショットディレクトリの言語コードをARB形式からApp Store Connect形式に変換
# Python script wrapper for compatibility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCREENSHOTS_DIR="$REPO_ROOT/screenshots"

python3 "$SCRIPT_DIR/locale_mapping.py" --convert-dirs "$SCREENSHOTS_DIR"
