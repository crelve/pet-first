#!/bin/bash
# L10n Sync Check Script
# Checks if all localization files have the same keys

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

L10N_DIR="lib/l10n"
BASE_FILE="app_en.arb"
BASE_PATH="$L10N_DIR/$BASE_FILE"

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}L10n Synchronization Check${NC}"
echo -e "${BLUE}==================================${NC}\n"

# Check if base file exists
if [ ! -f "$BASE_PATH" ]; then
    echo -e "${RED}Error: Base file $BASE_PATH not found${NC}"
    exit 1
fi

# Extract all keys from base file (excluding @-prefixed metadata keys and @@locale)
echo -e "${YELLOW}Extracting keys from $BASE_FILE...${NC}"
BASE_KEYS=$(grep -E '^\s*"[^@].*":\s*' "$BASE_PATH" | sed -E 's/^\s*"([^"]+)":.*/\1/' | grep -v '@@locale' | sort)
BASE_KEY_COUNT=$(echo "$BASE_KEYS" | wc -l | tr -d ' ')

echo -e "${GREEN}Found $BASE_KEY_COUNT keys in $BASE_FILE${NC}\n"

# Check each language file
ALL_SYNCED=true
MISSING_KEYS_SUMMARY=""

for arb_file in "$L10N_DIR"/*.arb; do
    filename=$(basename "$arb_file")

    # Skip base file
    if [ "$filename" = "$BASE_FILE" ]; then
        continue
    fi

    echo -e "${YELLOW}Checking $filename...${NC}"

    # Extract keys from current file (excluding @-prefixed metadata keys and @@locale)
    CURRENT_KEYS=$(grep -E '^\s*"[^@].*":\s*' "$arb_file" | sed -E 's/^\s*"([^"]+)":.*/\1/' | grep -v '@@locale' | sort)
    CURRENT_KEY_COUNT=$(echo "$CURRENT_KEYS" | wc -l | tr -d ' ')

    # Find missing keys
    MISSING_KEYS=$(comm -23 <(echo "$BASE_KEYS") <(echo "$CURRENT_KEYS"))
    MISSING_COUNT=$(echo "$MISSING_KEYS" | grep -v '^$' | wc -l | tr -d ' ')

    if [ "$MISSING_COUNT" -gt 0 ]; then
        ALL_SYNCED=false
        echo -e "${RED}  ❌ Missing $MISSING_COUNT keys${NC}"
        echo -e "${BLUE}  Current: $CURRENT_KEY_COUNT keys | Expected: $BASE_KEY_COUNT keys${NC}"

        # Add to summary
        MISSING_KEYS_SUMMARY+="$filename:\n"
        MISSING_KEYS_LIST=$(echo "$MISSING_KEYS" | grep -v '^$' | head -20)
        while IFS= read -r key; do
            MISSING_KEYS_SUMMARY+="  - $key\n"
        done <<< "$MISSING_KEYS_LIST"
        if [ "$MISSING_COUNT" -gt 20 ]; then
            MISSING_KEYS_SUMMARY+="  ... and $((MISSING_COUNT - 20)) more keys\n"
        fi
        MISSING_KEYS_SUMMARY+="\n"
    else
        echo -e "${GREEN}  ✅ All keys present ($CURRENT_KEY_COUNT keys)${NC}"
    fi
    echo ""
done

echo -e "${BLUE}==================================${NC}"

if [ "$ALL_SYNCED" = true ]; then
    echo -e "${GREEN}✅ All localization files are synchronized!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some localization files are missing keys${NC}\n"
    echo -e "${YELLOW}Missing Keys Summary:${NC}"
    echo -e "$MISSING_KEYS_SUMMARY"
    echo -e "${BLUE}Run 'make sync-l10n' to automatically add missing keys${NC}"
    exit 1
fi
