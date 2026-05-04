#!/bin/bash
# =============================================================================
# setup_asc_iap.sh — App Store Connect IAP 自動セットアップ
# =============================================================================
# 実行内容:
#   1. サブスクリプショングループ「Premium」を作成
#   2. 月額・年額サブスクリプションを作成（無料トライアル付き）
#   3. 買い切り（Non-Consumable）を作成
#   4. 各商品に英語ローカライズを設定
#
# 前提:
#   - ios/fastlane/.env に ASC_KEY_ID / ASC_ISSUER_ID / ASC_KEY_CONTENT 設定済み
#   - dart_env/prod.env に appId 設定済み
#   - curl, jq インストール済み
#   - ruby (jwt gem) 利用可能
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

# ─── ログ関数 ─────────────────────────────────────────────────────────────────
log_info()    { echo -e "${CYAN}ℹ️  $1${NC}" >&2; }
log_success() { echo -e "${GREEN}✅ $1${NC}" >&2; }
log_warn()    { echo -e "${YELLOW}⚠️  $1${NC}" >&2; }
log_error()   { echo -e "${RED}❌ $1${NC}" >&2; exit 1; }
log_step()    { echo -e "\n${BOLD}${BLUE}▶ $1${NC}" >&2; }

# ─── ルートディレクトリ検出 ──────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  🍎 App Store Connect IAP 自動セットアップ${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ─── 前提条件チェック ─────────────────────────────────────────────────────────
log_step "前提条件チェック"

command -v curl &>/dev/null || log_error "curl が見つかりません: brew install curl"
command -v jq   &>/dev/null || log_error "jq が見つかりません: brew install jq"
command -v ruby &>/dev/null || log_error "ruby が見つかりません"

ruby -e "require 'jwt'" 2>/dev/null || {
  log_warn "Ruby jwt gem が見つかりません。インストールします..."
  gem install jwt --quiet || log_error "jwt gem のインストールに失敗しました"
}
log_success "前提条件 OK"

# ─── 設定ファイル読み込み ─────────────────────────────────────────────────────
log_step "設定ファイル読み込み"

FASTLANE_ENV="$ROOT_DIR/ios/fastlane/.env"
PROD_ENV="$ROOT_DIR/dart_env/prod.env"

[ -f "$FASTLANE_ENV" ] || log_error "ios/fastlane/.env が見つかりません"
[ -f "$PROD_ENV"     ] || log_error "dart_env/prod.env が見つかりません"

# fastlane .env を読み込む（複数行のASC_KEY_CONTENTに対応）
ASC_KEY_ID=$(grep    '^ASC_KEY_ID='     "$FASTLANE_ENV" | cut -d'"' -f2 | tr -d '"')
ASC_ISSUER_ID=$(grep '^ASC_ISSUER_ID=' "$FASTLANE_ENV" | cut -d'"' -f2 | tr -d '"')
# ASC_KEY_CONTENT: 複数行のPEM形式に対応（-----END で終端を検出）
ASC_KEY_CONTENT=$(awk '
  /^ASC_KEY_CONTENT=/ {
    found=1
    sub(/^ASC_KEY_CONTENT="/, "")
    sub(/"$/, "")
    print
    if (/-----END/) found=0
    next
  }
  found {
    sub(/"$/, "")
    print
    if (/-----END/) found=0
  }
' "$FASTLANE_ENV")

# prod.env から appId 取得
APP_ID_DOT=$(grep '^appId=' "$PROD_ENV" | cut -d'=' -f2 | tr -d '"' | tr -d "'")

[ -n "$ASC_KEY_ID"      ] || log_error "ASC_KEY_ID が ios/fastlane/.env に見つかりません"
[ -n "$ASC_ISSUER_ID"   ] || log_error "ASC_ISSUER_ID が ios/fastlane/.env に見つかりません"
[ -n "$ASC_KEY_CONTENT" ] || log_error "ASC_KEY_CONTENT が ios/fastlane/.env に見つかりません"
[ -n "$APP_ID_DOT"      ] || log_error "appId が dart_env/prod.env に見つかりません"

# Bundle ID = appId (例: com.example.myapp)
BUNDLE_ID="$APP_ID_DOT"
# Product ID prefix: ピリオドをアンダースコアに変換
APP_ID_UNDER="${APP_ID_DOT//./_}"

log_success "Bundle ID    : $BUNDLE_ID"
log_success "Product prefix: ${APP_ID_UNDER}"

# ─── 価格設定（固定） ─────────────────────────────────────────────────────────
MONTHLY_PRICE="4.99"
YEARLY_PRICE="34.99"
LIFETIME_PRICE="89.99"

# ─── Product ID 定義 ──────────────────────────────────────────────────────────
MONTHLY_PRODUCT_ID="${APP_ID_UNDER}_premium_monthly"
YEARLY_PRODUCT_ID="${APP_ID_UNDER}_premium_yearly"
LIFETIME_PRODUCT_ID="${APP_ID_UNDER}_premium_lifetime"

log_info "価格:       月額 \$${MONTHLY_PRICE} / 年額 \$${YEARLY_PRICE} / 買い切り \$${LIFETIME_PRICE}"
log_info "Product ID: 月額 $MONTHLY_PRODUCT_ID"
log_info "Product ID: 年額 $YEARLY_PRODUCT_ID"
log_info "Product ID: 買い切り $LIFETIME_PRODUCT_ID"

# ─── JWT トークン生成 ──────────────────────────────────────────────────────────
log_step "JWT トークン生成"

JWT_TOKEN=$(ruby - <<RUBY
require 'jwt'
require 'openssl'
key_content = """${ASC_KEY_CONTENT}"""
key = OpenSSL::PKey::EC.new(key_content)
payload = {
  iss: '${ASC_ISSUER_ID}',
  iat: Time.now.to_i,
  exp: Time.now.to_i + 1200,
  aud: 'appstoreconnect-v1'
}
puts JWT.encode(payload, key, 'ES256', { kid: '${ASC_KEY_ID}' })
RUBY
)

[ -n "$JWT_TOKEN" ] || log_error "JWT トークン生成に失敗しました"
log_success "JWT トークン生成完了"

ASC_BASE="https://api.appstoreconnect.apple.com/v1"
AUTH_HEADER="Authorization: Bearer $JWT_TOKEN"

# ─── ヘルパー関数 ─────────────────────────────────────────────────────────────
asc_get() {
  local url="$1"
  curl -s -g -H "$AUTH_HEADER" -H "Content-Type: application/json" "$url"
}

asc_post() {
  local url="$1"
  local body="$2"
  curl -s -g -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" -d "$body" "$url"
}

check_errors() {
  local response="$1"
  local context="$2"
  if echo "$response" | jq -e '.errors' &>/dev/null; then
    local msg
    msg=$(echo "$response" | jq -r '.errors[0].detail // .errors[0].title // "不明なエラー"')
    log_error "$context: $msg"
  fi
}

# ─── Step 1: App の数値 ID 取得（存在しない場合は自動作成） ──────────────────
log_step "Step 1: App の数値 ID 取得 (Bundle ID: $BUNDLE_ID)"

APP_RESP=$(asc_get "$ASC_BASE/apps?filter[bundleId]=$BUNDLE_ID")
check_errors "$APP_RESP" "App 取得"

NUMERIC_APP_ID=$(echo "$APP_RESP" | jq -r '.data[0].id // empty')
APP_NAME=$(echo "$APP_RESP" | jq -r '.data[0].attributes.name // "不明"')

if [ -z "$NUMERIC_APP_ID" ]; then
  log_warn "Bundle ID '$BUNDLE_ID' のアプリが見つかりません。App Store Connect に自動作成します..."

  # pubspec.yaml からアプリ名を取得（フォールバック: LumiLog）
  PUBSPEC="$ROOT_DIR/pubspec.yaml"
  if [ -f "$PUBSPEC" ]; then
    PUBSPEC_NAME=$(grep '^name:' "$PUBSPEC" | head -1 | awk '{print $2}' | tr '_' ' ' | sed 's/\b./\u&/g')
  fi
  APP_DISPLAY_NAME="${PUBSPEC_NAME:-LumiLog}"
  # SKU: Bundle IDのドットをハイフンに変換
  APP_SKU="${BUNDLE_ID//./-}"

  CREATE_APP_BODY=$(cat <<JSON
{
  "data": {
    "type": "apps",
    "attributes": {
      "bundleId": "$BUNDLE_ID",
      "name": "$APP_DISPLAY_NAME",
      "primaryLocale": "en-US",
      "sku": "$APP_SKU"
    }
  }
}
JSON
)
  CREATE_RESP=$(asc_post "$ASC_BASE/apps" "$CREATE_APP_BODY")

  if echo "$CREATE_RESP" | jq -e '.errors' &>/dev/null; then
    ERR=$(echo "$CREATE_RESP" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_error "App 自動作成失敗: $ERR\nApp Store Connect (https://appstoreconnect.apple.com) でアプリを手動作成後、再実行してください。"
  fi

  NUMERIC_APP_ID=$(echo "$CREATE_RESP" | jq -r '.data.id // empty')
  APP_NAME=$(echo "$CREATE_RESP" | jq -r '.data.attributes.name // "不明"')
  [ -n "$NUMERIC_APP_ID" ] || log_error "App 作成後のID取得に失敗しました"
  log_success "App 自動作成完了: $APP_NAME (ID: $NUMERIC_APP_ID)"
fi

log_success "App: $APP_NAME (ID: $NUMERIC_APP_ID)"

# ─── Step 2: サブスクリプショングループ作成 ──────────────────────────────────
log_step "Step 2: サブスクリプショングループ「Premium」作成"

# 既存グループ確認
EXISTING_GROUPS=$(asc_get "$ASC_BASE/apps/$NUMERIC_APP_ID/subscriptionGroups?filter[referenceName]=Premium")
EXISTING_GROUP_ID=$(echo "$EXISTING_GROUPS" | jq -r '.data[0].id // empty')

if [ -n "$EXISTING_GROUP_ID" ]; then
  log_warn "サブスクリプショングループ「Premium」は既に存在します (ID: $EXISTING_GROUP_ID)"
  GROUP_ID="$EXISTING_GROUP_ID"
else
  GROUP_BODY=$(cat <<JSON
{
  "data": {
    "type": "subscriptionGroups",
    "attributes": {
      "referenceName": "Premium"
    },
    "relationships": {
      "app": {
        "data": {"type": "apps", "id": "$NUMERIC_APP_ID"}
      }
    }
  }
}
JSON
)
  GROUP_RESP=$(asc_post "$ASC_BASE/subscriptionGroups" "$GROUP_BODY")
  check_errors "$GROUP_RESP" "サブスクリプショングループ作成"
  GROUP_ID=$(echo "$GROUP_RESP" | jq -r '.data.id')
  log_success "サブスクリプショングループ作成完了 (ID: $GROUP_ID)"
fi

# ─── Step 2.5: サブスクリプショングループ ローカライズ設定 ───────────────────
log_step "Step 2.5: サブスクリプショングループ ローカライズ設定"

# 既存ローカライズを取得して重複スキップ
EXISTING_GROUP_LOCS=$(asc_get "$ASC_BASE/subscriptionGroups/$GROUP_ID/subscriptionGroupLocalizations")
EXISTING_LOCALES=$(echo "$EXISTING_GROUP_LOCS" | jq -r '[.data[].attributes.locale] | join(" ")')

set_group_localization() {
  local locale="$1"
  local name="$2"

  if echo "$EXISTING_LOCALES" | grep -qw "$locale"; then
    log_warn "グループローカライズ '$locale' は既に設定済みです"
    return
  fi

  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptionGroupLocalizations",
    "attributes": {
      "locale": "$locale",
      "name": "$name"
    },
    "relationships": {
      "subscriptionGroup": {
        "data": {"type": "subscriptionGroups", "id": "$GROUP_ID"}
      }
    }
  }
}
JSON
)
  local resp
  resp=$(asc_post "$ASC_BASE/subscriptionGroupLocalizations" "$body")
  if echo "$resp" | jq -e '.errors' &>/dev/null; then
    local err
    err=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "グループローカライズ '$locale' 設定エラー: $err"
  else
    log_success "グループローカライズ '$locale' ($name) 設定完了"
  fi
}

# 主要39言語のサブスクリプショングループ名
set_group_localization "en-US"   "Premium"
set_group_localization "en-AU"   "Premium"
set_group_localization "en-CA"   "Premium"
set_group_localization "en-GB"   "Premium"
set_group_localization "ja"      "プレミアム"
set_group_localization "zh-Hans" "高级版"
set_group_localization "zh-Hant" "高級版"
set_group_localization "ko"      "프리미엄"
set_group_localization "de-DE"   "Premium"
set_group_localization "fr-FR"   "Premium"
set_group_localization "fr-CA"   "Premium"
set_group_localization "es-ES"   "Premium"
set_group_localization "es-MX"   "Premium"
set_group_localization "pt-BR"   "Premium"
set_group_localization "pt-PT"   "Premium"
set_group_localization "it"      "Premium"
set_group_localization "ru"      "Премиум"
set_group_localization "ar-SA"   "بريميوم"
set_group_localization "hi"      "प्रीमियम"
set_group_localization "tr"      "Premium"
set_group_localization "nl-NL"   "Premium"
set_group_localization "sv"      "Premium"
set_group_localization "da"      "Premium"
set_group_localization "no"      "Premium"
set_group_localization "fi"      "Premium"
set_group_localization "pl"      "Premium"
set_group_localization "cs"      "Premium"
set_group_localization "sk"      "Premium"
set_group_localization "hu"      "Prémium"
set_group_localization "ro"      "Premium"
set_group_localization "hr"      "Premium"
set_group_localization "el"      "Κορυφαίο"
set_group_localization "he"      "פרמיום"
set_group_localization "uk"      "Преміум"
set_group_localization "id"      "Premium"
set_group_localization "ms"      "Premium"
set_group_localization "th"      "พรีเมียม"
set_group_localization "vi"      "Cao Cấp"
set_group_localization "ca"      "Premium"

# ─── Step 3: 月額サブスクリプション作成 ─────────────────────────────────────
log_step "Step 3: 月額サブスクリプション作成 ($MONTHLY_PRODUCT_ID)"

create_or_get_subscription() {
  local product_id="$1"
  local ref_name="$2"
  local period="$3"  # ONE_WEEK / ONE_MONTH / TWO_MONTHS / THREE_MONTHS / SIX_MONTHS / ONE_YEAR

  # 既存確認
  local existing
  existing=$(asc_get "$ASC_BASE/subscriptionGroups/$GROUP_ID/subscriptions?filter[productId]=$product_id")
  local existing_id
  existing_id=$(echo "$existing" | jq -r '.data[0].id // empty')

  if [ -n "$existing_id" ]; then
    log_warn "$ref_name は既に存在します (ID: $existing_id)"
    echo "$existing_id"
    return
  fi

  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptions",
    "attributes": {
      "name": "$ref_name",
      "productId": "$product_id",
      "subscriptionPeriod": "$period",
      "reviewNote": "Premium subscription providing full access to all features.",
      "groupLevel": 1
    },
    "relationships": {
      "group": {
        "data": {"type": "subscriptionGroups", "id": "$GROUP_ID"}
      }
    }
  }
}
JSON
)
  local resp
  resp=$(asc_post "$ASC_BASE/subscriptions" "$body")
  check_errors "$resp" "$ref_name 作成"
  local sub_id
  sub_id=$(echo "$resp" | jq -r '.data.id')
  log_success "$ref_name 作成完了 (ID: $sub_id)"
  echo "$sub_id"
}

MONTHLY_SUB_ID=$(create_or_get_subscription "$MONTHLY_PRODUCT_ID" "Monthly Premium" "ONE_MONTH")
YEARLY_SUB_ID=$(create_or_get_subscription "$YEARLY_PRODUCT_ID" "Yearly Premium" "ONE_YEAR")

# ─── Step 3.5: 配信状況（全地域）設定 ───────────────────────────────────────
log_step "Step 3.5: 配信状況（全地域）設定"

set_subscription_availability() {
  local sub_id="$1"
  local sub_name="$2"

  # 既存の配信状況を確認
  local existing
  existing=$(asc_get "$ASC_BASE/subscriptions/$sub_id/subscriptionAvailability")
  local existing_id
  existing_id=$(echo "$existing" | jq -r '.data.id // empty')

  if [ -n "$existing_id" ]; then
    log_warn "$sub_name: 配信状況は既に設定済みです"
    return
  fi

  # availableInNewTerritories: true + 空配列 = 全地域に自動配信
  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptionAvailabilities",
    "attributes": {
      "availableInNewTerritories": true
    },
    "relationships": {
      "subscription": {
        "data": {"type": "subscriptions", "id": "$sub_id"}
      },
      "availableTerritories": {
        "data": []
      }
    }
  }
}
JSON
)

  local resp
  resp=$(asc_post "$ASC_BASE/subscriptionAvailabilities" "$body")
  if echo "$resp" | jq -e '.errors' &>/dev/null; then
    local err
    err=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "$sub_name 配信状況設定エラー: $err"
  else
    log_success "$sub_name 配信状況設定完了（全地域・新地域自動追加）"
  fi
}

set_subscription_availability "$MONTHLY_SUB_ID" "月額"
set_subscription_availability "$YEARLY_SUB_ID"  "年額"

# ─── Step 4: ローカライズ（英語）設定 ────────────────────────────────────────
log_step "Step 4: サブスクリプション 英語ローカライズ設定"

set_subscription_localization() {
  local sub_id="$1"
  local display_name="$2"
  local description="$3"
  local locale="${4:-en-US}"

  # 既存ローカライズ確認（キャッシュ最適化のため全件取得して絞り込み）
  local existing
  existing=$(asc_get "$ASC_BASE/subscriptions/$sub_id/subscriptionLocalizations")
  local existing_id
  existing_id=$(echo "$existing" | jq -r --arg loc "$locale" '[.data[] | select(.attributes.locale == $loc)] | .[0].id // empty')

  if [ -n "$existing_id" ]; then
    log_warn "'$display_name' ($locale) は既に設定済みです"
    return
  fi

  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptionLocalizations",
    "attributes": {
      "locale": "$locale",
      "name": "$display_name",
      "description": "$description"
    },
    "relationships": {
      "subscription": {
        "data": {"type": "subscriptions", "id": "$sub_id"}
      }
    }
  }
}
JSON
)
  local resp
  resp=$(asc_post "$ASC_BASE/subscriptionLocalizations" "$body")
  if echo "$resp" | jq -e '.errors' &>/dev/null; then
    local err
    err=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "'$display_name' ($locale) ローカライズエラー: $err"
  else
    log_success "'$display_name' ($locale) ローカライズ設定完了"
  fi
}

# 月額・年額の表示名と説明を39言語分設定
# locale / monthly_name / yearly_name / monthly_desc(≤55) / yearly_desc(≤55)
declare -a LOCALES=(
  "en-US:Monthly Premium:Yearly Premium:Full access to all features. Cancel anytime.:Best value. Full access. Cancel anytime."
  "en-AU:Monthly Premium:Yearly Premium:Full access to all features. Cancel anytime.:Best value. Full access. Cancel anytime."
  "en-CA:Monthly Premium:Yearly Premium:Full access to all features. Cancel anytime.:Best value. Full access. Cancel anytime."
  "en-GB:Monthly Premium:Yearly Premium:Full access to all features. Cancel anytime.:Best value. Full access. Cancel anytime."
  "ja:月額プレミアム:年額プレミアム:すべての機能が使い放題。いつでも解約可。:お得な年額プラン。全機能利用可。"
  "zh-Hans:月度高级版:年度高级版:解锁全部功能，随时取消。:最优惠年度计划，解锁全部功能。"
  "zh-Hant:月度高級版:年度高級版:解鎖所有功能，隨時取消。:最優惠年度方案，解鎖所有功能。"
  "ko:월간 프리미엄:연간 프리미엄:모든 기능 이용 가능. 언제든 취소.:최고의 혜택 연간 플랜. 전체 이용."
  "de-DE:Monatliches Premium:Jährliches Premium:Alle Funktionen nutzen. Jederzeit kündbar.:Bestes Angebot. Alle Funktionen. Kündbar."
  "fr-FR:Premium mensuel:Premium annuel:Accès complet. Annulable à tout moment.:Meilleure offre. Accès complet. Annulable."
  "fr-CA:Premium mensuel:Premium annuel:Accès complet. Annulable à tout moment.:Meilleure offre. Accès complet. Annulable."
  "es-ES:Premium mensual:Premium anual:Acceso completo. Cancela cuando quieras.:Mejor precio. Acceso completo. Cancelable."
  "es-MX:Premium mensual:Premium anual:Acceso completo. Cancela cuando quieras.:Mejor precio. Acceso completo. Cancelable."
  "pt-BR:Premium mensal:Premium anual:Acesso completo. Cancele quando quiser.:Melhor oferta. Acesso completo. Cancelável."
  "pt-PT:Premium mensal:Premium anual:Acesso completo. Cancele quando quiser.:Melhor oferta. Acesso completo. Cancelável."
  "it:Premium mensile:Premium annuale:Accesso completo. Disdici quando vuoi.:Miglior offerta. Accesso completo. Annullabile."
  "ru:Ежемесячный Премиум:Ежегодный Премиум:Полный доступ. Отмена в любое время.:Лучшая цена. Полный доступ. Отменяемо."
  "ar-SA:بريميوم شهري:بريميوم سنوي:وصول كامل. إلغاء في أي وقت.:أفضل قيمة. وصول كامل. قابل للإلغاء."
  "hi:मासिक प्रीमियम:वार्षिक प्रीमियम:पूर्ण पहुंच। कभी भी रद्द करें।:सर्वश्रेष्ठ मूल्य। पूर्ण पहुंच।"
  "tr:Aylık Premium:Yıllık Premium:Tüm özelliklere erişim. İstediğinde iptal.:En iyi fiyat. Tam erişim. İptal edilebilir."
  "nl-NL:Maandelijks Premium:Jaarlijks Premium:Volledige toegang. Altijd opzegbaar.:Beste waarde. Volledige toegang. Opzegbaar."
  "sv:Månatlig Premium:Årlig Premium:Full tillgång. Avbryt när som helst.:Bästa pris. Full tillgång. Avbrytbar."
  "da:Månedlig Premium:Årlig Premium:Fuld adgang. Annuller når som helst.:Bedste pris. Fuld adgang. Kan annulleres."
  "no:Månedlig Premium:Årlig Premium:Full tilgang. Avbryt når som helst.:Beste verdi. Full tilgang. Kan avbrytes."
  "fi:Kuukausittainen Premium:Vuosittainen Premium:Täysi pääsy. Peruuta milloin tahansa.:Paras hinta. Täysi pääsy. Peruutettavissa."
  "pl:Premium miesięczny:Premium roczny:Pełny dostęp. Anuluj w dowolnej chwili.:Najlepsza cena. Pełny dostęp. Anulowalne."
  "cs:Měsíční Premium:Roční Premium:Plný přístup. Zrušte kdykoli.:Nejlepší cena. Plný přístup. Zrušitelné."
  "sk:Mesačné Premium:Ročné Premium:Plný prístup. Zrušte kedykoľvek.:Najlepšia cena. Plný prístup. Zrušiteľné."
  "hu:Havi Prémium:Éves Prémium:Teljes hozzáférés. Bármikor lemondható.:Legjobb ár. Teljes hozzáférés. Lemondható."
  "ro:Premium lunar:Premium anual:Acces complet. Anulați oricând.:Cel mai bun preț. Acces complet. Anulabil."
  "hr:Mjesečni Premium:Godišnji Premium:Puni pristup. Otkaži bilo kada.:Najbolja cijena. Puni pristup. Otkazivo."
  "el:Μηνιαίο Κορυφαίο:Ετήσιο Κορυφαίο:Πλήρης πρόσβαση. Ακύρωση ανά πάσα στιγμή.:Καλύτερη αξία. Πλήρης πρόσβαση."
  "he:פרמיום חודשי:פרמיום שנתי:גישה מלאה. בטל בכל עת.:הערך הטוב ביותר. גישה מלאה. ניתן לביטול."
  "uk:Щомісячний Преміум:Щорічний Преміум:Повний доступ. Скасуйте будь-коли.:Найкраща ціна. Повний доступ. Скасовуване."
  "id:Premium Bulanan:Premium Tahunan:Akses penuh. Batalkan kapan saja.:Nilai terbaik. Akses penuh. Dapat dibatalkan."
  "ms:Premium Bulanan:Premium Tahunan:Akses penuh. Batal bila-bila masa.:Nilai terbaik. Akses penuh. Boleh dibatal."
  "th:พรีเมียมรายเดือน:พรีเมียมรายปี:เข้าถึงทุกฟีเจอร์ ยกเลิกได้ทุกเมื่อ:ราคาดีที่สุด เข้าถึงเต็มรูปแบบ"
  "vi:Premium Hàng Tháng:Premium Hàng Năm:Truy cập đầy đủ. Hủy bất kỳ lúc nào.:Giá tốt nhất. Truy cập đầy đủ. Có thể hủy."
  "ca:Premium mensual:Premium anual:Accés complet. Cancel·la quan vulguis.:Millor preu. Accés complet. Cancel·lable."
)

for entry in "${LOCALES[@]}"; do
  IFS=':' read -r locale monthly_name yearly_name monthly_desc yearly_desc <<< "$entry"
  set_subscription_localization "$MONTHLY_SUB_ID" "$monthly_name" "$monthly_desc" "$locale"
  set_subscription_localization "$YEARLY_SUB_ID"  "$yearly_name"  "$yearly_desc"  "$locale"
done

# ─── Step 5: 価格設定（USD基準） ─────────────────────────────────────────────
log_step "Step 5: 価格設定"

set_subscription_price() {
  local sub_id="$1"
  local target_price="$2"
  local sub_name="$3"

  # 米国の価格ポイント一覧を取得してマッチング
  local price_points_resp
  price_points_resp=$(asc_get "$ASC_BASE/subscriptions/$sub_id/pricePoints?filter[territory]=USA&limit=200")

  if echo "$price_points_resp" | jq -e '.errors' &>/dev/null; then
    log_warn "$sub_name: 価格ポイント取得に失敗。App Store Connect で手動設定してください。"
    return
  fi

  # 完全一致で価格ポイントを探す（フォールバック: 近似値）
  local price_point_id
  price_point_id=$(echo "$price_points_resp" | jq -r \
    --arg target "$target_price" \
    '.data[] | select(.attributes.customerPrice == $target) | .id' | head -1)

  local matched_price="$target_price"

  if [ -z "$price_point_id" ]; then
    # 完全一致なし → 近似値で検索
    price_point_id=$(echo "$price_points_resp" | jq -r \
      --argjson target "$target_price" \
      '.data | sort_by((.attributes.customerPrice | tonumber) - $target | fabs) | .[0].id // empty')
    matched_price=$(echo "$price_points_resp" | jq -r \
      --argjson target "$target_price" \
      '.data | sort_by((.attributes.customerPrice | tonumber) - $target | fabs) | .[0].attributes.customerPrice // "不明"')
    log_warn "$sub_name: \$${target_price} 完全一致なし → 近似値 \$${matched_price} を使用（App Store Connect で手動確認してください）"
  fi

  if [ -z "$price_point_id" ]; then
    log_warn "$sub_name: 価格ポイントが見つかりません。App Store Connect で手動設定してください。"
    return
  fi

  log_info "$sub_name: \$${target_price} → \$${matched_price} (ID: $price_point_id)"

  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptionPrices",
    "attributes": {
      "startDate": null,
      "preserveCurrentPrice": false
    },
    "relationships": {
      "subscription": {
        "data": {"type": "subscriptions", "id": "$sub_id"}
      },
      "subscriptionPricePoint": {
        "data": {"type": "subscriptionPricePoints", "id": "$price_point_id"}
      }
    }
  }
}
JSON
)
  local resp
  resp=$(asc_post "$ASC_BASE/subscriptionPrices" "$body")
  if echo "$resp" | jq -e '.errors' &>/dev/null; then
    local err_msg
    err_msg=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "$sub_name 価格設定エラー: $err_msg（App Store Connect で手動設定してください）"
  else
    log_success "$sub_name 価格設定完了 (\$${matched_price})"
  fi
}

set_subscription_price "$MONTHLY_SUB_ID" "$MONTHLY_PRICE" "月額"

# 年額価格は Apple API の仕様制限（MISSING_METADATA状態で高価格帯ポイント未返却）により手動設定が必要
log_warn "年額価格・全地域価格再計算は App Store Connect で手動設定してください"
log_warn "  URL: https://appstoreconnect.apple.com"
log_warn "  【月額】配信 → サブスクリプション → Monthly Premium → サブスクリプション価格 →「すべての国または地域について、価格を再計算」→ 保存"
log_warn "  【年額】配信 → サブスクリプション → Yearly Premium → サブスクリプション価格 → \$${YEARLY_PRICE} を追加 →「すべての国または地域について、価格を再計算」→ 保存"

# ─── Step 6: 無料トライアル（IntroductoryOffer）設定 ─────────────────────────
log_step "Step 6: 無料トライアル設定"

set_free_trial() {
  local sub_id="$1"
  local duration="$2"  # THREE_DAYS / ONE_WEEK / TWO_WEEKS / ONE_MONTH
  local sub_name="$3"

  # 既存の IntroductoryOffer 確認
  local existing
  existing=$(asc_get "$ASC_BASE/subscriptions/$sub_id/introductoryOffers")
  local existing_count
  existing_count=$(echo "$existing" | jq '.data | length')

  if [ "$existing_count" -gt 0 ] 2>/dev/null; then
    log_warn "$sub_name: 無料トライアルは既に設定済みです"
    return
  fi

  # 無料トライアル用の価格ポイント（\$0）を取得
  local price_points_resp
  price_points_resp=$(asc_get "$ASC_BASE/subscriptions/$sub_id/pricePoints?filter[territory]=USA&limit=200")
  local free_price_point_id
  free_price_point_id=$(echo "$price_points_resp" | jq -r \
    '.data[] | select(.attributes.customerPrice == "0.00") | .id' | head -1)

  if [ -z "$free_price_point_id" ]; then
    log_warn "$sub_name: \$0 価格ポイントが見つかりません。App Store Connect で手動設定してください。"
    return
  fi

  local body
  body=$(cat <<JSON
{
  "data": {
    "type": "subscriptionIntroductoryOffers",
    "attributes": {
      "offerMode": "FREE_TRIAL",
      "duration": "$duration",
      "periodCount": 1,
      "startDate": null,
      "endDate": null
    },
    "relationships": {
      "subscription": {
        "data": {"type": "subscriptions", "id": "$sub_id"}
      },
      "subscriptionPricePoint": {
        "data": {"type": "subscriptionPricePoints", "id": "$free_price_point_id"}
      }
    }
  }
}
JSON
)
  local resp
  resp=$(asc_post "$ASC_BASE/subscriptionIntroductoryOffers" "$body")
  if echo "$resp" | jq -e '.errors' &>/dev/null; then
    local err_msg
    err_msg=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "$sub_name 無料トライアル設定エラー: $err_msg（App Store Connect で手動設定してください）"
  else
    log_success "$sub_name 無料トライアル設定完了 ($duration)"
  fi
}

set_free_trial "$MONTHLY_SUB_ID" "ONE_WEEK" "月額"
set_free_trial "$YEARLY_SUB_ID"  "ONE_WEEK" "年額"

# ─── Step 7: 買い切り（Non-Consumable）IAP 作成 ───────────────────────────────
log_step "Step 7: 買い切り（Non-Consumable）作成 ($LIFETIME_PRODUCT_ID)"

# 既存確認: v2 API (apps/{id}/inAppPurchasesV2) で検索
EXISTING_IAP=$(asc_get "$ASC_BASE/apps/$NUMERIC_APP_ID/inAppPurchasesV2?filter[productId]=$LIFETIME_PRODUCT_ID&limit=10")
EXISTING_IAP_ID=$(echo "$EXISTING_IAP" | jq -r --arg pid "$LIFETIME_PRODUCT_ID" \
  '.data[] | select(.attributes.productId == $pid) | .id' | head -1)

# v2 で見つからない場合は v1 でも確認
if [ -z "$EXISTING_IAP_ID" ]; then
  EXISTING_IAP_V1=$(asc_get "$ASC_BASE/apps/$NUMERIC_APP_ID/inAppPurchasesV2?limit=50")
  EXISTING_IAP_ID=$(echo "$EXISTING_IAP_V1" | jq -r --arg pid "$LIFETIME_PRODUCT_ID" \
    '.data[] | select(.attributes.productId == $pid) | .id' | head -1)
fi

if [ -n "$EXISTING_IAP_ID" ]; then
  log_warn "買い切り商品は既に存在します (ID: $EXISTING_IAP_ID)"
  LIFETIME_IAP_ID="$EXISTING_IAP_ID"
else
  IAP_BODY=$(cat <<JSON
{
  "data": {
    "type": "inAppPurchases",
    "attributes": {
      "referenceName": "Lifetime Premium",
      "productId": "$LIFETIME_PRODUCT_ID",
      "inAppPurchaseType": "NON_CONSUMABLE",
      "reviewNote": "One-time purchase providing lifetime access to all premium features."
    },
    "relationships": {
      "app": {
        "data": {"type": "apps", "id": "$NUMERIC_APP_ID"}
      }
    }
  }
}
JSON
)
  IAP_RESP=$(asc_post "$ASC_BASE/inAppPurchases" "$IAP_BODY")
  if echo "$IAP_RESP" | jq -e '.errors' &>/dev/null; then
    ERR=$(echo "$IAP_RESP" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
    log_warn "買い切り作成エラー: $ERR"
    log_warn "App Store Connect で手動作成してください"
    LIFETIME_IAP_ID="<手動作成必要>"
  else
    LIFETIME_IAP_ID=$(echo "$IAP_RESP" | jq -r '.data.id')
    log_success "買い切り商品作成完了 (ID: $LIFETIME_IAP_ID)"
  fi
fi

# ─── Step 8: 買い切りローカライズ（39言語） ──────────────────────────────────
log_step "Step 8: 買い切り ローカライズ設定（39言語）"

if [[ "$LIFETIME_IAP_ID" != "<手動作成必要>" ]]; then
  # 既存ローカライズを取得して重複スキップ（v2 API）
  EXISTING_IAP_LOCS=$(asc_get "$ASC_BASE/inAppPurchasesV2/$LIFETIME_IAP_ID/inAppPurchaseLocalizations")
  EXISTING_IAP_LOCALES=$(echo "$EXISTING_IAP_LOCS" | jq -r '[.data[]?.attributes.locale] | join(" ")' 2>/dev/null || echo "")

  set_iap_localization() {
    local locale="$1"
    local name="$2"
    local description="$3"

    if echo "$EXISTING_IAP_LOCALES" | grep -qw "$locale"; then
      log_warn "買い切りローカライズ '$locale' は既に設定済みです"
      return
    fi

    local body
    body=$(cat <<JSON
{
  "data": {
    "type": "inAppPurchaseLocalizations",
    "attributes": {
      "locale": "$locale",
      "name": "$name",
      "description": "$description"
    },
    "relationships": {
      "inAppPurchaseV2": {
        "data": {"type": "inAppPurchases", "id": "$LIFETIME_IAP_ID"}
      }
    }
  }
}
JSON
)
    local resp
    resp=$(asc_post "$ASC_BASE/inAppPurchaseLocalizations" "$body")
    if echo "$resp" | jq -e '.errors' &>/dev/null; then
      local err
      err=$(echo "$resp" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
      log_warn "買い切りローカライズ '$locale' エラー: $err"
    else
      log_success "買い切りローカライズ '$locale' ($name) 設定完了"
    fi
  }

  set_iap_localization "en-US"   "Lifetime Premium"          "One-time. Full access to all features forever."
  set_iap_localization "en-AU"   "Lifetime Premium"          "One-time. Full access to all features forever."
  set_iap_localization "en-CA"   "Lifetime Premium"          "One-time. Full access to all features forever."
  set_iap_localization "en-GB"   "Lifetime Premium"          "One-time. Full access to all features forever."
  set_iap_localization "ja"      "買い切りプレミアム"           "一度の購入で永久にすべての機能を利用できます。"
  set_iap_localization "zh-Hans" "终身高级版"                  "一次性购买，永久解锁所有高级功能。"
  set_iap_localization "zh-Hant" "終身高級版"                  "一次性購買，永久解鎖所有高級功能。"
  set_iap_localization "ko"      "평생 프리미엄"               "한 번 구매로 모든 기능을 영구 이용하세요."
  set_iap_localization "de-DE"   "Lifetime Premium"          "Einmaliger Kauf. Alle Funktionen für immer."
  set_iap_localization "fr-FR"   "Premium à vie"             "Achat unique. Accès complet à vie."
  set_iap_localization "fr-CA"   "Premium à vie"             "Achat unique. Accès complet à vie."
  set_iap_localization "es-ES"   "Premium de por vida"       "Compra única. Acceso completo para siempre."
  set_iap_localization "es-MX"   "Premium de por vida"       "Compra única. Acceso completo para siempre."
  set_iap_localization "pt-BR"   "Premium vitalício"         "Compra única. Acesso total para sempre."
  set_iap_localization "pt-PT"   "Premium vitalício"         "Compra única. Acesso total para sempre."
  set_iap_localization "it"      "Premium a vita"            "Acquisto unico. Accesso completo per sempre."
  set_iap_localization "ru"      "Пожизненный Премиум"       "Единовременная покупка. Доступ навсегда."
  set_iap_localization "ar-SA"   "بريميوم مدى الحياة"        "شراء لمرة واحدة. وصول دائم لكل الميزات."
  set_iap_localization "hi"      "लाइफटाइम प्रीमियम"         "एक बार खरीदें। सभी सुविधाएं हमेशा के लिए।"
  set_iap_localization "tr"      "Ömür Boyu Premium"         "Tek seferlik. Tüm özelliklere süresiz erişim."
  set_iap_localization "nl-NL"   "Lifetime Premium"          "Eenmalig. Volledige toegang voor altijd."
  set_iap_localization "sv"      "Livstids Premium"          "Engångsköp. Full tillgång för alltid."
  set_iap_localization "da"      "Livstids Premium"          "Engangskøb. Fuld adgang for altid."
  set_iap_localization "no"      "Livstids Premium"          "Engangskjøp. Full tilgang for alltid."
  set_iap_localization "fi"      "Elinikäinen Premium"       "Kertaosto. Täysi pääsy ikuisesti."
  set_iap_localization "pl"      "Premium dożywotnie"        "Jednorazowy zakup. Pełny dostęp na zawsze."
  set_iap_localization "cs"      "Doživotní Premium"         "Jednorázový nákup. Plný přístup navždy."
  set_iap_localization "sk"      "Doživotné Premium"         "Jednorazový nákup. Plný prístup navždy."
  set_iap_localization "hu"      "Élethosszig tartó Prémium" "Egyszeri vásárlás. Teljes hozzáférés örökre."
  set_iap_localization "ro"      "Premium pe viață"          "Cumpărare unică. Acces complet pe viață."
  set_iap_localization "hr"      "Doživotni Premium"         "Jednokratna kupnja. Puni pristup zauvijek."
  set_iap_localization "el"      "Δια Βίου Κορυφαίο"         "Εφάπαξ αγορά. Μόνιμη πρόσβαση σε όλα."
  set_iap_localization "he"      "פרמיום לכל החיים"          "רכישה חד פעמית. גישה קבועה לכל הפרמיום."
  set_iap_localization "uk"      "Довічний Преміум"          "Одноразова покупка. Доступ назавжди."
  set_iap_localization "id"      "Premium Seumur Hidup"      "Sekali beli. Akses penuh selamanya."
  set_iap_localization "ms"      "Premium Seumur Hidup"      "Beli sekali. Akses penuh selamanya."
  set_iap_localization "th"      "พรีเมียมตลอดชีพ"           "ซื้อครั้งเดียว เข้าถึงทุกฟีเจอร์ตลอดไป"
  set_iap_localization "vi"      "Premium Trọn Đời"          "Mua một lần. Truy cập đầy đủ mãi mãi."
  set_iap_localization "ca"      "Premium vitalici"          "Compra única. Accés complet per sempre."
fi

# ─── Step 9: 買い切り価格設定 ────────────────────────────────────────────────
log_step "Step 9: 買い切り価格設定 (\$$LIFETIME_PRICE)"

if [[ "$LIFETIME_IAP_ID" != "<手動作成必要>" ]]; then
  # 米国の価格ポイント一覧を取得
  IAP_PRICE_POINTS_RESP=$(asc_get "$ASC_BASE/inAppPurchases/$LIFETIME_IAP_ID/pricePoints?filter[territory]=USA&limit=200")

  if echo "$IAP_PRICE_POINTS_RESP" | jq -e '.errors' &>/dev/null; then
    log_warn "買い切り: 価格ポイント取得に失敗。App Store Connect で手動設定してください。"
  else
    LIFETIME_PRICE_POINT_ID=$(echo "$IAP_PRICE_POINTS_RESP" | jq -r \
      --argjson target "$LIFETIME_PRICE" \
      '.data | sort_by((.attributes.customerPrice | tonumber) - $target | fabs) | .[0].id // empty')
    LIFETIME_MATCHED_PRICE=$(echo "$IAP_PRICE_POINTS_RESP" | jq -r \
      --argjson target "$LIFETIME_PRICE" \
      '.data | sort_by((.attributes.customerPrice | tonumber) - $target | fabs) | .[0].attributes.customerPrice // "不明"')

    if [ -z "$LIFETIME_PRICE_POINT_ID" ]; then
      log_warn "買い切り: 価格ポイントが見つかりません。App Store Connect で手動設定してください。"
    else
      log_info "買い切り: \$${LIFETIME_PRICE} → \$${LIFETIME_MATCHED_PRICE} (ID: $LIFETIME_PRICE_POINT_ID)"

      PRICE_SCHEDULE_BODY=$(cat <<JSON
{
  "data": {
    "type": "iapPriceSchedules",
    "relationships": {
      "inAppPurchase": {
        "data": {"type": "inAppPurchases", "id": "$LIFETIME_IAP_ID"}
      },
      "baseTerritory": {
        "data": {"type": "territories", "id": "USA"}
      },
      "manualPrices": {
        "data": [{"type": "inAppPurchasePrices", "id": "temp-1"}]
      }
    }
  },
  "included": [
    {
      "type": "inAppPurchasePrices",
      "id": "temp-1",
      "attributes": {
        "startDate": null
      },
      "relationships": {
        "inAppPurchasePricePoint": {
          "data": {"type": "inAppPurchasePricePoints", "id": "$LIFETIME_PRICE_POINT_ID"}
        }
      }
    }
  ]
}
JSON
)
      PRICE_SCHEDULE_RESP=$(asc_post "$ASC_BASE/iapPriceSchedules" "$PRICE_SCHEDULE_BODY")
      if echo "$PRICE_SCHEDULE_RESP" | jq -e '.errors' &>/dev/null; then
        ERR=$(echo "$PRICE_SCHEDULE_RESP" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
        log_warn "買い切り価格設定エラー: $ERR（App Store Connect で手動設定してください）"
      else
        log_success "買い切り価格設定完了 (\$${LIFETIME_MATCHED_PRICE})"
      fi
    fi
  fi
fi

# ─── Step 10: 審査用スクリーンショット アップロード ──────────────────────────
log_step "Step 10: 審査用スクリーンショット アップロード"

SCREENSHOT_PATH="$SCRIPT_DIR/review_screenshot.png"

if [[ "$LIFETIME_IAP_ID" == "<手動作成必要>" ]]; then
  log_warn "買い切り商品が未作成のためスクリーンショットをスキップします"
elif [ ! -f "$SCREENSHOT_PATH" ]; then
  log_warn "スクリーンショットが見つかりません: $SCREENSHOT_PATH"
  log_warn "640×920px の PNG を上記パスに配置して再実行してください"
else
  SCREENSHOT_SIZE=$(wc -c < "$SCREENSHOT_PATH" | tr -d ' ')
  SCREENSHOT_NAME="review_screenshot.png"

  # 既存スクリーンショット確認
  EXISTING_SS=$(asc_get "$ASC_BASE/inAppPurchases/$LIFETIME_IAP_ID/appStoreReviewScreenshot")
  EXISTING_SS_ID=$(echo "$EXISTING_SS" | jq -r '.data.id // empty')

  if [ -n "$EXISTING_SS_ID" ]; then
    log_warn "審査用スクリーンショットは既にアップロード済みです (ID: $EXISTING_SS_ID)"
  else
    # Step 10-1: アップロード予約
    SS_RESERVE_BODY=$(cat <<JSON
{
  "data": {
    "type": "inAppPurchaseAppStoreReviewScreenshots",
    "attributes": {
      "fileName": "$SCREENSHOT_NAME",
      "fileSize": $SCREENSHOT_SIZE
    },
    "relationships": {
      "inAppPurchaseV2": {
        "data": {"type": "inAppPurchases", "id": "$LIFETIME_IAP_ID"}
      }
    }
  }
}
JSON
)
    SS_RESERVE_RESP=$(asc_post "$ASC_BASE/inAppPurchaseAppStoreReviewScreenshots" "$SS_RESERVE_BODY")

    if echo "$SS_RESERVE_RESP" | jq -e '.errors' &>/dev/null; then
      ERR=$(echo "$SS_RESERVE_RESP" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
      log_warn "スクリーンショット予約エラー: $ERR（App Store Connect で手動アップロードしてください）"
    else
      SS_ID=$(echo "$SS_RESERVE_RESP" | jq -r '.data.id')
      UPLOAD_URL=$(echo "$SS_RESERVE_RESP" | jq -r '.data.attributes.uploadOperations[0].url // empty')
      UPLOAD_METHOD=$(echo "$SS_RESERVE_RESP" | jq -r '.data.attributes.uploadOperations[0].method // "PUT"')

      # アップロード操作のヘッダーを組み立て
      UPLOAD_HEADERS=$(echo "$SS_RESERVE_RESP" | jq -r \
        '.data.attributes.uploadOperations[0].requestHeaders[]? | "-H \"\(.name): \(.value)\""' | tr '\n' ' ')

      if [ -z "$UPLOAD_URL" ]; then
        log_warn "アップロード URL が取得できませんでした（App Store Connect で手動アップロードしてください）"
      else
        # Step 10-2: ファイルアップロード
        log_info "スクリーンショットをアップロード中..."
        eval curl -s -X "$UPLOAD_METHOD" $UPLOAD_HEADERS \
          --data-binary "@$SCREENSHOT_PATH" \
          "$UPLOAD_URL" > /dev/null

        # Step 10-3: コミット
        SS_COMMIT_BODY=$(cat <<JSON
{
  "data": {
    "type": "inAppPurchaseAppStoreReviewScreenshots",
    "id": "$SS_ID",
    "attributes": {
      "uploaded": true
    }
  }
}
JSON
)
        SS_COMMIT_RESP=$(curl -s -X PATCH \
          -H "$AUTH_HEADER" \
          -H "Content-Type: application/json" \
          -d "$SS_COMMIT_BODY" \
          "$ASC_BASE/inAppPurchaseAppStoreReviewScreenshots/$SS_ID")

        if echo "$SS_COMMIT_RESP" | jq -e '.errors' &>/dev/null; then
          ERR=$(echo "$SS_COMMIT_RESP" | jq -r '.errors[0].detail // .errors[0].title // "不明"')
          log_warn "スクリーンショットのコミットエラー: $ERR"
        else
          log_success "審査用スクリーンショット アップロード完了"
        fi
      fi
    fi
  fi
fi

# ─── 完了サマリー ─────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  🎉 App Store Connect IAP セットアップ完了${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}アプリ:${NC}                 $APP_NAME ($BUNDLE_ID)"
echo -e "  ${BOLD}サブスクリプション群:${NC}   $GROUP_ID"
echo -e "  ${BOLD}月額 Sub ID:${NC}            $MONTHLY_SUB_ID"
echo -e "  ${BOLD}年額 Sub ID:${NC}            $YEARLY_SUB_ID"
echo -e "  ${BOLD}買い切り IAP ID:${NC}        $LIFETIME_IAP_ID"
echo ""
echo -e "  ${BOLD}Product IDs（RevenueCatに登録する値）:${NC}"
echo -e "    月額:     ${CYAN}$MONTHLY_PRODUCT_ID${NC}"
echo -e "    年額:     ${CYAN}$YEARLY_PRODUCT_ID${NC}"
echo -e "    買い切り: ${CYAN}$LIFETIME_PRODUCT_ID${NC}"
echo ""
echo -e "${YELLOW}⚠️  次のステップ:${NC}"
echo -e "  1. App Store Connect で内容を確認し「審査に登録」"
echo -e "     スクリーンショット: 配置済みなら自動アップロード済み"
echo -e "     未配置の場合: ${CYAN}$SCREENSHOT_PATH${NC} に PNG を配置して再実行"
echo -e "  2. setup_revenuecat.sh を実行して RevenueCat に登録"
echo ""

# Product IDsを共有ファイルに保存（setup_revenuecat.sh から読み込む）
SHARED_FILE="$SCRIPT_DIR/.iap_product_ids"
cat > "$SHARED_FILE" <<EOF
BUNDLE_ID="${BUNDLE_ID}"
APP_ID_UNDER="${APP_ID_UNDER}"
MONTHLY_PRODUCT_ID="${MONTHLY_PRODUCT_ID}"
YEARLY_PRODUCT_ID="${YEARLY_PRODUCT_ID}"
LIFETIME_PRODUCT_ID="${LIFETIME_PRODUCT_ID}"
EOF
log_info "Product ID を $SHARED_FILE に保存しました"
