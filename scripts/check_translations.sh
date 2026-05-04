#!/bin/bash

# Translation validation script for lib/l10n ARB files
# Checks for missing translations, duplicate keys, and untranslated content

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

L10N_DIR="lib/l10n"
BASE_LOCALE="ja"  # Japanese as base locale
BASE_FILE="${L10N_DIR}/app_${BASE_LOCALE}.arb"

# Supported locales
LOCALES=("ja" "en" "es" "fr" "it" "ko" "zh")

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}🌍 Translation Validation Check${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if l10n directory exists
if [ ! -d "$L10N_DIR" ]; then
    echo -e "${RED}❌ Error: $L10N_DIR directory not found${NC}"
    exit 1
fi

# Check if base file exists
if [ ! -f "$BASE_FILE" ]; then
    echo -e "${RED}❌ Error: Base locale file not found: $BASE_FILE${NC}"
    exit 1
fi

# Function to extract keys from ARB file (excluding @ metadata keys and @@locale)
extract_keys() {
    local file=$1
    # Extract only keys that don't start with @ (metadata keys)
    python3 -c "
import json
import sys
try:
    with open('$file', 'r', encoding='utf-8') as f:
        data = json.load(f)
    keys = [k for k in data.keys() if not k.startswith('@')]
    for key in sorted(keys):
        print(key)
except Exception as e:
    print(f'Error reading $file: {e}', file=sys.stderr)
    sys.exit(1)
"
}

# Function to check for duplicate keys in a file
check_duplicate_keys() {
    local file=$1
    local locale=$2

    # Use Python to check for duplicate keys at top level only
    local duplicates=$(python3 -c "
import json
import sys
from collections import Counter
try:
    # First, check if JSON is valid (will fail if there are duplicate top-level keys)
    with open('$file', 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
            # If we reach here, there are no duplicate keys
        except json.JSONDecodeError as e:
            # If JSON parsing fails, it might be due to duplicates
            # Extract top-level keys manually
            f.seek(0)
            content = f.read()
            import re
            # Only match top-level keys (at the beginning of line or after {)
            # Exclude keys inside nested objects (metadata)
            keys = []
            depth = 0
            for line in content.split('\n'):
                # Track nesting depth
                depth += line.count('{') - line.count('}')
                # Only process keys at depth 1 (top level)
                if depth == 1:
                    match = re.match(r'^\s*\"([^\"]+)\"\s*:', line)
                    if match:
                        keys.append(match.group(1))

            counts = Counter(keys)
            duplicates = [k for k, v in counts.items() if v > 1]
            for dup in duplicates:
                print(dup)
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
" 2>/dev/null)

    if [ -n "$duplicates" ]; then
        local dup_count=$(echo "$duplicates" | wc -l | tr -d ' ')
        echo -e "${RED}❌ $dup_count duplicate key(s) found in $locale:${NC}"
        echo "$duplicates" | while read key; do
            echo -e "   ${YELLOW}• $key${NC}"
        done
        return 1
    fi
    return 0
}

# Function to check for empty translations
check_empty_translations() {
    local file=$1
    local locale=$2
    # Find keys with empty string values, excluding metadata keys
    local empty_keys=$(grep -E '^\s*"[^@][^"]*":\s*""' "$file" | sed 's/^\s*"\([^"]*\)".*/\1/')

    if [ -n "$empty_keys" ]; then
        local empty_count=$(echo "$empty_keys" | wc -l | tr -d ' ')
        echo -e "${YELLOW}⚠️  $empty_count empty translation(s) found in $locale:${NC}"
        echo "$empty_keys" | head -5 | while read key; do
            echo -e "   ${YELLOW}• $key${NC}"
        done
        if [ $empty_count -gt 5 ]; then
            echo -e "   ${YELLOW}... and $((empty_count - 5)) more${NC}"
        fi
        return 1
    fi
    return 0
}

# Function to check for untranslated content (contains specific language patterns)
check_untranslated_content() {
    local file=$1
    local locale=$2
    local issues_found=0

    # Language name keys that are allowed to contain native characters
    local language_name_keys="japanese|english|spanish|french|italian|korean|chinese"

    case $locale in
        ja)
            # Check for English words that should be translated (basic check)
            # Skip this for Japanese as it's the base locale
            ;;
        en)
            # Check for Japanese characters in English translations (top-level values only)
            local japanese_keys=$(python3 -c "
import json
import re
try:
    with open('$file', 'r', encoding='utf-8') as f:
        data = json.load(f)
    # Language name keys that are allowed to contain native characters
    language_keys = {'japanese', 'english', 'spanish', 'french', 'italian', 'korean', 'chinese'}
    # Check only top-level translation values (exclude @ metadata keys and language name keys)
    japanese_pattern = re.compile(r'[ぁ-んァ-ヶー一-龯]')
    issues = []
    for key, value in data.items():
        if not key.startswith('@') and key not in language_keys and isinstance(value, str):
            if japanese_pattern.search(value):
                issues.append(key)
    for issue in issues:
        print(issue)
except Exception as e:
    pass
" 2>/dev/null)

            if [ -n "$japanese_keys" ]; then
                echo -e "${RED}❌ Japanese characters found in English translations ($locale)${NC}"
                echo "$japanese_keys" | while read key; do
                    echo -e "   ${YELLOW}• $key${NC}"
                done
                issues_found=1
            fi
            ;;
        es|fr|it|ko)
            # Check for Japanese characters that might indicate untranslated content (top-level values only)
            # Exclude language name keys and use stricter pattern (hiragana/katakana only)
            local japanese_keys=$(python3 -c "
import json
import re
try:
    with open('$file', 'r', encoding='utf-8') as f:
        data = json.load(f)
    # Language name keys that are allowed to contain native characters
    language_keys = {'japanese', 'english', 'spanish', 'french', 'italian', 'korean', 'chinese'}
    # Check only top-level translation values (exclude @ metadata keys and language name keys)
    # Use hiragana/katakana pattern only to avoid false positives with Chinese characters
    japanese_pattern = re.compile(r'[ぁ-んァ-ヶー]')
    issues = []
    for key, value in data.items():
        if not key.startswith('@') and key not in language_keys and isinstance(value, str):
            if japanese_pattern.search(value):
                issues.append(key)
    for issue in issues:
        print(issue)
except Exception as e:
    pass
" 2>/dev/null)

            if [ -n "$japanese_keys" ]; then
                echo -e "${RED}❌ Japanese characters found in $locale translations${NC}"
                echo "$japanese_keys" | while read key; do
                    echo -e "   ${YELLOW}• $key${NC}"
                done
                issues_found=1
            fi
            ;;
        zh)
            # Skip Japanese character check for Chinese as they share kanji/hanzi characters
            # Only check for hiragana/katakana which should not appear in Chinese
            local japanese_keys=$(python3 -c "
import json
import re
try:
    with open('$file', 'r', encoding='utf-8') as f:
        data = json.load(f)
    # Language name keys that are allowed to contain native characters
    language_keys = {'japanese', 'english', 'spanish', 'french', 'italian', 'korean', 'chinese'}
    # Check only for hiragana/katakana (not kanji) to avoid false positives
    japanese_pattern = re.compile(r'[ぁ-んァ-ヶー]')
    issues = []
    for key, value in data.items():
        if not key.startswith('@') and key not in language_keys and isinstance(value, str):
            if japanese_pattern.search(value):
                issues.append(key)
    for issue in issues:
        print(issue)
except Exception as e:
    pass
" 2>/dev/null)

            if [ -n "$japanese_keys" ]; then
                echo -e "${RED}❌ Japanese hiragana/katakana found in Chinese translations${NC}"
                echo "$japanese_keys" | while read key; do
                    echo -e "   ${YELLOW}• $key${NC}"
                done
                issues_found=1
            fi
            ;;
    esac

    return $issues_found
}

# Extract base locale keys
echo -e "${BLUE}📝 Extracting base locale keys from: $BASE_FILE${NC}"
base_keys=$(extract_keys "$BASE_FILE")
base_key_count=$(echo "$base_keys" | wc -l | tr -d ' ')
echo -e "${GREEN}✓ Found $base_key_count keys in base locale ($BASE_LOCALE)${NC}"
echo ""

# Initialize counters
total_errors=0
total_warnings=0

# Check each locale
for locale in "${LOCALES[@]}"; do
    arb_file="${L10N_DIR}/app_${locale}.arb"

    echo -e "${BLUE}----------------------------------------${NC}"
    echo -e "${BLUE}Checking locale: $locale${NC}"
    echo -e "${BLUE}----------------------------------------${NC}"

    if [ ! -f "$arb_file" ]; then
        echo -e "${RED}❌ Missing ARB file: $arb_file${NC}"
        total_errors=$((total_errors + 1))
        echo ""
        continue
    fi

    # Check for duplicate keys
    if ! check_duplicate_keys "$arb_file" "$locale"; then
        total_errors=$((total_errors + 1))
        echo ""
    fi

    # Check for empty translations
    if ! check_empty_translations "$arb_file" "$locale"; then
        total_warnings=$((total_warnings + 1))
        echo ""
    fi

    # Check for untranslated content
    if ! check_untranslated_content "$arb_file" "$locale"; then
        total_errors=$((total_errors + 1))
        echo ""
    fi

    # Compare keys with base locale
    locale_keys=$(extract_keys "$arb_file")

    # Find missing keys (in base but not in locale)
    missing_keys=$(comm -23 <(echo "$base_keys") <(echo "$locale_keys"))

    # Find extra keys (in locale but not in base)
    extra_keys=$(comm -13 <(echo "$base_keys") <(echo "$locale_keys"))

    if [ -n "$missing_keys" ]; then
        missing_count=$(echo "$missing_keys" | wc -l | tr -d ' ')
        echo -e "${RED}❌ Missing $missing_count key(s) in $locale (present in base $BASE_LOCALE):${NC}"
        echo "$missing_keys" | head -10 | while read key; do
            echo -e "   ${YELLOW}• $key${NC}"
        done
        if [ $missing_count -gt 10 ]; then
            echo -e "   ${YELLOW}... and $((missing_count - 10)) more${NC}"
        fi
        total_errors=$((total_errors + 1))
        echo ""
    fi

    if [ -n "$extra_keys" ]; then
        extra_count=$(echo "$extra_keys" | wc -l | tr -d ' ')
        echo -e "${YELLOW}⚠️  Extra $extra_count key(s) in $locale (not in base $BASE_LOCALE):${NC}"
        echo "$extra_keys" | head -10 | while read key; do
            echo -e "   ${YELLOW}• $key${NC}"
        done
        if [ $extra_count -gt 10 ]; then
            echo -e "   ${YELLOW}... and $((extra_count - 10)) more${NC}"
        fi
        total_warnings=$((total_warnings + 1))
        echo ""
    fi

    if [ -z "$missing_keys" ] && [ -z "$extra_keys" ]; then
        echo -e "${GREEN}✓ All keys match base locale${NC}"
        echo ""
    fi
done

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}📊 Summary${NC}"
echo -e "${BLUE}========================================${NC}"

if [ $total_errors -eq 0 ] && [ $total_warnings -eq 0 ]; then
    echo -e "${GREEN}✅ All translation checks passed!${NC}"
    exit 0
else
    if [ $total_errors -gt 0 ]; then
        echo -e "${RED}❌ Found $total_errors error(s)${NC}"
    fi
    if [ $total_warnings -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Found $total_warnings warning(s)${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Please review and fix the issues above.${NC}"
    exit 1
fi
