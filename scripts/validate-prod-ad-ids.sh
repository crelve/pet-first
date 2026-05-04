#!/usr/bin/env bash
# Fail if dart_env/prod.env has placeholder/test AdMob IDs or empty slots.
# Prevents test IDs from shipping to production and catches skipped Step 11.
set -euo pipefail

ENV_FILE="${1:-dart_env/prod.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ $ENV_FILE が見つかりません"
  exit 1
fi

FIELDS=(iOSBannerAdUnitId iOSInterstitialAdUnitId iOSRewardedAdUnitId iOSAppOpenAdUnitId iOSNativeAdUnitId)
FAIL=0

for key in "${FIELDS[@]}"; do
  line=$(grep -E "^${key}=" "$ENV_FILE" || true)
  if [ -z "$line" ]; then
    echo "❌ $ENV_FILE に $key がありません"
    FAIL=1
    continue
  fi
  value="${line#*=}"
  if [ -z "$value" ]; then
    echo "❌ $key が空です → Step 11 (release-ios-admob) を実行して実ユニットIDを反映してください"
    FAIL=1
  elif [[ "$value" == *"3940256099942544"* ]]; then
    echo "❌ $key に Google テスト広告ID (3940256099942544) が残っています → Step 11 を実行して実ユニットIDを反映してください"
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "🚫 本番 AdMob ユニットID 検証に失敗しました。"
  echo "   → flutter-template/dart_env/prod.env を Step 11 で生成された実IDに置換してください。"
  exit 1
fi

echo "✅ prod.env の AdMob ユニットID は本番値です"

# Info.plist の GADApplicationIdentifier を検証（孤児テンプレapp ~1338814004 残留検出）
INFO_PLIST="${INFO_PLIST:-ios/Runner/Info.plist}"
if [ -f "$INFO_PLIST" ]; then
  GAD_ID=$(/usr/libexec/PlistBuddy -c "Print :GADApplicationIdentifier" "$INFO_PLIST" 2>/dev/null || echo "")
  if [ -z "$GAD_ID" ]; then
    echo "❌ $INFO_PLIST に GADApplicationIdentifier がありません"
    exit 1
  elif [[ "$GAD_ID" == *"~1338814004"* ]]; then
    echo "❌ $INFO_PLIST に孤児テンプレ AdMob app ID ~1338814004 が残存しています"
    echo "   → このアプリ専用の AdMob app を作成し、update-admob-app-id.py で Info.plist を更新してください"
    echo "   例: python3 ~/kikiki/released/company/engineering/scripts/update-admob-app-id.py \$(basename \$(pwd)) ca-app-pub-2443502666087876~XXXXXXXXXX"
    exit 1
  fi
  echo "✅ $INFO_PLIST の GADApplicationIdentifier は本番値です: $GAD_ID"
fi
