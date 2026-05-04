#!/usr/bin/env python3
"""App Store Connect メタデータ文字数チェック

対象ファイルと制限:
  name.txt             <= 30文字
  subtitle.txt         <= 30文字
  keywords.txt         <= 100文字
  promotional_text.txt <= 170文字
  description.txt      <= 4000文字
  release_notes.txt    <= 4000文字

文字数は NFC 正規化後の Unicode コードポイント数でカウント
（App Store Connect の計算方法に準拠）
"""
import unicodedata
import glob
import sys

LIMITS = {
    "name.txt": 30,
    "subtitle.txt": 30,
    "keywords.txt": 100,
    "promotional_text.txt": 170,
    "description.txt": 4000,
    "release_notes.txt": 4000,
}

errors = []

for filename, limit in LIMITS.items():
    files = sorted(glob.glob(f"ios/fastlane/metadata/*/{filename}"))
    for f in files:
        lang = f.split("/")[3]
        text = open(f, encoding="utf-8").read().strip()
        n = len(unicodedata.normalize("NFC", text))
        if n > limit:
            errors.append((filename, lang, n, limit, text))

if errors:
    print("❌ App Storeメタデータ 文字数制限違反:")
    for filename, lang, n, limit, text in errors:
        print(f"   {lang}/{filename}: {n}/{limit}文字")
        print(f"   内容: {text[:60]}{'...' if len(text) > 60 else ''}")
    sys.exit(1)
else:
    print("✅ App Storeメタデータ: 全言語の文字数制限OK")
    for filename, limit in LIMITS.items():
        count = len(glob.glob(f"ios/fastlane/metadata/*/{filename}"))
        if count > 0:
            print(f"   {filename:<25} (≤{limit}文字): {count}言語")
