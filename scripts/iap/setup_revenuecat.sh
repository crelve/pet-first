#!/bin/bash
# =============================================================================
# setup_revenuecat.sh — RevenueCat Products / Entitlement / Offering 自動セットアップ
# =============================================================================
# 実行内容:
#   1. Products 3件を作成（月額・年額・買い切り）
#   2. Entitlement「premium」を作成、3製品をアタッチ
#   3. Offering「default」を作成
#   4. Packages 3件を追加（$rc_monthly, $rc_annual, $rc_lifetime）
#   5. 各パッケージに製品をアタッチ
#
# 前提:
#   - RevenueCat V2 シークレットキーを手元に用意
#   - RevenueCat プロジェクトを作成済み（Project ID 確認済み）
#   - curl, jq インストール済み
#   - setup_asc_iap.sh 実行後（または Product ID が判明している場合）
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

log_info()    { echo -e "${CYAN}ℹ️  $1${NC}" >&2; }
log_success() { echo -e "${GREEN}✅ $1${NC}" >&2; }
log_warn()    { echo -e "${YELLOW}⚠️  $1${NC}" >&2; }
log_error()   { echo -e "${RED}❌ $1${NC}" >&2; exit 1; }
log_step()    { echo -e "\n${BOLD}${BLUE}▶ $1${NC}" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SHARED_FILE="$SCRIPT_DIR/.iap_product_ids"

echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  💜 RevenueCat IAP 自動セットアップ${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ─── 前提条件チェック ─────────────────────────────────────────────────────────
log_step "前提条件チェック"

command -v curl &>/dev/null || log_error "curl が見つかりません: brew install curl"
command -v jq   &>/dev/null || log_error "jq が見つかりません: brew install jq"
log_success "前提条件 OK"

# ─── Product ID 読み込み ──────────────────────────────────────────────────────
log_step "Product ID 読み込み"

if [ -f "$SHARED_FILE" ]; then
  # shellcheck source=/dev/null
  source "$SHARED_FILE"
  log_success "setup_asc_iap.sh の結果を読み込みました"
  log_info "月額: $MONTHLY_PRODUCT_ID"
  log_info "年額: $YEARLY_PRODUCT_ID"
  log_info "買い切り: $LIFETIME_PRODUCT_ID"
else
  log_warn "setup_asc_iap.sh の共有ファイルが見つかりません"
  log_info "Product ID を手動入力してください"

  # prod.env から appId を自動取得
  PROD_ENV="$ROOT_DIR/dart_env/prod.env"
  if [ -f "$PROD_ENV" ]; then
    APP_ID_DOT=$(grep '^appId=' "$PROD_ENV" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
    APP_ID_UNDER="${APP_ID_DOT//./_}"
    MONTHLY_PRODUCT_ID="${APP_ID_UNDER}_premium_monthly"
    YEARLY_PRODUCT_ID="${APP_ID_UNDER}_premium_yearly"
    LIFETIME_PRODUCT_ID="${APP_ID_UNDER}_premium_lifetime"
    log_info "prod.env から自動生成:"
    log_info "  月額: $MONTHLY_PRODUCT_ID"
    log_info "  年額: $YEARLY_PRODUCT_ID"
    log_info "  買い切り: $LIFETIME_PRODUCT_ID"
    read -p "この Product ID で続けますか？ [Y/n]: " CONFIRM
    [[ "$CONFIRM" =~ ^[Nn]$ ]] && {
      read -p "月額 Product ID: " MONTHLY_PRODUCT_ID
      read -p "年額 Product ID: " YEARLY_PRODUCT_ID
      read -p "買い切り Product ID: " LIFETIME_PRODUCT_ID
    }
  else
    read -p "月額 Product ID: " MONTHLY_PRODUCT_ID
    read -p "年額 Product ID: " YEARLY_PRODUCT_ID
    read -p "買い切り Product ID: " LIFETIME_PRODUCT_ID
  fi
fi

# ─── RevenueCat 認証情報の入力 ────────────────────────────────────────────────
log_step "RevenueCat 認証情報"

echo -e "${YELLOW}RevenueCat ダッシュボード → Project Settings から情報を取得してください${NC}"
echo -e "  URL: https://app.revenuecat.com/"
echo ""

if [ -z "$RC_V2_SECRET_KEY" ]; then
  read -rsp "  RevenueCat V2 Secret Key (sk_...): " RC_V2_SECRET_KEY
  echo ""
fi

if [ -z "$RC_PROJECT_ID" ]; then
  echo -e "  ${CYAN}Project ID の確認場所:${NC}"
  echo -e "    RevenueCat ダッシュボード → 左上のプロジェクト名をクリック → Settings → Project ID"
  read -rp "  RevenueCat Project ID: " RC_PROJECT_ID
fi

[ -n "$RC_V2_SECRET_KEY" ] || log_error "RevenueCat V2 Secret Key が入力されていません"
[ -n "$RC_PROJECT_ID"    ] || log_error "RevenueCat Project ID が入力されていません"

RC_BASE="https://api.revenuecat.com/v2"
RC_AUTH="Authorization: Bearer $RC_V2_SECRET_KEY"

# ─── ヘルパー関数 ─────────────────────────────────────────────────────────────
rc_get() {
  local url="$1"
  curl -s -g -H "$RC_AUTH" -H "Content-Type: application/json" "$url"
}

rc_post() {
  local url="$1"
  local body="$2"
  curl -s -g -X POST -H "$RC_AUTH" -H "Content-Type: application/json" -d "$body" "$url"
}

rc_delete() {
  local url="$1"
  curl -s -g -X DELETE -H "$RC_AUTH" "$url"
}

check_rc_errors() {
  local response="$1"
  local context="$2"
  # RevenueCat V2 エラーは {"object": "error", "type": "...", "message": "..."} 形式
  local obj
  obj=$(echo "$response" | jq -r '.object // ""' 2>/dev/null)
  if [ "$obj" = "error" ]; then
    local err_type msg
    err_type=$(echo "$response" | jq -r '.type // .code // "error"')
    msg=$(echo "$response" | jq -r '.message // "不明なエラー"')
    log_error "$context: [$err_type] $msg"
  fi
}

get_existing_product_id() {
  local identifier="$1"
  local resp
  # 全件取得してjqでstore_identifierを絞り込む
  resp=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/products?limit=100")
  echo "$resp" | jq -r --arg id "$identifier" \
    '.items[] | select(.store_identifier == $id) | .id' | head -1
}

get_existing_product_app_id() {
  local identifier="$1"
  local resp
  resp=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/products?limit=100")
  # RevenueCat V2 APIはapp_idをトップレベルフィールドとして返す
  echo "$resp" | jq -r --arg id "$identifier" \
    '.items[] | select(.store_identifier == $id) | .app_id // ""' | head -1
}

# ─── iOS App ID 取得 ──────────────────────────────────────────────────────────
log_step "Step 0: iOS App ID 取得"

APPS_RESP=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/apps")
RC_IOS_APP_ID=$(echo "$APPS_RESP" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for app in data.get('items', []):
    if app.get('type') == 'app_store':
        print(app['id'])
        break
" 2>/dev/null)

if [ -z "$RC_IOS_APP_ID" ]; then
  log_error "iOS App Store アプリが RevenueCat プロジェクトに見つかりません。先に Apps & providers で iOS アプリを追加してください。"
fi
log_success "iOS App ID: $RC_IOS_APP_ID"

# ─── Step 1: Products 作成 ────────────────────────────────────────────────────
log_step "Step 1: RevenueCat Products 作成"

# 月額は subscription、年額も subscription、買い切りは one_time
create_rc_product_typed() {
  local store_identifier="$1"
  local display_name="$2"
  local product_type="$3"  # subscription / one_time

  local existing_id existing_app_id
  existing_id=$(get_existing_product_id "$store_identifier")

  if [ -n "$existing_id" ]; then
    existing_app_id=$(get_existing_product_app_id "$store_identifier")
    if [ -n "$existing_app_id" ] && [ "$existing_app_id" != "null" ]; then
      log_warn "Product '$store_identifier' は既に存在します (ID: $existing_id)"
      echo "$existing_id"
      return
    fi
    # app_id なしで作成されたProduct → 削除して再作成
    log_warn "Product '$store_identifier' (ID: $existing_id) は app 未紐付け → 削除して再作成します"
    rc_delete "$RC_BASE/projects/$RC_PROJECT_ID/products/$existing_id" > /dev/null 2>&1
    sleep 1
  fi

  local body
  body=$(cat <<JSON
{
  "store_identifier": "$store_identifier",
  "type": "$product_type",
  "display_name": "$display_name",
  "app_id": "$RC_IOS_APP_ID"
}
JSON
)
  local resp
  resp=$(rc_post "$RC_BASE/projects/$RC_PROJECT_ID/products" "$body")
  check_rc_errors "$resp" "Product '$store_identifier' 作成"
  local prod_id
  prod_id=$(echo "$resp" | jq -r '.id // empty')
  if [ -z "$prod_id" ]; then
    log_warn "Product '$store_identifier': ID 取得失敗"
    echo ""
    return
  fi
  log_success "Product '$store_identifier' 作成完了 (ID: $prod_id)"
  echo "$prod_id"
}

RC_MONTHLY_PRODUCT_ID=$(create_rc_product_typed "$MONTHLY_PRODUCT_ID"  "Monthly Premium"  "subscription")
RC_YEARLY_PRODUCT_ID=$(create_rc_product_typed  "$YEARLY_PRODUCT_ID"   "Yearly Premium"   "subscription")
RC_LIFETIME_PRODUCT_ID=$(create_rc_product_typed "$LIFETIME_PRODUCT_ID" "Lifetime Premium" "one_time")

# ─── Step 2: Entitlement 作成 ─────────────────────────────────────────────────
log_step "Step 2: Entitlement「premium」作成"

EXISTING_ENT=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/entitlements?limit=100")
RC_ENTITLEMENT_ID=$(echo "$EXISTING_ENT" | jq -r \
  '.items[] | select(.lookup_key == "premium") | .id' | head -1)
# フォールバック: 既存entitlementが1つだけあればそれを使用
if [ -z "$RC_ENTITLEMENT_ID" ]; then
  RC_ENTITLEMENT_ID=$(echo "$EXISTING_ENT" | jq -r '.items[0].id // empty')
fi

if [ -n "$RC_ENTITLEMENT_ID" ]; then
  log_warn "Entitlement 'premium' は既に存在します (ID: $RC_ENTITLEMENT_ID)"
else
  ENT_BODY=$(cat <<JSON
{
  "lookup_key": "premium",
  "display_name": "Premium"
}
JSON
)
  ENT_RESP=$(rc_post "$RC_BASE/projects/$RC_PROJECT_ID/entitlements" "$ENT_BODY")
  check_rc_errors "$ENT_RESP" "Entitlement 作成"
  RC_ENTITLEMENT_ID=$(echo "$ENT_RESP" | jq -r '.id // empty')
  [ -n "$RC_ENTITLEMENT_ID" ] || log_error "Entitlement ID の取得に失敗しました"
  log_success "Entitlement 'premium' 作成完了 (ID: $RC_ENTITLEMENT_ID)"
fi

# ─── Step 3: Entitlement に Products をアタッチ（手動必須）───────────────────
log_step "Step 3: Entitlement に Products をアタッチ（手動必須）"
# RevenueCat V2 REST API はこの操作に非対応（ダッシュボードのみ）
log_warn "RevenueCat V2 API は Product→Entitlement の Attach に非対応のため手動で設定してください"
log_warn "  ダッシュボード: https://app.revenuecat.com/ → Product catalog → Products"
log_warn "  月額    (${RC_MONTHLY_PRODUCT_ID:-未作成})  → Attach → Entitlement"
log_warn "  年額    (${RC_YEARLY_PRODUCT_ID:-未作成})   → Attach → Entitlement"
log_warn "  買い切り(${RC_LIFETIME_PRODUCT_ID:-未作成}) → Attach → Entitlement"

# ─── Step 4: Offering 作成 ────────────────────────────────────────────────────
log_step "Step 4: Offering「default」作成"

EXISTING_OFF=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/offerings?identifier=default")
RC_OFFERING_ID=$(echo "$EXISTING_OFF" | jq -r '.items[0].id // empty')

if [ -n "$RC_OFFERING_ID" ]; then
  log_warn "Offering 'default' は既に存在します (ID: $RC_OFFERING_ID)"
else
  OFF_BODY=$(cat <<JSON
{
  "lookup_key": "default",
  "display_name": "Default Offering",
  "is_current": true
}
JSON
)
  OFF_RESP=$(rc_post "$RC_BASE/projects/$RC_PROJECT_ID/offerings" "$OFF_BODY")
  check_rc_errors "$OFF_RESP" "Offering 作成"
  RC_OFFERING_ID=$(echo "$OFF_RESP" | jq -r '.id // empty')
  [ -n "$RC_OFFERING_ID" ] || log_error "Offering ID の取得に失敗しました"
  log_success "Offering 'default' 作成完了 (ID: $RC_OFFERING_ID)"
fi

# ─── Step 5: Packages 作成 ────────────────────────────────────────────────────
log_step "Step 5: Packages 作成"

create_package() {
  local lookup_key="$1"  # $rc_monthly / $rc_annual / $rc_lifetime
  local display_name="$2"

  # 既存確認: 全件取得してjqで絞り込む
  local existing_resp
  existing_resp=$(rc_get "$RC_BASE/projects/$RC_PROJECT_ID/offerings/$RC_OFFERING_ID/packages?limit=100")
  local existing_pkg_id
  existing_pkg_id=$(echo "$existing_resp" | jq -r --arg key "$lookup_key" \
    '.items[] | select(.lookup_key == $key) | .id' | head -1)

  if [ -n "$existing_pkg_id" ]; then
    log_warn "Package '$lookup_key' は既に存在します (ID: $existing_pkg_id)"
    echo "$existing_pkg_id"
    return
  fi

  local body
  body=$(cat <<JSON
{
  "lookup_key": "$lookup_key",
  "display_name": "$display_name",
  "position": null
}
JSON
)
  local resp
  resp=$(rc_post "$RC_BASE/projects/$RC_PROJECT_ID/offerings/$RC_OFFERING_ID/packages" "$body")
  check_rc_errors "$resp" "Package '$lookup_key' 作成"
  local pkg_id
  pkg_id=$(echo "$resp" | jq -r '.id // empty')
  if [ -z "$pkg_id" ]; then
    log_warn "Package '$lookup_key': ID 取得失敗"
    echo ""
    return
  fi
  log_success "Package '$lookup_key' 作成完了 (ID: $pkg_id)"
  echo "$pkg_id"
}

RC_MONTHLY_PKG_ID=$(create_package  "\$rc_monthly"  "Monthly")
RC_YEARLY_PKG_ID=$(create_package   "\$rc_annual"   "Annual")
RC_LIFETIME_PKG_ID=$(create_package "\$rc_lifetime" "Lifetime")

# ─── Step 6: Package に Product をアタッチ（手動必須）───────────────────────
log_step "Step 6: Package に Product をアタッチ（手動必須）"
# RevenueCat V2 REST API はこの操作に非対応（405 Method Not Allowed）
log_warn "RevenueCat V2 API は Package→Product の Attach に非対応のため手動で設定してください"
log_warn "  ダッシュボード: https://app.revenuecat.com/ → Product catalog → Offerings → default"
log_warn "  \$rc_monthly  (${RC_MONTHLY_PKG_ID:-未作成})  → 月額    product を選択"
log_warn "  \$rc_annual   (${RC_YEARLY_PKG_ID:-未作成})   → 年額    product を選択"
log_warn "  \$rc_lifetime (${RC_LIFETIME_PKG_ID:-未作成}) → 買い切り product を選択"

# ─── 環境変数ファイルのヒント ─────────────────────────────────────────────────
log_step "次のステップ: 環境変数設定"

# RevenueCat iOS App の Public API Key 案内
echo -e "${YELLOW}dart_env/prod.env に以下を追加してください:${NC}"
echo ""
echo -e "  ${CYAN}revenueCatAppleApiKey=<RevenueCatダッシュボード → Apps → API Keys から取得>${NC}"
echo ""
echo -e "  確認場所:"
echo -e "    https://app.revenuecat.com/ → [プロジェクト] → Apps & providers → [iOSアプリ] → API Keys"
echo ""

# ─── 完了サマリー ─────────────────────────────────────────────────────────────
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  🎉 RevenueCat セットアップ完了${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Project ID:${NC}      $RC_PROJECT_ID"
echo -e "  ${BOLD}Entitlement ID:${NC}  $RC_ENTITLEMENT_ID"
echo -e "  ${BOLD}Offering ID:${NC}     $RC_OFFERING_ID"
echo ""
echo -e "  ${BOLD}Products:${NC}"
echo -e "    月額:     ${CYAN}$RC_MONTHLY_PRODUCT_ID${NC}"
echo -e "    年額:     ${CYAN}$RC_YEARLY_PRODUCT_ID${NC}"
echo -e "    買い切り: ${CYAN}$RC_LIFETIME_PRODUCT_ID${NC}"
echo ""
echo -e "  ${BOLD}Packages:${NC}"
echo -e "    \$rc_monthly:  ${CYAN}$RC_MONTHLY_PKG_ID${NC}"
echo -e "    \$rc_annual:   ${CYAN}$RC_YEARLY_PKG_ID${NC}"
echo -e "    \$rc_lifetime: ${CYAN}$RC_LIFETIME_PKG_ID${NC}"
echo ""
echo -e "${YELLOW}⚠️  ダッシュボードで手動作業が必要です:${NC}"
echo -e "   https://app.revenuecat.com/"
echo ""
echo -e "  ${BOLD}【手動 Step A】Product → Entitlement Attach${NC}"
echo -e "    Product catalog → Products → 各商品 → 「Attach」→ Entitlement を選択"
echo -e "    月額:     ${CYAN}$RC_MONTHLY_PRODUCT_ID${NC}"
echo -e "    年額:     ${CYAN}$RC_YEARLY_PRODUCT_ID${NC}"
echo -e "    買い切り: ${CYAN}$RC_LIFETIME_PRODUCT_ID${NC}"
echo ""
echo -e "  ${BOLD}【手動 Step B】Package → Product Attach${NC}"
echo -e "    Product catalog → Offerings → default → 各Package → Product を選択"
echo -e "    \$rc_monthly  → 月額    product"
echo -e "    \$rc_annual   → 年額    product"
echo -e "    \$rc_lifetime → 買い切り product"
echo ""
