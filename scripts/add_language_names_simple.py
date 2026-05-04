#!/usr/bin/env python3
"""
全ARBファイルに29言語の表示名を追加するスクリプト (シンプル版)
"""
import os
import re

# 追加する言語名エントリ（app_en.arbから抜粋）
LANGUAGE_ENTRIES = '''  "arabic": "Arabic",
  "@arabic": {
    "description": "Arabic language option"
  },
  "catalan": "Catalan",
  "@catalan": {
    "description": "Catalan language option"
  },
  "chineseTraditional": "Chinese (Traditional)",
  "@chineseTraditional": {
    "description": "Chinese Traditional language option"
  },
  "croatian": "Croatian",
  "@croatian": {
    "description": "Croatian language option"
  },
  "czech": "Czech",
  "@czech": {
    "description": "Czech language option"
  },
  "danish": "Danish",
  "@danish": {
    "description": "Danish language option"
  },
  "dutch": "Dutch",
  "@dutch": {
    "description": "Dutch language option"
  },
  "englishAustralia": "English (Australia)",
  "@englishAustralia": {
    "description": "English Australia language option"
  },
  "englishCanada": "English (Canada)",
  "@englishCanada": {
    "description": "English Canada language option"
  },
  "englishUK": "English (UK)",
  "@englishUK": {
    "description": "English UK language option"
  },
  "finnish": "Finnish",
  "@finnish": {
    "description": "Finnish language option"
  },
  "frenchCanada": "French (Canada)",
  "@frenchCanada": {
    "description": "French Canada language option"
  },
  "greek": "Greek",
  "@greek": {
    "description": "Greek language option"
  },
  "hebrew": "Hebrew",
  "@hebrew": {
    "description": "Hebrew language option"
  },
  "hungarian": "Hungarian",
  "@hungarian": {
    "description": "Hungarian language option"
  },
  "indonesian": "Indonesian",
  "@indonesian": {
    "description": "Indonesian language option"
  },
  "malay": "Malay",
  "@malay": {
    "description": "Malay language option"
  },
  "norwegian": "Norwegian",
  "@norwegian": {
    "description": "Norwegian language option"
  },
  "polish": "Polish",
  "@polish": {
    "description": "Polish language option"
  },
  "portuguesePortugal": "Portuguese (Portugal)",
  "@portuguesePortugal": {
    "description": "Portuguese Portugal language option"
  },
  "romanian": "Romanian",
  "@romanian": {
    "description": "Romanian language option"
  },
  "russian": "Russian",
  "@russian": {
    "description": "Russian language option"
  },
  "slovak": "Slovak",
  "@slovak": {
    "description": "Slovak language option"
  },
  "spanishMexico": "Spanish (Mexico)",
  "@spanishMexico": {
    "description": "Spanish Mexico language option"
  },
  "swedish": "Swedish",
  "@swedish": {
    "description": "Swedish language option"
  },
  "thai": "Thai",
  "@thai": {
    "description": "Thai language option"
  },
  "turkish": "Turkish",
  "@turkish": {
    "description": "Turkish language option"
  },
  "ukrainian": "Ukrainian",
  "@ukrainian": {
    "description": "Ukrainian language option"
  },
  "vietnamese": "Vietnamese",
  "@vietnamese": {
    "description": "Vietnamese language option"
  }'''

def add_language_names():
    """全ARBファイルに言語名を追加"""
    
    l10n_dir = "lib/l10n"
    arb_files = [f for f in os.listdir(l10n_dir) if f.endswith('.arb')]
    
    print(f"🌍 Adding 29 language names to {len(arb_files)} ARB files...")
    
    for arb_file in sorted(arb_files):
        file_path = os.path.join(l10n_dir, arb_file)
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # すでに追加されているかチェック
        if '"arabic"' in content:
            print(f"⏭️  {arb_file}: Already contains new language names")
            continue
        
        # @hindiエントリの閉じ括弧の位置を見つける
        # パターン: "hindi": "...",\n  "@hindi": {\n    "description": "..."\n  },
        hindi_pattern = r'("hindi":\s*"[^"]+",\s*"@hindi":\s*\{[^}]+\}\s*),(\s*")'
        
        match = re.search(hindi_pattern, content, re.DOTALL)
        if not match:
            print(f"⚠️  {arb_file}: Could not find hindi entry")
            continue
        
        # マッチした位置で挿入
        insert_pos = match.end(1)  # カンマの直後
        
        new_content = (
            content[:insert_pos] +
            ",\n" + LANGUAGE_ENTRIES +
            content[insert_pos:]
        )
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"✅ {arb_file}: Added 29 language names")
    
    print(f"\n📊 Summary: Processed {len(arb_files)} ARB files")

if __name__ == "__main__":
    add_language_names()
