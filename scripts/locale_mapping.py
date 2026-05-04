#!/usr/bin/env python3
"""
Locale code mapping between ARB files and App Store Connect.
Maps Flutter ARB locale codes (using underscores) to App Store Connect locale codes (using hyphens).
"""

# ARB locale code -> App Store Connect locale code
ARB_TO_APPSTORE = {
    "ar": "ar-SA",
    "ca": "ca",
    "cs": "cs",
    "da": "da",
    "de": "de-DE",
    "el": "el",
    "en": "en-US",
    "en_AU": "en-AU",
    "en_CA": "en-CA",
    "en_GB": "en-GB",
    "es": "es-ES",
    "es_MX": "es-MX",
    "fi": "fi",
    "fr": "fr-FR",
    "fr_CA": "fr-CA",
    "he": "he",
    "hi": "hi",
    "hr": "hr",
    "hu": "hu",
    "id": "id",
    "it": "it",
    "ja": "ja",
    "ko": "ko",
    "ms": "ms",
    "nl": "nl-NL",
    "no": "no",
    "pl": "pl",
    "pt": "pt-BR",
    "pt_PT": "pt-PT",
    "ro": "ro",
    "ru": "ru",
    "sk": "sk",
    "sv": "sv",
    "th": "th",
    "tr": "tr",
    "uk": "uk",
    "vi": "vi",
    "zh": "zh-Hans",
    "zh_Hant": "zh-Hant",
}

# App Store Connect locale code -> ARB locale code (reverse mapping)
APPSTORE_TO_ARB = {v: k for k, v in ARB_TO_APPSTORE.items()}


def arb_to_appstore(arb_code: str) -> str:
    """
    Convert ARB locale code to App Store Connect locale code.

    Args:
        arb_code: ARB locale code (e.g., "en", "en_US", "zh")

    Returns:
        App Store Connect locale code (e.g., "en-US", "en-US", "zh-Hans")
    """
    return ARB_TO_APPSTORE.get(arb_code, arb_code.replace("_", "-"))


def appstore_to_arb(appstore_code: str) -> str:
    """
    Convert App Store Connect locale code to ARB locale code.

    Args:
        appstore_code: App Store Connect locale code (e.g., "en-US", "zh-Hans")

    Returns:
        ARB locale code (e.g., "en_US", "zh")
    """
    return APPSTORE_TO_ARB.get(appstore_code, appstore_code.replace("-", "_"))


def get_all_arb_locales():
    """Get all ARB locale codes."""
    return list(ARB_TO_APPSTORE.keys())


def get_all_appstore_locales():
    """Get all App Store Connect locale codes."""
    return list(ARB_TO_APPSTORE.values())


def convert_screenshot_directories(screenshots_dir: str) -> int:
    """
    Convert screenshot directory names from ARB to App Store Connect format.

    Args:
        screenshots_dir: Path to screenshots directory

    Returns:
        Number of directories converted
    """
    import os
    import shutil

    if not os.path.isdir(screenshots_dir):
        print(f"❌ Error: screenshots directory not found: {screenshots_dir}")
        return 0

    print("🔄 Converting screenshot directory names from ARB to App Store Connect format...")

    converted_count = 0

    for arb_code, appstore_code in ARB_TO_APPSTORE.items():
        if arb_code == appstore_code:
            continue  # No conversion needed

        src_dir = os.path.join(screenshots_dir, arb_code)
        dest_dir = os.path.join(screenshots_dir, appstore_code)

        if os.path.isdir(src_dir):
            if os.path.isdir(dest_dir):
                print(f"⚠️  Warning: {appstore_code} already exists, skipping...")
                continue

            shutil.move(src_dir, dest_dir)
            print(f"✅ Converted: {arb_code} → {appstore_code}")
            converted_count += 1

    if converted_count == 0:
        print("ℹ️  No directories to convert (all already in App Store Connect format)")
    else:
        print(f"🎉 Converted {converted_count} directories")

    print("\n📁 Current screenshot directories:")
    try:
        dirs = [d for d in os.listdir(screenshots_dir) if os.path.isdir(os.path.join(screenshots_dir, d)) and not d.startswith('.')]
        for d in sorted(dirs):
            print(f"  - {d}")
    except Exception as e:
        print(f"  Error listing directories: {e}")

    return converted_count


if __name__ == "__main__":
    import sys
    import os

    if len(sys.argv) < 2:
        print("Usage:")
        print("  python locale_mapping.py <arb_code>         # Convert ARB to App Store")
        print("  python locale_mapping.py --reverse <asc_code> # Convert App Store to ARB")
        print("  python locale_mapping.py --list-arb         # List all ARB codes")
        print("  python locale_mapping.py --list-appstore    # List all App Store codes")
        print("  python locale_mapping.py --convert-dirs <screenshots_dir> # Convert directory names")
        sys.exit(1)

    if sys.argv[1] == "--list-arb":
        for code in get_all_arb_locales():
            print(code)
    elif sys.argv[1] == "--list-appstore":
        for code in get_all_appstore_locales():
            print(code)
    elif sys.argv[1] == "--reverse":
        if len(sys.argv) < 3:
            print("Error: App Store code required")
            sys.exit(1)
        print(appstore_to_arb(sys.argv[2]))
    elif sys.argv[1] == "--convert-dirs":
        if len(sys.argv) < 3:
            print("Error: Screenshots directory path required")
            sys.exit(1)
        screenshots_dir = sys.argv[2]
        count = convert_screenshot_directories(screenshots_dir)
        sys.exit(0 if count >= 0 else 1)
    else:
        print(arb_to_appstore(sys.argv[1]))
