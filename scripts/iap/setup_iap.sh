#!/bin/bash
# =============================================================================
# setup_iap.sh — IAP 完全自動セットアップ（エントリーポイント）
# =============================================================================
# 実行内容:
#   1. 前提条件チェック
#   2. setup_asc_iap.sh    — App Store Connect IAP セットアップ
#   3. setup_revenuecat.sh — RevenueCat セットアップ
#   4. 完了サマリー表示
#
# 使い方:
#   bash scripts/iap/setup_iap.sh
#
# 個別実行:
#   bash scripts/iap/setup_asc_iap.sh    # ASC のみ
#   bash scripts/iap/setup_revenuecat.sh # RevenueCat のみ
# =============================================================================

set -e

# ─── カラー定義 ──────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info()    { echo -e "${CYAN}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warn()    { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error()   { echo -e "${RED}❌ $1${NC}"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── バナー ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║    💎 In-App Purchase 完全自動セットアップ          ║${NC}"
echo -e "${BOLD}${BLUE}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}${BLUE}║  Step 1: App Store Connect IAP セットアップ         ║${NC}"
echo -e "${BOLD}${BLUE}║  Step 2: RevenueCat セットアップ                    ║${NC}"
echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ─── 前提条件チェック ─────────────────────────────────────────────────────────
echo -e "${BOLD}🔍 前提条件チェック${NC}"
echo ""

MISSING_TOOLS=()
command -v curl &>/dev/null || MISSING_TOOLS+=("curl")
command -v jq   &>/dev/null || MISSING_TOOLS+=("jq")
command -v ruby &>/dev/null || MISSING_TOOLS+=("ruby")

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
  echo -e "${RED}以下のツールが見つかりません:${NC}"
  for tool in "${MISSING_TOOLS[@]}"; do
    echo -e "  ❌ $tool"
  done
  echo ""
  echo -e "${YELLOW}インストール方法:${NC}"
  echo "  brew install jq curl"
  echo ""
  exit 1
fi

# ruby jwt gem インストール確認
if ! ruby -e "require 'jwt'" 2>/dev/null; then
  echo -e "${YELLOW}⚠️  Ruby jwt gem をインストールします...${NC}"
  gem install jwt --quiet || log_error "jwt gem のインストールに失敗しました"
fi

log_success "curl, jq, ruby, jwt gem — すべて OK"

# ─── 設定ファイル確認 ─────────────────────────────────────────────────────────
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo ""
echo -e "${BOLD}📋 設定ファイル確認${NC}"
echo ""

ERRORS=()
[ -f "$ROOT_DIR/ios/fastlane/.env" ] || ERRORS+=("ios/fastlane/.env が見つかりません")
[ -f "$ROOT_DIR/dart_env/prod.env" ] || ERRORS+=("dart_env/prod.env が見つかりません")

if [ ${#ERRORS[@]} -gt 0 ]; then
  for err in "${ERRORS[@]}"; do
    echo -e "  ${RED}❌ $err${NC}"
  done
  exit 1
fi

# ASC キー確認
ASC_KEY_ID=$(grep '^ASC_KEY_ID=' "$ROOT_DIR/ios/fastlane/.env" | cut -d'"' -f2 | tr -d '"')
[ -n "$ASC_KEY_ID" ] || ERRORS+=("ios/fastlane/.env に ASC_KEY_ID が設定されていません")

ASC_ISSUER_ID=$(grep '^ASC_ISSUER_ID=' "$ROOT_DIR/ios/fastlane/.env" | cut -d'"' -f2 | tr -d '"')
[ -n "$ASC_ISSUER_ID" ] || ERRORS+=("ios/fastlane/.env に ASC_ISSUER_ID が設定されていません")

APP_ID=$(grep '^appId=' "$ROOT_DIR/dart_env/prod.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
[ -n "$APP_ID" ] || ERRORS+=("dart_env/prod.env に appId が設定されていません")

if [ ${#ERRORS[@]} -gt 0 ]; then
  echo -e "${RED}設定に問題があります:${NC}"
  for err in "${ERRORS[@]}"; do
    echo -e "  ❌ $err"
  done
  echo ""
  exit 1
fi

echo -e "  ✅ ios/fastlane/.env — ASC_KEY_ID: $ASC_KEY_ID"
echo -e "  ✅ dart_env/prod.env — appId: $APP_ID"

# ─── 実行モード選択 ───────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}🎛️  実行モード選択${NC}"
echo ""
echo -e "  ${CYAN}1${NC}) 完全実行（App Store Connect + RevenueCat）"
echo -e "  ${CYAN}2${NC}) App Store Connect のみ"
echo -e "  ${CYAN}3${NC}) RevenueCat のみ"
echo ""
read -p "選択してください [1/2/3]: " MODE
MODE="${MODE:-1}"

# ─── 実行 ─────────────────────────────────────────────────────────────────────
echo ""
START_TIME=$(date +%s)

case "$MODE" in
  1)
    echo -e "${BOLD}${BLUE}━━ Step 1/2: App Store Connect ━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/setup_asc_iap.sh"

    echo ""
    echo -e "${BOLD}${BLUE}━━ Step 2/2: RevenueCat ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/setup_revenuecat.sh"
    ;;
  2)
    echo -e "${BOLD}${BLUE}━━ App Store Connect IAP セットアップ ━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/setup_asc_iap.sh"
    ;;
  3)
    echo -e "${BOLD}${BLUE}━━ RevenueCat セットアップ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/setup_revenuecat.sh"
    ;;
  *)
    log_error "無効な選択肢です: $MODE"
    ;;
esac

# ─── 最終サマリー ─────────────────────────────────────────────────────────────
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║    🎉 IAP セットアップ完了                          ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  所要時間: ${ELAPSED}秒"
echo ""
echo -e "${BOLD}次のステップ（手動作業）:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} ${YELLOW}【必須】年額価格を手動設定${NC}"
echo -e "     App Store Connect → 配信 → サブスクリプション → Yearly Premium → サブスクリプション価格"
echo -e "     https://appstoreconnect.apple.com/"
echo ""
echo -e "  ${CYAN}2.${NC} ${YELLOW}【必須】月額・年額の無料トライアルを設定${NC}"
echo -e "     各サブスクリプション → 価格を追加 → キャンペーン価格 → 無料トライアル"
echo -e "     推奨: 月額 7日 / 年額 7日"
echo ""
echo -e "  ${CYAN}3.${NC} ${YELLOW}【必須】買い切り（Non-Consumable）を手動作成${NC}"
echo -e "     App Store Connect → 配信 → App内課金 → + → 非消耗型"
echo -e "     製品ID: \$(grep '^appId=' dart_env/prod.env | cut -d= -f2 | tr . _)_premium_lifetime"
echo ""
echo -e "  ${CYAN}4.${NC} App Store Connect で各商品のスクリーンショット（640x920px）をアップロード・審査登録"
echo ""
echo -e "  ${CYAN}5.${NC} RevenueCat ダッシュボードで Products / Entitlement / Offering を確認"
echo -e "     https://app.revenuecat.com/"
echo ""
echo -e "  ${CYAN}6.${NC} dart_env/prod.env に RevenueCat Public API Key を設定"
echo -e "     ${YELLOW}revenueCatAppleApiKey=appl_XXXXXXXXXXXXXXXXXXXXXXXXX${NC}"
echo ""
echo -e "  ${CYAN}7.${NC} Sandbox テストで Offerings 取得・購入フローを確認"
echo -e "     ${YELLOW}make run-dev${NC}"
echo ""
