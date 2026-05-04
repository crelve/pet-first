#!/usr/bin/env python3
"""
Sync ARB file keys across all locales
Adds missing keys from template (app_en.arb) to all other ARB files with translation
"""

import os
import sys
import json
import time

try:
    import google.generativeai as genai
except ImportError:
    print("Error: google-generativeai not installed")
    sys.exit(1)

LANGUAGE_NAMES = {
    "ar": "Arabic",
    "ca": "Catalan",
    "cs": "Czech",
    "da": "Danish",
    "de": "German",
    "el": "Greek",
    "en": "English",
    "en_AU": "English (Australia)",
    "en_CA": "English (Canada)",
    "en_GB": "English (United Kingdom)",
    "es": "Spanish",
    "es_MX": "Spanish (Mexico)",
    "fi": "Finnish",
    "fr": "French",
    "fr_CA": "French (Canada)",
    "he": "Hebrew",
    "hi": "Hindi",
    "hr": "Croatian",
    "hu": "Hungarian",
    "id": "Indonesian",
    "it": "Italian",
    "ja": "Japanese",
    "ko": "Korean",
    "ms": "Malay",
    "nl": "Dutch",
    "no": "Norwegian",
    "pl": "Polish",
    "pt": "Portuguese (Brazil)",
    "pt_PT": "Portuguese (Portugal)",
    "ro": "Romanian",
    "ru": "Russian",
    "sk": "Slovak",
    "sv": "Swedish",
    "th": "Thai",
    "tr": "Turkish",
    "uk": "Ukrainian",
    "vi": "Vietnamese",
    "zh": "Chinese (Simplified)",
    "zh_Hant": "Chinese (Traditional)",
}

def translate_text(text, target_lang, api_key):
    """Translate text using Gemini API"""
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-2.0-flash-exp')

    prompt = f"""Translate this app UI text to {target_lang}.
Keep it concise and natural for mobile app UI.
Do not add explanations or extra text, just return the translation.

Text to translate:
{text}

Translation:"""

    try:
        response = model.generate_content(prompt)
        return response.text.strip()
    except Exception as e:
        print(f"  ⚠️  Translation error: {e}")
        # Return English as fallback
        return text

def sync_arb_file(template_data, locale_code, api_key):
    """Sync a single ARB file with template"""
    locale_file = f"lib/l10n/app_{locale_code}.arb"

    # Load existing locale data
    if os.path.exists(locale_file):
        with open(locale_file, 'r', encoding='utf-8') as f:
            locale_data = json.load(f)
    else:
        locale_data = {"@@locale": locale_code}

    # Get template keys (excluding metadata)
    template_keys = [k for k in template_data.keys() if not k.startswith('@')]

    # Get locale keys (excluding metadata)
    locale_keys = set(k for k in locale_data.keys() if not k.startswith('@'))

    # Find missing keys
    missing_keys = [k for k in template_keys if k not in locale_keys]

    if not missing_keys:
        print(f"✅ {locale_code}: No missing keys")
        return 0

    lang_name = LANGUAGE_NAMES.get(locale_code, locale_code)
    print(f"📝 {locale_code} ({lang_name}): {len(missing_keys)} missing keys")

    # Add missing keys with translation
    for i, key in enumerate(missing_keys, 1):
        english_text = template_data[key]

        # Skip if locale is English
        if locale_code.startswith('en'):
            translated_text = english_text
        else:
            print(f"  [{i}/{len(missing_keys)}] Translating '{key}'...")
            translated_text = translate_text(english_text, lang_name, api_key)
            time.sleep(1)  # Rate limiting

        # Add translated key
        locale_data[key] = translated_text

        # Add metadata if present in template
        metadata_key = f"@{key}"
        if metadata_key in template_data:
            locale_data[metadata_key] = template_data[metadata_key]

    # Ensure @@locale is set
    locale_data["@@locale"] = locale_code

    # Save updated file (preserve order by reconstructing)
    # Order: @@locale, then regular keys in template order, then metadata
    ordered_data = {}
    ordered_data["@@locale"] = locale_code

    # Add all keys in template order
    for key in template_keys:
        if key in locale_data:
            ordered_data[key] = locale_data[key]

    # Add metadata for all keys
    for key in template_keys:
        metadata_key = f"@{key}"
        if metadata_key in locale_data:
            ordered_data[metadata_key] = locale_data[metadata_key]

    # Write to file
    with open(locale_file, 'w', encoding='utf-8') as f:
        json.dump(ordered_data, f, ensure_ascii=False, indent=2)

    print(f"✅ {locale_code}: Added {len(missing_keys)} keys\n")
    return len(missing_keys)

def main():
    if len(sys.argv) < 2:
        print("Usage: sync_arb_keys.py <GEMINI_API_KEY>")
        sys.exit(1)

    api_key = sys.argv[1]
    template_file = "lib/l10n/app_en.arb"

    # Load template
    with open(template_file, 'r', encoding='utf-8') as f:
        template_data = json.load(f)

    template_keys = [k for k in template_data.keys() if not k.startswith('@')]
    print(f"📋 Template (app_en.arb) has {len(template_keys)} keys\n")

    # Process all locales
    locales_to_process = [
        "ar", "ca", "cs", "da", "el", "he", "hr", "hu", "id", "ms",
        "nl", "no", "pl", "ro", "ru", "sk", "sv", "th", "tr", "uk", "vi",
        "en_AU", "en_CA", "en_GB", "es_MX", "fr_CA", "pt_PT", "zh_Hant",
    ]

    total_added = 0

    for locale in locales_to_process:
        added = sync_arb_file(template_data, locale, api_key)
        total_added += added

    print(f"\n🎉 Sync completed!")
    print(f"   Total keys added: {total_added}")

if __name__ == "__main__":
    main()
