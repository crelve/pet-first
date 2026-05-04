#!/usr/bin/env python3
"""
L10n Synchronization Script
Adds missing keys from base file to all other localization files
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Set

# Color codes
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'  # No Color

L10N_DIR = "lib/l10n"
BASE_FILE = "app_en.arb"


def load_arb_file(file_path: str) -> Dict:
    """Load ARB file and preserve key order"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_arb_file(file_path: str, data: Dict) -> None:
    """Save ARB file with pretty formatting"""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def get_translation_keys(data: Dict) -> Set[str]:
    """Get all translation keys (excluding metadata keys starting with @)"""
    return {key for key in data.keys() if not key.startswith('@') and key != '@@locale'}


def sync_file(base_data: Dict, target_file: str) -> int:
    """Sync target file with base file. Returns number of added keys."""
    # Load target file
    target_data = load_arb_file(target_file)

    # Get keys
    base_keys = get_translation_keys(base_data)
    target_keys = get_translation_keys(target_data)

    # Find missing keys
    missing_keys = base_keys - target_keys

    if not missing_keys:
        return 0

    # Create new ordered dict preserving @@locale at top
    new_data = {}
    if '@@locale' in target_data:
        new_data['@@locale'] = target_data['@@locale']

    # Add existing keys in the same order as base file
    for key in base_data.keys():
        if key == '@@locale':
            continue

        if key in target_data:
            # Use existing value
            new_data[key] = target_data[key]
        elif not key.startswith('@'):
            # Add missing translation key with English value
            new_data[key] = base_data[key]
            # Add metadata if exists
            metadata_key = f'@{key}'
            if metadata_key in base_data:
                new_data[metadata_key] = base_data[metadata_key]

    # Save the synced file
    save_arb_file(target_file, new_data)

    return len(missing_keys)


def main():
    print(f"{BLUE}=================================={NC}")
    print(f"{BLUE}L10n Synchronization Script{NC}")
    print(f"{BLUE}=================================={NC}\n")

    base_path = os.path.join(L10N_DIR, BASE_FILE)

    # Check if base file exists
    if not os.path.exists(base_path):
        print(f"{RED}Error: Base file {base_path} not found{NC}")
        sys.exit(1)

    print(f"{YELLOW}Base file: {BASE_FILE}{NC}\n")

    # Load base file
    base_data = load_arb_file(base_path)
    base_key_count = len(get_translation_keys(base_data))

    # Process each language file
    total_added = 0
    for arb_file in Path(L10N_DIR).glob("*.arb"):
        filename = arb_file.name

        # Skip base file
        if filename == BASE_FILE:
            continue

        print(f"{YELLOW}Processing {filename}...{NC}")

        # Sync file
        added_count = sync_file(base_data, str(arb_file))

        if added_count > 0:
            total_added += added_count
            print(f"{GREEN}  ✅ Added {added_count} keys to {filename}{NC}")
        else:
            print(f"{GREEN}  ✅ No missing keys{NC}")
        print()

    print(f"{BLUE}=================================={NC}")
    print(f"{GREEN}✅ Synchronization completed!{NC}")

    if total_added > 0:
        print(f"{YELLOW}Total keys added: {total_added}{NC}")
        print(f"{YELLOW}Note: The added keys have English values.{NC}")
        print(f"{YELLOW}Please translate them to the appropriate languages.{NC}")


if __name__ == "__main__":
    main()
