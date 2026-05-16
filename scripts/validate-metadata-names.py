#!/usr/bin/env python3
"""
メタデータ名の重複をローカルで検証（CI 実行前の事前チェック）
汎用化版：任意のアプリリポで使用可能

使い方：
  python3 scripts/validate-metadata-names.py          # iOS のみ検証
  python3 scripts/validate-metadata-names.py --all    # 全プラットフォーム検証
"""

import os
import sys
import argparse
from pathlib import Path
from collections import defaultdict

def validate_metadata_names(platform="ios"):
    """指定プラットフォームのメタデータ名重複をチェック"""

    # リポのルートを自動検出
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent

    base_path = repo_root / platform / "fastlane" / "metadata"

    if not base_path.exists():
        print(f"⚠️  Metadata directory not found: {base_path}")
        return True  # エラーではなく、スキップ

    names_by_locale = {}
    name_occurrences = defaultdict(list)

    # 全ロケールの name.txt を読む
    for locale_dir in sorted(base_path.iterdir()):
        if not locale_dir.is_dir():
            continue

        name_file = locale_dir / "name.txt"
        if name_file.exists():
            name = name_file.read_text().strip()
            locale = locale_dir.name
            names_by_locale[locale] = name
            name_occurrences[name].append(locale)

    # 重複をチェック
    print(f"📋 {platform.upper()} Metadata Names Validation")
    print(f"   Total locales: {len(names_by_locale)}")
    print()

    has_duplicates = False

    for name, locales in sorted(name_occurrences.items()):
        if len(locales) > 1:
            # 同じ基底言語（en-AU と en-GB など）の方言間は許容
            base_langs = {l.split("-")[0] for l in locales}
            if len(base_langs) == 1:
                continue
            print(f"❌ DUPLICATE across different languages: '{name}'")
            for locale in sorted(locales):
                print(f"      └─ {locale}")
            has_duplicates = True

    if not has_duplicates:
        print("✅ No duplicates detected!")

    print()
    print("📝 All names:")
    max_locale_len = max(len(l) for l in names_by_locale.keys()) if names_by_locale else 0
    for locale in sorted(names_by_locale.keys()):
        print(f"   {locale:{max_locale_len}} → {names_by_locale[locale]}")

    return not has_duplicates

def main():
    parser = argparse.ArgumentParser(
        description="メタデータ名の重複をローカルで検証"
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="iOS と Android 両方を検証（デフォルトは iOS のみ）"
    )

    args = parser.parse_args()

    platforms = ["ios", "android"] if args.all else ["ios"]
    all_valid = True

    for platform in platforms:
        if not validate_metadata_names(platform):
            all_valid = False
        print()

    return 0 if all_valid else 1

if __name__ == "__main__":
    exit(main())
