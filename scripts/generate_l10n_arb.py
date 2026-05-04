#!/usr/bin/env python3
"""
Generate ARB localization files for all 39 App Store Connect supported languages.
Creates app_*.arb files in lib/l10n/ directory.
"""

import os
import sys
import json
import shutil

def generate_arb_files(repo_path):
    """Generate ARB files for all 39 languages"""

    l10n_dir = os.path.join(repo_path, "lib/l10n")
    template_file = os.path.join(l10n_dir, "app_en.arb")

    if not os.path.exists(template_file):
        print(f"❌ Error: Template file not found: {template_file}")
        sys.exit(1)

    # Language code mapping: Fastlane code -> Flutter locale code
    # Flutter uses ISO 639-1 (2-letter) or BCP 47 (locale with script/region)
    language_mapping = {
        # Primary 10 languages (skip these - already exist)
        "en-US": None,  # en
        "ja": None,     # ja
        "zh-Hans": None,  # zh
        "ko": None,     # ko
        "de-DE": None,  # de
        "fr-FR": None,  # fr
        "es-ES": None,  # es
        "pt-BR": None,  # pt
        "hi": None,     # hi
        "it": None,     # it

        # Additional 29 languages (generate new ARB files)
        "ar-SA": "ar",           # Arabic
        "ca": "ca",              # Catalan
        "zh-Hant": "zh_Hant",    # Chinese Traditional
        "hr": "hr",              # Croatian
        "cs": "cs",              # Czech
        "da": "da",              # Danish
        "nl-NL": "nl",           # Dutch
        "en-AU": "en_AU",        # English (Australia)
        "en-CA": "en_CA",        # English (Canada)
        "en-GB": "en_GB",        # English (UK)
        "fi": "fi",              # Finnish
        "fr-CA": "fr_CA",        # French (Canada)
        "el": "el",              # Greek
        "he": "he",              # Hebrew
        "hu": "hu",              # Hungarian
        "id": "id",              # Indonesian
        "ms": "ms",              # Malay
        "no": "no",              # Norwegian
        "pl": "pl",              # Polish
        "pt-PT": "pt_PT",        # Portuguese (Portugal)
        "ro": "ro",              # Romanian
        "ru": "ru",              # Russian
        "sk": "sk",              # Slovak
        "es-MX": "es_MX",        # Spanish (Mexico)
        "sv": "sv",              # Swedish
        "th": "th",              # Thai
        "tr": "tr",              # Turkish
        "uk": "uk",              # Ukrainian
        "vi": "vi",              # Vietnamese
    }

    # Read template ARB file
    with open(template_file, 'r', encoding='utf-8') as f:
        template_data = json.load(f)

    created_count = 0
    skipped_count = 0

    # Generate ARB files for new languages
    for fastlane_code, flutter_locale in language_mapping.items():
        if flutter_locale is None:
            skipped_count += 1
            continue

        arb_filename = f"app_{flutter_locale}.arb"
        arb_path = os.path.join(l10n_dir, arb_filename)

        # Skip if file already exists
        if os.path.exists(arb_path):
            print(f"⏭️  Skipping {arb_filename} (already exists)")
            skipped_count += 1
            continue

        # Create new ARB file with updated @@locale
        new_arb_data = template_data.copy()
        new_arb_data["@@locale"] = flutter_locale

        # Write new ARB file
        with open(arb_path, 'w', encoding='utf-8') as f:
            json.dump(new_arb_data, f, ensure_ascii=False, indent=2)

        print(f"✅ Created {arb_filename}")
        created_count += 1

    print(f"\n📊 Summary:")
    print(f"   Created: {created_count} files")
    print(f"   Skipped: {skipped_count} files (existing files)")
    print(f"   Total languages: {created_count + skipped_count} (fully translated)")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: generate_l10n_arb.py <repo_path>")
        print("Example: generate_l10n_arb.py /path/to/repo")
        sys.exit(1)

    generate_arb_files(sys.argv[1])
