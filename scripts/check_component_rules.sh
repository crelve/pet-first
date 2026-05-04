#!/bin/bash

# コンポーネント使用ルール違反チェックスクリプト
# 禁止コンポーネントの直接使用を検出:
#   - ボタン: ElevatedButton, TextButton, IconButton, FloatingActionButton
#   - ダイアログ: AlertDialog, SimpleDialog, Dialog
#   - スナックバー: ScaffoldMessenger, SnackBar
#   - ヘッダー: AppBar, SliverAppBar

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔍 コンポーネント使用ルール違反チェック${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 検索対象ディレクトリ
TARGET_DIR="lib"

# 除外ディレクトリ（正当な使用が許可される場所）
EXCLUDE_DIRS=(
  "lib/component/button"
  "lib/component/dialog"
  "lib/component/snackbar"
  "lib/gen"
)

# 除外パターンを構築
EXCLUDE_PATTERN=""
for dir in "${EXCLUDE_DIRS[@]}"; do
  EXCLUDE_PATTERN="$EXCLUDE_PATTERN --exclude-dir=$dir"
done

# 違反カウンター
VIOLATION_COUNT=0

# 一時ファイル
TEMP_FILE=$(mktemp)

# 1. ElevatedButton の直接使用チェック
echo -e "${YELLOW}📋 チェック1: ElevatedButton の直接使用${NC}"
if grep -rn "ElevatedButton(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${RED}❌ ElevatedButton の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 2. TextButton の直接使用チェック
echo -e "${YELLOW}📋 チェック2: TextButton の直接使用${NC}"
if grep -rn "TextButton(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${RED}❌ TextButton の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 3. IconButton の直接使用チェック（例外: AppBar内 actions:/leading: のコンテキスト）
echo -e "${YELLOW}📋 チェック3: IconButton の直接使用${NC}"
# awk でコンテキスト認識: IconButton( の直前3行に actions:/leading:/AppBar があれば除外
find "$TARGET_DIR" -name "*.dart" \
    ! -path "*/lib/component/button/*" \
    ! -path "*/lib/component/dialog/*" \
    ! -path "*/lib/component/snackbar/*" \
    ! -path "*/lib/gen/*" \
    -print0 2>/dev/null | \
xargs -0 awk '
  FNR == 1 { prev1 = ""; prev2 = ""; prev3 = "" }
  /IconButton\(/ {
    if ($0 !~ /tapIconButton|\/\/ IconButton|AppBar|leading:/ &&
        prev1 !~ /actions:|leading:|AppBar/ &&
        prev2 !~ /actions:|leading:|AppBar/ &&
        prev3 !~ /actions:|leading:|AppBar/) {
      print FILENAME ":" FNR ":" $0
    }
  }
  { prev3 = prev2; prev2 = prev1; prev1 = $0 }
' > "$TEMP_FILE" 2>/dev/null || true
if [ -s "$TEMP_FILE" ]; then
  echo -e "${RED}❌ IconButton の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 4. FloatingActionButton の直接使用チェック（flutter_foundation に代替なし → 警告のみ）
echo -e "${YELLOW}📋 チェック4: FloatingActionButton の直接使用（情報のみ）${NC}"
if grep -rn "FloatingActionButton(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${YELLOW}⚠️  FloatingActionButton の直接使用が見つかりました（flutter_foundation に代替コンポーネントなし）:${NC}"
  cat "$TEMP_FILE"
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 5. AlertDialog の直接使用チェック（例外: show_local_push_notification.dart）
echo -e "${YELLOW}📋 チェック5: AlertDialog の直接使用${NC}"
if grep -rn "AlertDialog(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  # show_local_push_notification.dartは除外（テスト用途）
  if grep -v "show_local_push_notification.dart" "$TEMP_FILE" > "${TEMP_FILE}.filtered"; then
    if [ -s "${TEMP_FILE}.filtered" ]; then
      echo -e "${RED}❌ AlertDialog の直接使用が見つかりました:${NC}"
      cat "${TEMP_FILE}.filtered"
      VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "${TEMP_FILE}.filtered")))
      echo ""
    else
      echo -e "${GREEN}✅ 違反なし（テスト用途のみ）${NC}"
      echo ""
    fi
  else
    echo -e "${GREEN}✅ 違反なし${NC}"
    echo ""
  fi
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 6. SimpleDialog の直接使用チェック
echo -e "${YELLOW}📋 チェック6: SimpleDialog の直接使用${NC}"
if grep -rn "SimpleDialog(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${RED}❌ SimpleDialog の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 7. Dialog の直接使用チェック（汎用Dialogウィジェット）
# 注意: メソッド名やコンポーネント名は除外し、実際のウィジェット使用のみ検出
echo -e "${YELLOW}📋 チェック7: Dialog の直接使用${NC}"
# return Dialog(やreturn AlertDialog(のような実際のウィジェット使用を検出
if grep -rn "return.*Dialog(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  # 既存のダイアログコンポーネント名を除外
  if grep -v "ActionDialog" "$TEMP_FILE" | \
     grep -v "TwoButtonDialog" | \
     grep -v "RatingDialog" | \
     grep -v "CalendarDialog" | \
     grep -v "show_local_push_notification.dart" > "${TEMP_FILE}.filtered"; then
    if [ -s "${TEMP_FILE}.filtered" ]; then
      echo -e "${RED}❌ Dialog の直接使用が見つかりました:${NC}"
      cat "${TEMP_FILE}.filtered"
      VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "${TEMP_FILE}.filtered")))
      echo ""
    else
      echo -e "${GREEN}✅ 違反なし${NC}"
      echo ""
    fi
  else
    echo -e "${GREEN}✅ 違反なし${NC}"
    echo ""
  fi
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 8. ScaffoldMessenger の直接使用チェック
echo -e "${YELLOW}📋 チェック8: ScaffoldMessenger.of(context).showSnackBar の直接使用${NC}"
if grep -rn "ScaffoldMessenger\.of(context)\.showSnackBar" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${RED}❌ ScaffoldMessenger の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 9. SnackBar の直接使用チェック
echo -e "${YELLOW}📋 チェック9: SnackBar の直接使用${NC}"
if grep -rn "SnackBar(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${RED}❌ SnackBar の直接使用が見つかりました:${NC}"
  cat "$TEMP_FILE"
  VIOLATION_COUNT=$((VIOLATION_COUNT + $(wc -l < "$TEMP_FILE")))
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 10. AppBar の直接使用チェック（例外: lib/component/header/内、BaseHeader非対応機能あり → 警告のみ）
echo -e "${YELLOW}📋 チェック10: AppBar の直接使用（情報のみ）${NC}"
APPBAR_EXCLUDE_DIRS="--exclude-dir=lib/component/header --exclude-dir=lib/gen"
if grep -rn "AppBar(" "$TARGET_DIR" $APPBAR_EXCLUDE_DIRS 2>/dev/null | grep -v "SliverAppBar(" > "$TEMP_FILE"; then
  echo -e "${YELLOW}⚠️  AppBar の直接使用が見つかりました（BaseHeader非対応機能のため警告のみ）:${NC}"
  cat "$TEMP_FILE"
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 11. SliverAppBar の直接使用チェック（BaseHeader にスリバーモードなし → 警告のみ）
echo -e "${YELLOW}📋 チェック11: SliverAppBar の直接使用（情報のみ）${NC}"
if grep -rn "SliverAppBar(" "$TARGET_DIR" $EXCLUDE_PATTERN 2>/dev/null > "$TEMP_FILE"; then
  echo -e "${YELLOW}⚠️  SliverAppBar の直接使用が見つかりました（BaseHeader にスリバーモードなし）:${NC}"
  cat "$TEMP_FILE"
  echo ""
else
  echo -e "${GREEN}✅ 違反なし${NC}"
  echo ""
fi

# 一時ファイルのクリーンアップ
rm -f "$TEMP_FILE" "${TEMP_FILE}.filtered"

# 結果サマリー
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $VIOLATION_COUNT -eq 0 ]; then
  echo -e "${GREEN}✅ チェック完了: 違反は見つかりませんでした${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 0
else
  echo -e "${RED}❌ チェック失敗: ${VIOLATION_COUNT} 件の違反が見つかりました${NC}"
  echo ""
  echo -e "${YELLOW}修正方法:${NC}"
  echo "  - ElevatedButton → PrimaryButton / SecondaryButton"
  echo "  - AlertDialog → ActionDialog / TwoButtonDialog"
  echo "  - ScaffoldMessenger.of(context).showSnackBar → SnackBarUtility.showSuccess/showError/showInfo"
  echo "  - AppBar / SliverAppBar → BaseHeader"
  echo ""
  echo -e "${YELLOW}詳細なルールは以下を参照:${NC}"
  echo "  .claude/docs/rules/project_rules.md"
  echo "  .claude/docs/rules/coding_rule.md"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 1
fi
