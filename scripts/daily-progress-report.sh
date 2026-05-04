#!/bin/bash

# 日次進捗レポート生成スクリプト
# GitHub Issues の状態から進捗を分析し、レポートを生成

set -e

# 設定
REPO_OWNER=${GITHUB_REPOSITORY_OWNER:-"$(gh repo view --json owner --jq .owner.login)"}
REPO_NAME=${GITHUB_REPOSITORY_NAME:-"$(gh repo view --json name --jq .name)"}
REPORT_FILE="daily_progress_$(date +%Y%m%d).md"

echo "📊 WeatherWear 日次進捗レポート生成"
echo "Repository: $REPO_OWNER/$REPO_NAME"
echo "レポートファイル: $REPORT_FILE"

# レポートファイル作成
cat > "$REPORT_FILE" << EOF
# WeatherWear 日次進捗レポート

**日付**: $(date '+%Y年%m月%d日 (%a)')  
**レポート生成時刻**: $(date '+%H:%M:%S')

## 📊 全体サマリー

EOF

# Issues の状態取得
echo "🔍 Issues 状態を取得中..."

# 全体統計
TOTAL_ISSUES=$(gh issue list --state all --json number | jq '. | length')
OPEN_ISSUES=$(gh issue list --state open --json number | jq '. | length')
CLOSED_ISSUES=$(gh issue list --state closed --json number | jq '. | length')

if [ "$TOTAL_ISSUES" -gt 0 ]; then
    COMPLETION_RATE=$(( CLOSED_ISSUES * 100 / TOTAL_ISSUES ))
else
    COMPLETION_RATE=0
fi

cat >> "$REPORT_FILE" << EOF
### 全体進捗
- **総Issues数**: $TOTAL_ISSUES
- **完了Issues**: $CLOSED_ISSUES
- **進行中Issues**: $OPEN_ISSUES
- **完了率**: $COMPLETION_RATE%

EOF

# フェーズ別進捗
echo "📈 フェーズ別進捗を分析中..."

for phase in "phase-1-setup" "phase-2-core" "phase-3-premium" "phase-4-polish"; do
    phase_total=$(gh issue list --state all --label "$phase" --json number | jq '. | length')
    phase_open=$(gh issue list --state open --label "$phase" --json number | jq '. | length')
    phase_closed=$(gh issue list --state closed --label "$phase" --json number | jq '. | length')
    
    if [ "$phase_total" -gt 0 ]; then
        phase_completion=$(( phase_closed * 100 / phase_total ))
    else
        phase_completion=0
    fi
    
    case $phase in
        "phase-1-setup") phase_name="Phase 1: セットアップ" ;;
        "phase-2-core") phase_name="Phase 2: Core機能" ;;
        "phase-3-premium") phase_name="Phase 3: Premium機能" ;;
        "phase-4-polish") phase_name="Phase 4: 最適化" ;;
    esac
    
    cat >> "$REPORT_FILE" << EOF
### $phase_name
- 総数: $phase_total | 完了: $phase_closed | 進行中: $phase_open | 完了率: $phase_completion%

EOF
done

# 要件別進捗
echo "🎯 要件別進捗を分析中..."

cat >> "$REPORT_FILE" << EOF
## 🎯 要件別進捗

EOF

for req in "F001" "F002" "F003" "F004" "F101" "F102" "F103"; do
    req_total=$(gh issue list --state all --label "$req" --json number | jq '. | length' 2>/dev/null || echo "0")
    req_open=$(gh issue list --state open --label "$req" --json number | jq '. | length' 2>/dev/null || echo "0")
    req_closed=$(gh issue list --state closed --label "$req" --json number | jq '. | length' 2>/dev/null || echo "0")
    
    if [ "$req_total" -gt 0 ]; then
        req_completion=$(( req_closed * 100 / req_total ))
        
        case $req in
            "F001") req_name="天気情報表示" ;;
            "F002") req_name="服装提案機能" ;;
            "F003") req_name="通知機能" ;;
            "F004") req_name="ユーザー設定" ;;
            "F101") req_name="詳細履歴・分析" ;;
            "F102") req_name="高度なカスタマイズ" ;;
            "F103") req_name="広告非表示" ;;
        esac
        
        cat >> "$REPORT_FILE" << EOF
### $req: $req_name
- 進捗: $req_closed/$req_total Issues完了 ($req_completion%)
- 状況: $([ "$req_completion" -eq 100 ] && echo "✅ 完了" || echo "🔄 進行中 ($req_open件)")

EOF
    fi
done

# 優先度別の未完了Issues
echo "⚠️ 優先度別未完了Issuesを確認中..."

cat >> "$REPORT_FILE" << EOF
## ⚠️ 優先度別 未完了Issues

EOF

for priority in "priority-critical" "priority-high" "priority-medium" "priority-low"; do
    case $priority in
        "priority-critical") priority_name="🔴 緊急" ;;
        "priority-high") priority_name="🟠 高" ;;
        "priority-medium") priority_name="🟡 中" ;;
        "priority-low") priority_name="🟢 低" ;;
    esac
    
    priority_open=$(gh issue list --state open --label "$priority" --json number,title | jq '. | length')
    
    if [ "$priority_open" -gt 0 ]; then
        cat >> "$REPORT_FILE" << EOF
### $priority_name ($priority_open件)

EOF
        
        gh issue list --state open --label "$priority" --json number,title | jq -r '.[] | "- #\(.number): \(.title)"' >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    fi
done

# 今日の活動
echo "📅 今日の活動を確認中..."

TODAY=$(date '+%Y-%m-%d')
TODAY_CLOSED=$(gh issue list --state closed --search "closed:$TODAY" --json number,title | jq '. | length')
TODAY_CREATED=$(gh issue list --state all --search "created:$TODAY" --json number,title | jq '. | length')

cat >> "$REPORT_FILE" << EOF
## 📅 今日の活動

- **作成されたIssues**: $TODAY_CREATED件
- **完了したIssues**: $TODAY_CLOSED件

EOF

if [ "$TODAY_CLOSED" -gt 0 ]; then
    cat >> "$REPORT_FILE" << EOF
### 今日完了したIssues

EOF
    gh issue list --state closed --search "closed:$TODAY" --json number,title | jq -r '.[] | "- ✅ #\(.number): \(.title)"' >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

if [ "$TODAY_CREATED" -gt 0 ]; then
    cat >> "$REPORT_FILE" << EOF
### 今日作成されたIssues

EOF
    gh issue list --state all --search "created:$TODAY" --json number,title | jq -r '.[] | "- 📝 #\(.number): \(.title)"' >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# リリースまでの見通し
echo "🚀 リリース見通しを分析中..."

# Core機能の完了状況から見積もり
CORE_TOTAL=$(gh issue list --state all --label "phase-2-core" --json number | jq '. | length')
CORE_COMPLETED=$(gh issue list --state closed --label "phase-2-core" --json number | jq '. | length')
CORE_REMAINING=$(( CORE_TOTAL - CORE_COMPLETED ))

# 簡易的な見積もり（1Issue = 0.5日と仮定）
if [ "$CORE_REMAINING" -gt 0 ]; then
    ESTIMATED_DAYS=$(( (CORE_REMAINING + 1) / 2 ))
else
    ESTIMATED_DAYS=0
fi

cat >> "$REPORT_FILE" << EOF
## 🚀 リリース見通し

### Core機能の状況
- Core機能Issues: $CORE_COMPLETED/$CORE_TOTAL 完了
- 残りCore機能: $CORE_REMAINING Issues
- 推定残り期間: 約$ESTIMATED_DAYS日 *(1Issue=0.5日として計算)*

### リリース判定
EOF

if [ "$CORE_COMPLETED" -eq "$CORE_TOTAL" ] && [ "$CORE_TOTAL" -gt 0 ]; then
    cat >> "$REPORT_FILE" << EOF
✅ **Core機能完了**: リリース準備に進むことができます

EOF
elif [ "$CORE_REMAINING" -le 2 ]; then
    cat >> "$REPORT_FILE" << EOF
🟡 **Core機能ほぼ完了**: あと$CORE_REMAINING Issues でリリース準備

EOF
else
    cat >> "$REPORT_FILE" << EOF
🔴 **Core機能開発中**: あと$CORE_REMAINING Issues の完了が必要

EOF
fi

# アクションアイテム
cat >> "$REPORT_FILE" << EOF
## 📝 明日のアクションアイテム

### 優先対応Issues
EOF

# 緊急・高優先度の未完了Issues
HIGH_PRIORITY_ISSUES=$(gh issue list --state open --label "priority-critical,priority-high" --json number,title | jq '. | length')

if [ "$HIGH_PRIORITY_ISSUES" -gt 0 ]; then
    gh issue list --state open --label "priority-critical,priority-high" --json number,title | jq -r '.[] | "- 🔥 #\(.number): \(.title)"' >> "$REPORT_FILE"
else
    echo "- ✅ 高優先度Issuesはすべて完了" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

### 推奨アクション
1. 上記の高優先度Issuesから着手
2. Core機能（F001-F004）の完了を最優先
3. ブロッカーがある場合は即座に解決
4. テストカバレッジとコード品質の維持

EOF

# 注意事項・リスク
cat >> "$REPORT_FILE" << EOF
## ⚠️ 注意事項・リスク

EOF

# ブロッカーIssuesの確認
BLOCKED_ISSUES=$(gh issue list --state open --label "blocked" --json number | jq '. | length' 2>/dev/null || echo "0")

if [ "$BLOCKED_ISSUES" -gt 0 ]; then
    cat >> "$REPORT_FILE" << EOF
### 🚧 ブロッカーIssues ($BLOCKED_ISSUES件)
- 他のIssuesの進行を妨げているIssuesがあります
- 最優先で解決が必要です

EOF
fi

# 遅延リスク
if [ "$CORE_REMAINING" -gt 4 ]; then
    cat >> "$REPORT_FILE" << EOF
### ⏰ 遅延リスク
- Core機能の残りIssues数が多く、リリース遅延のリスクがあります
- 優先度の見直しや、機能の簡素化を検討してください

EOF
fi

cat >> "$REPORT_FILE" << EOF

---
*このレポートは自動生成されました: $(date)*
EOF

echo "✅ 日次進捗レポート生成完了: $REPORT_FILE"
echo ""
echo "📋 レポートサマリー:"
echo "- 総Issues: $TOTAL_ISSUES (完了: $CLOSED_ISSUES, 完了率: $COMPLETION_RATE%)"
echo "- Core機能: $CORE_COMPLETED/$CORE_TOTAL 完了"
echo "- 高優先度未完了: $HIGH_PRIORITY_ISSUES件"
echo ""
echo "レポート確認: cat $REPORT_FILE"