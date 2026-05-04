#!/bin/bash
# =============================================================================
# validate-metadata.sh — App Store Connect メタデータバリデーション
# =============================================================================
# 使い方:
#   bash scripts/validate-metadata.sh          # 通常実行
#   bash scripts/validate-metadata.sh --ci     # CI用（エラー時 exit 1）
# =============================================================================

set -euo pipefail

METADATA_DIR="ios/fastlane/metadata"
ERRORS=0
WARNINGS=0
CI_MODE=false

[[ "${1:-}" == "--ci" ]] && CI_MODE=true

if [ ! -d "$METADATA_DIR" ]; then
  echo "❌ Metadata directory not found: $METADATA_DIR"
  exit 1
fi

error() { echo "  ❌ $1"; ERRORS=$((ERRORS + 1)); }
warn()  { echo "  ⚠️  $1"; WARNINGS=$((WARNINGS + 1)); }

# ASC character limits
check_length() {
  local file="$1" limit="$2" label="$3"
  [ -f "$file" ] || return 0
  local content
  content=$(cat "$file")
  local chars=${#content}
  # Subtract trailing newline
  [[ "$content" == *$'\n' ]] && chars=$((chars - 1))
  if [ "$chars" -gt "$limit" ]; then
    error "$label: ${chars}/${limit} chars OVER"
  fi
}

# Emoji check — characters ASC rejects in description/release_notes
check_emoji() {
  local file="$1" label="$2"
  [ -f "$file" ] || return 0
  local found
  found=$(grep -o '[✅❌⭐🎯💡🔥✨📱🏋💪⏱📊🔔🌙☀🧴🌿📸🪞💆🎉👍🙌❤⚡🚀🎨🎶🔒🆓🏆🌟💎🎁💬🤖🧠💰🩺🐾🌱🍳📚🏃‍♂️🧘‍♀️]' "$file" 2>/dev/null || true)
  if [ -n "$found" ]; then
    local unique
    unique=$(echo "$found" | sort -u | tr '\n' ' ')
    error "$label: prohibited emoji: $unique"
  fi
}

echo "🔍 Validating App Store Connect metadata..."
echo ""

for lang_dir in "$METADATA_DIR"/*/; do
  [ -d "$lang_dir" ] || continue
  lang=$(basename "$lang_dir")

  has_error=false

  # Character limits
  for pair in "name.txt:30" "subtitle.txt:30" "keywords.txt:100" "description.txt:4000" "release_notes.txt:4000" "promotional_text.txt:170"; do
    field="${pair%%:*}"
    limit="${pair##*:}"
    filepath="$lang_dir$field"
    if [ -f "$filepath" ]; then
      content=$(cat "$filepath")
      chars=${#content}
      [[ "$content" == *$'\n' ]] && chars=$((chars - 1))
      if [ "$chars" -gt "$limit" ]; then
        $has_error || { echo "--- $lang ---"; has_error=true; }
        error "$field: ${chars}/${limit} chars"
      fi
    fi
  done

  # Emoji in text fields
  for field in description.txt release_notes.txt promotional_text.txt; do
    filepath="$lang_dir$field"
    if [ -f "$filepath" ]; then
      found=$(grep -o '[✅❌⭐🎯💡🔥✨📱🏋💪⏱📊🔔🌙☀🧴🌿📸🪞💆🎉👍🙌❤⚡🚀🎨🎶🔒🆓🏆🌟💎🎁💬🤖🧠💰🩺🐾🌱🍳📚🏃🧘]' "$filepath" 2>/dev/null || true)
      if [ -n "$found" ]; then
        unique=$(echo "$found" | sort -u | tr '\n' ' ')
        $has_error || { echo "--- $lang ---"; has_error=true; }
        error "$field: prohibited emoji: $unique"
      fi
    fi
  done

  # Missing release_notes.txt
  if [ ! -f "$lang_dir/release_notes.txt" ]; then
    $has_error || { echo "--- $lang ---"; has_error=true; }
    warn "release_notes.txt missing"
  fi
done

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "💥 ${ERRORS} error(s), ${WARNINGS} warning(s)"
  $CI_MODE && exit 1
  exit 1
elif [ "$WARNINGS" -gt 0 ]; then
  echo "✅ No errors. ${WARNINGS} warning(s)"
  exit 0
else
  echo "✅ All metadata valid. No issues found."
  exit 0
fi
