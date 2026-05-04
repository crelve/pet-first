#!/bin/bash

# WeatherWear Issues Status Report Script
# 現在のGitHub Issues状況を詳細に分析・表示

set -e

# カラーコード定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 絵文字定義
CHECK="✅"
PROGRESS="🔄" 
PENDING="⭕"
WARN="⚠️"
ERROR="🔴"
INFO="📊"
ROCKET="🚀"

echo -e "${WHITE}${INFO} WeatherWear Issues 状況レポート${NC}"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Repository: $(gh repo view --json owner,name --jq '.owner.login + "/" + .name')"
echo "Branch: $(git branch --show-current)"
echo ""

# 1. 全体進捗サマリー
echo -e "${WHITE}📈 全体進捗サマリー${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOTAL_ISSUES=$(gh issue list --state all --json number --jq 'length')
OPEN_ISSUES=$(gh issue list --state open --json number --jq 'length')
CLOSED_ISSUES=$(gh issue list --state closed --json number --jq 'length')

if [ "$TOTAL_ISSUES" -gt 0 ]; then
    COMPLETION_RATE=$((CLOSED_ISSUES * 100 / TOTAL_ISSUES))
else
    COMPLETION_RATE=0
fi

echo -e "総Issues数: ${WHITE}$TOTAL_ISSUES${NC}"
echo -e "完了Issues: ${GREEN}$CLOSED_ISSUES${NC}"
echo -e "未完了Issues: ${YELLOW}$OPEN_ISSUES${NC}"
echo -e "完了率: ${GREEN}${COMPLETION_RATE}%${NC}"
echo ""

# 2. フェーズ別進捗
echo -e "${WHITE}🎯 フェーズ別進捗${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Core機能のIssues分析
analyze_feature_progress() {
    local feature_id=$1
    local feature_name=$2
    
    local total=$(gh issue list --state all --label "$feature_id" --json number --jq 'length')
    local closed=$(gh issue list --state closed --label "$feature_id" --json number --jq 'length')
    
    if [ "$total" -gt 0 ]; then
        local rate=$((closed * 100 / total))
        if [ "$rate" -eq 100 ]; then
            echo -e "${CHECK} ${GREEN}$feature_name (${rate}%) - 完了${NC}"
        elif [ "$rate" -gt 0 ]; then
            echo -e "${PROGRESS} ${YELLOW}$feature_name (${rate}%) - 進行中${NC}"
        else
            echo -e "${PENDING} ${RED}$feature_name (${rate}%) - 未着手${NC}"
        fi
        echo "    Total: $total issues, Closed: $closed"
    else
        echo -e "${PENDING} ${RED}$feature_name (0%) - Issues未作成${NC}"
    fi
}

echo "Core機能 (Phase 2):"
analyze_feature_progress "F001" "天気情報表示機能"
analyze_feature_progress "F002" "服装提案機能"
analyze_feature_progress "F003" "通知機能"
analyze_feature_progress "F004" "ユーザー設定機能"
echo ""

# 3. 優先度別Issues
echo -e "${WHITE}⚡ 優先度別未完了Issues${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HIGH_PRIORITY=$(gh issue list --state open --label "high-priority" --json number,title --jq 'length')
if [ "$HIGH_PRIORITY" -gt 0 ]; then
    echo -e "${ERROR} 高優先度 ($HIGH_PRIORITY issues):"
    gh issue list --state open --label "high-priority" --json number,title --jq '.[] | "  #" + (.number|tostring) + " " + .title'
else
    echo -e "${GREEN}高優先度Issues: なし${NC}"
fi

FEATURE_ISSUES=$(gh issue list --state open --label "feature" --json number,title --jq 'length')
if [ "$FEATURE_ISSUES" -gt 0 ]; then
    echo -e "${WARN} 機能実装 ($FEATURE_ISSUES issues):"
    gh issue list --state open --label "feature" --json number,title --jq '.[] | "  #" + (.number|tostring) + " " + .title' | head -5
    if [ "$FEATURE_ISSUES" -gt 5 ]; then
        echo "  ... and $((FEATURE_ISSUES - 5)) more"
    fi
else
    echo -e "${GREEN}機能実装Issues: なし${NC}"
fi
echo ""

# 4. Recent Activity
echo -e "${WHITE}📅 最近の活動${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get all issues and count recent ones
ALL_ISSUES=$(gh issue list --state all --json number,createdAt,updatedAt --jq 'length')
echo -e "全Issues: ${CYAN}$ALL_ISSUES${NC}"

# Show latest created issues
echo -e "\n最新作成Issues (Top 3):"
gh issue list --state all --json number,title,createdAt,state --jq 'sort_by(.createdAt) | reverse | .[:3] | .[] | "  #" + (.number|tostring) + " " + .title + " (" + .state + ")"'

# Show latest updated issues  
echo -e "\n最新更新Issues (Top 3):"
gh issue list --state all --json number,title,updatedAt,state --jq 'sort_by(.updatedAt) | reverse | .[:3] | .[] | "  #" + (.number|tostring) + " " + .title + " (" + .state + ")"'
echo ""

# 5. Pull Requests Status
echo -e "${WHITE}🔀 Pull Requests 状況${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

OPEN_PRS=$(gh pr list --state open --json number --jq 'length')
MERGED_PRS=$(gh pr list --state merged --json number --jq 'length')

echo -e "オープンPR: ${YELLOW}$OPEN_PRS${NC}"
echo -e "マージ済みPR: ${GREEN}$MERGED_PRS${NC}"

if [ "$OPEN_PRS" -gt 0 ]; then
    echo -e "\nオープン中のPR:"
    gh pr list --state open --json number,title,author --jq '.[] | "  #" + (.number|tostring) + " " + .title + " (@" + .author.login + ")"'
fi
echo ""

# 6. Next Actions Recommendation
echo -e "${WHITE}${ROCKET} 推奨アクション${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$HIGH_PRIORITY" -gt 0 ]; then
    echo -e "${ERROR} 1. 高優先度Issuesの対応を優先してください"
fi

if [ "$OPEN_ISSUES" -gt 0 ]; then
    # 最も古い未完了Issueを特定
    OLDEST_ISSUE=$(gh issue list --state open --json number,title,createdAt --jq 'sort_by(.createdAt) | .[0] | "#" + (.number|tostring) + " " + .title')
    echo -e "${WARN} 2. 最古の未完了Issue: ${OLDEST_ISSUE}"
fi

# F001から始まる推奨順序
F001_OPEN=$(gh issue list --state open --label "F001" --json number --jq 'length')
if [ "$F001_OPEN" -gt 0 ]; then
    echo -e "${INFO} 3. F001(天気情報)から実装開始を推奨"
    gh issue list --state open --label "F001" --json number,title --jq '.[] | "     #" + (.number|tostring) + " " + .title' | head -2
fi

echo -e "${GREEN} 4. 実装完了後は必ずPRを作成してレビューを受けてください"
echo -e "${GREEN} 5. Issue完了後は関連テストも実行してください"
echo ""

# 7. Development Commands
echo -e "${WHITE}🛠️  開発用コマンド${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "# 実装開始前の確認"
echo "make clean && make setup"
echo "fvm flutter pub get"
echo ""
echo "# 開発中のテスト実行"
echo "make test"
echo "fvm flutter analyze"
echo ""
echo "# 実装完了後"
echo "gh pr create --draft # または"
echo "gh pr create --title \"feat: implement <feature>\" --body \"Closes #<issue_number>\""
echo ""

# 8. Requirements Compliance Check
echo -e "${WHITE}📋 要件定義準拠チェック${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -f "docs/project/requirements.md" ]; then
    echo -e "${GREEN}${CHECK} 要件定義書: 存在${NC} (docs/project/requirements.md)"
else
    echo -e "${ERROR}${ERROR} 要件定義書: 不在${NC}"
fi

if [ -f "docs/project/app_concept.md" ]; then
    echo -e "${GREEN}${CHECK} アプリコンセプト: 存在${NC} (docs/project/app_concept.md)"
else
    echo -e "${ERROR}${ERROR} アプリコンセプト: 不在${NC}"
fi

# Firebase設定チェック
if [ -f "dart_env/dev.env" ] && [ -f "dart_env/prod.env" ]; then
    echo -e "${GREEN}${CHECK} 環境設定: 完了${NC} (dev.env, prod.env)"
else
    echo -e "${WARN}${WARN} 環境設定: 要確認${NC} (dart_env/)"
fi

echo ""
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${WHITE}レポート完了 - Happy Coding! ${ROCKET}${NC}"