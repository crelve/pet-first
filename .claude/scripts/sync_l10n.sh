#!/bin/bash
# L10n Sync Script
# Adds missing keys from base file to all other localization files

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
echo -e "${BLUE}L10n Synchronization Script${NC}"
echo -e "${BLUE}==================================${NC}\n"

# Check if base file exists
if [ ! -f "$BASE_PATH" ]; then
    echo -e "${RED}Error: Base file $BASE_PATH not found${NC}"
    exit 1
fi

echo -e "${YELLOW}Base file: $BASE_FILE${NC}\n"

# Function to get value for a key from base file
get_key_value() {
    local key="$1"
    local value_line=$(grep -A 1000 "\"$key\":" "$BASE_PATH" | head -n 1)
    echo "$value_line"
}

# Function to get metadata for a key from base file
get_key_metadata() {
    local key="$1"
    local in_metadata=false
    local metadata=""
    local brace_count=0

    while IFS= read -r line; do
        if echo "$line" | grep -q "\"@$key\":"; then
            in_metadata=true
            metadata="$line"
            if echo "$line" | grep -q "{"; then
                brace_count=$((brace_count + 1))
            fi
            if echo "$line" | grep -q "}"; then
                brace_count=$((brace_count - 1))
            fi
            if [ $brace_count -eq 0 ]; then
                break
            fi
            continue
        fi

        if [ "$in_metadata" = true ]; then
            metadata="$metadata
$line"
            if echo "$line" | grep -q "{"; then
                brace_count=$((brace_count + 1))
            fi
            if echo "$line" | grep -q "}"; then
                brace_count=$((brace_count - 1))
            fi
            if [ $brace_count -eq 0 ]; then
                break
            fi
        fi
    done < "$BASE_PATH"

    echo "$metadata"
}

# Extract all keys from base file (excluding @-prefixed metadata keys)
BASE_KEYS=$(grep -E '^\s*"[^@].*":\s*' "$BASE_PATH" | sed -E 's/^\s*"([^"]+)":.*/\1/')

# Process each language file
for arb_file in "$L10N_DIR"/*.arb; do
    filename=$(basename "$arb_file")

    # Skip base file
    if [ "$filename" = "$BASE_FILE" ]; then
        continue
    fi

    echo -e "${YELLOW}Processing $filename...${NC}"

    # Extract keys from current file
    CURRENT_KEYS=$(grep -E '^\s*"[^@].*":\s*' "$arb_file" | sed -E 's/^\s*"([^"]+)":.*/\1/' || true)

    # Find missing keys
    MISSING_KEYS=$(comm -23 <(echo "$BASE_KEYS" | sort) <(echo "$CURRENT_KEYS" | sort))
    MISSING_COUNT=$(echo "$MISSING_KEYS" | grep -v '^$' | wc -l | tr -d ' ')

    if [ "$MISSING_COUNT" -gt 0 ]; then
        echo -e "${BLUE}  Adding $MISSING_COUNT missing keys...${NC}"

        # Create a temporary file
        temp_file=$(mktemp)

        # Read the file line by line and add missing keys before the closing brace
        found_closing=false
        while IFS= read -r line; do
            # Check if this is the last closing brace
            if echo "$line" | grep -q '^}$' && [ "$found_closing" = false ]; then
                found_closing=true

                # Add all missing keys
                echo "$MISSING_KEYS" | grep -v '^$' | while read -r key; do
                    # Add comma to previous line if needed
                    sed -i '' '$ s/$/,/' "$temp_file" 2>/dev/null || true

                    # Get key value and metadata from base file
                    key_value=$(get_key_value "$key")
                    key_metadata=$(get_key_metadata "$key")

                    # Add key and metadata
                    echo "  $key_value" >> "$temp_file"
                    if [ -n "$key_metadata" ]; then
                        echo "$key_metadata" | sed 's/^/  /' >> "$temp_file"
                    fi
                done

                # Remove trailing comma from last added key
                sed -i '' '$ s/,$//' "$temp_file" 2>/dev/null || true

                # Add the closing brace
                echo "$line" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$arb_file"

        # Replace original file
        mv "$temp_file" "$arb_file"

        echo -e "${GREEN}  ✅ Added $MISSING_COUNT keys to $filename${NC}"
    else
        echo -e "${GREEN}  ✅ No missing keys${NC}"
    fi
    echo ""
done

echo -e "${BLUE}==================================${NC}"
echo -e "${GREEN}✅ Synchronization completed!${NC}"
echo -e "${YELLOW}Note: The added keys have English values.${NC}"
echo -e "${YELLOW}Please translate them to the appropriate languages.${NC}"
