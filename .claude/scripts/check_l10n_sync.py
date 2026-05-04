#!/usr/bin/env python3
"""
L10n Synchronization Check Script
Checks if all localization files have the same keys
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, Set

# Color codes
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'  # No Color

L10N_DIR = "lib/l10n"
BASE_FILE = "app_en.arb"


def load_arb_file(file_path: str) -> Dict:
    """Load ARB file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def get_translation_keys(data: Dict) -> Set[str]:
    """Get all translation keys (excluding metadata keys starting with @)"""
    return {key for key in data.keys() if not key.startswith('@') and key != '@@locale'}


def main():
    print(f"{BLUE}=================================={NC}")
    print(f"{BLUE}L10n Synchronization Check{NC}")
    print(f"{BLUE}=================================={NC}\n")

    base_path = os.path.join(L10N_DIR, BASE_FILE)

    # Check if base file exists
    if not os.path.exists(base_path):
        print(f"{RED}Error: Base file {base_path} not found{NC}")
        sys.exit(1)

    print(f"{YELLOW}Extracting keys from {BASE_FILE}...{NC}")

    # Load base file
    base_data = load_arb_file(base_path)
    base_keys = get_translation_keys(base_data)
    base_key_count = len(base_keys)

    print(f"{GREEN}Found {base_key_count} keys in {BASE_FILE}{NC}\n")

    # Check each language file
    all_synced = True
    missing_keys_summary = []

    for arb_file in sorted(Path(L10N_DIR).glob("*.arb")):
        filename = arb_file.name

        # Skip base file
        if filename == BASE_FILE:
            continue

        print(f"{YELLOW}Checking {filename}...{NC}")

        # Load current file
        current_data = load_arb_file(str(arb_file))
        current_keys = get_translation_keys(current_data)
        current_key_count = len(current_keys)

        # Find missing keys
        missing_keys = base_keys - current_keys
        missing_count = len(missing_keys)

        if missing_count > 0:
            all_synced = False
            print(f"{RED}  ❌ Missing {missing_count} keys{NC}")
            print(f"{BLUE}  Current: {current_key_count} keys | Expected: {base_key_count} keys{NC}")

            # Add to summary
            summary_item = {
                'filename': filename,
                'missing_count': missing_count,
                'missing_keys': sorted(list(missing_keys))[:20]  # Show first 20
            }
            missing_keys_summary.append(summary_item)
        else:
            print(f"{GREEN}  ✅ All keys present ({current_key_count} keys){NC}")

        print()

    print(f"{BLUE}=================================={NC}")

    if all_synced:
        print(f"{GREEN}✅ All localization files are synchronized!{NC}")
        sys.exit(0)
    else:
        print(f"{RED}❌ Some localization files are missing keys{NC}\n")
        print(f"{YELLOW}Missing Keys Summary:{NC}")

        for summary in missing_keys_summary:
            print(f"{summary['filename']}:")
            for key in summary['missing_keys']:
                print(f"  - {key}")
            if summary['missing_count'] > 20:
                print(f"  ... and {summary['missing_count'] - 20} more keys")
            print()

        print(f"{BLUE}Run 'make sync-l10n' to automatically add missing keys{NC}")
        sys.exit(1)


if __name__ == "__main__":
    main()
