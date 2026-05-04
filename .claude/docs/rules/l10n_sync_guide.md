# L10n Synchronization Guide

## Overview

This guide explains how to maintain synchronization across all localization files in the project.

## File Structure

```
lib/l10n/ (市場規模順)
├── app_en.arb (1. English - Base file, Largest market)
├── app_ja.arb (2. Japanese - High ARPU)
├── app_zh.arb (3. Chinese - Large user base)
├── app_ko.arb (4. Korean - Top paying users)
├── app_de.arb (5. German - Largest EU iOS)
├── app_fr.arb (6. French - EU #2)
├── app_pt.arb (7. Portuguese - LATAM largest)
├── app_es.arb (8. Spanish - Wide language base)
├── app_hi.arb (9. Hindi - Growing market)
└── app_it.arb (10. Italian - EU mid-tier)
```

## Base File

- **Base file**: `app_en.arb` (English)
- All other language files should have the same keys as the base file
- Keys are in the format: `"keyName": "translation"`
- Metadata keys start with `@` (e.g., `"@keyName": { "description": "..." }`)

## Synchronization Rules

### 1. Key Consistency
All `.arb` files must have the same set of keys (excluding metadata keys starting with `@`).

### 2. Adding New Keys
When adding a new key:
1. Add it to `app_en.arb` first
2. Run `make check-l10n` to verify synchronization
3. Run `make sync-l10n` to add the key to all other files
4. Translate the key in each language file

### 3. Key Format
Each key should have:
- Translation value: `"keyName": "Translation text"`
- Metadata (optional): `"@keyName": { "description": "...", "placeholders": {...} }`

### 4. Translation Language Rules ⚠️ CRITICAL

#### 4.1. Translation Values
**MUST** be in the target language of the file:
- `app_en.arb`: All translation values in English (1. Largest market)
- `app_ja.arb`: All translation values in Japanese 日本語 (2. High ARPU)
- `app_zh.arb`: All translation values in Chinese 中文 (3. Large user base)
- `app_ko.arb`: All translation values in Korean 한국어 (4. Top paying)
- `app_de.arb`: All translation values in German Deutsch (5. EU largest iOS)
- `app_fr.arb`: All translation values in French Français (6. EU #2)
- `app_pt.arb`: All translation values in Portuguese Português (7. LATAM)
- `app_es.arb`: All translation values in Spanish Español (8. Wide base)
- `app_hi.arb`: All translation values in Hindi हिन्दी (9. Growing)
- `app_it.arb`: All translation values in Italian Italiano (10. EU mid)

#### 4.2. Description Fields
**MUST** always be in Japanese (日本語) across ALL files:
```json
// ✅ Correct - Description is in Japanese
"@setting": {
  "description": "設定メニュー項目"
}

// ❌ Incorrect - Description in English
"@setting": {
  "description": "Settings menu item"
}
```

#### 4.3. Special Case: Language Names
Language name translations **MUST** be in the target language:

**app_ko.arb (Korean):**
```json
"english": "영어",        // NOT "English"
"japanese": "일본어",     // NOT "日本語"
"french": "프랑스어",     // NOT "Français"
"italian": "이탈리아어",  // NOT "Italiano"
"spanish": "스페인어",    // NOT "Español"
"korean": "한국어",       // Correct
"chinese": "중국어",      // NOT "中文"
```

**app_zh.arb (Chinese):**
```json
"english": "英语",        // NOT "English"
"japanese": "日语",       // NOT "日本語"
"french": "法语",         // NOT "Français"
"italian": "意大利语",    // NOT "Italiano"
"spanish": "西班牙语",    // NOT "Español"
"korean": "韩语",         // NOT "한국어"
"chinese": "中文",        // Correct
```

## Commands

### Check Synchronization Status

```bash
make check-l10n
```

This command:
- Compares all `.arb` files with the base file (`app_en.arb`)
- Reports missing keys in each file
- Shows line count differences
- Exits with error if files are not synchronized

### Auto-Sync Missing Keys

```bash
make sync-l10n
```

This command:
- Automatically adds missing keys from `app_en.arb` to all other files
- Preserves existing translations
- Adds English values as placeholders for missing translations
- Maintains JSON formatting

**⚠️ Important**: After running `make sync-l10n`, you must manually translate the added keys in each language file.

## Workflow

### Adding a New Translation Key

1. **Add to base file** (`app_en.arb`):
   ```json
   "newKey": "English translation",
   "@newKey": {
     "description": "Description of this key"
   }
   ```

2. **Check synchronization**:
   ```bash
   make check-l10n
   ```

3. **Auto-sync to all files**:
   ```bash
   make sync-l10n
   ```

4. **Translate manually**:
   - Open each language file
   - Find the new key (will have English value)
   - Replace with appropriate translation

5. **Verify**:
   ```bash
   make check-l10n
   ```

### Before Committing

Always run `make check-l10n` before committing to ensure all localization files are synchronized.

## Best Practices

### 1. Always Use Base File
- Add new keys to `app_en.arb` first
- Never add keys directly to other language files

### 2. Descriptive Keys
Use descriptive key names:
- ✅ `createNewListButton`
- ❌ `button1`

### 3. Metadata
Always add metadata for context:
```json
"@keyName": {
  "description": "Clear description of where and how this is used"
}
```

**IMPORTANT**: Description fields MUST always be in Japanese across all language files.

### 4. Placeholders
For dynamic content, use placeholders:
```json
"welcomeUser": "Welcome, {userName}!",
"@welcomeUser": {
  "description": "ユーザー名を含むウェルカムメッセージ",
  "placeholders": {
    "userName": {
      "type": "String"
    }
  }
}
```

### 5. Regular Checks
- Run `make check-l10n` regularly during development
- Include in pre-commit hooks
- Part of CI/CD pipeline

### 6. Language Verification Checklist
Before committing changes to localization files, verify:

- [ ] All translation values are in the correct target language
- [ ] All `@description` fields are in Japanese (日本語)
- [ ] Language names (english, japanese, french, etc.) are translated to the target language
- [ ] No mix of languages within translation values
- [ ] No English text in non-English files (except in descriptions)

## Troubleshooting

### Issue: Keys are out of sync

**Solution**:
```bash
make sync-l10n
# Then manually translate the added keys
```

### Issue: Different line counts

**Cause**: Missing keys or formatting differences

**Solution**:
```bash
make check-l10n  # Identify missing keys
make sync-l10n   # Add missing keys
```

### Issue: Duplicate keys

**Solution**:
- Manually check the file for duplicate keys
- Keep only one instance of each key
- Run `make check-l10n` to verify

### Issue: Translation values not in target language

**Problem**: Language names or other values are in English or wrong language
- Korean file has "English" instead of "영어"
- Chinese file has "日本語" instead of "日语"

**Solution**:
1. Identify the incorrect translations
2. Replace with proper translations in the target language
3. Verify using the Language Verification Checklist in Best Practices

**Example fixes**:
- `app_ko.arb`: Replace all language names with Korean translations
- `app_zh.arb`: Replace all language names with Chinese translations

### Issue: Description fields in wrong language

**Problem**: `@description` fields are in English or other languages instead of Japanese

**Solution**:
1. Search for all `"description":` fields in the file
2. Translate all descriptions to Japanese
3. Ensure consistency across all language files

## Integration with Development

### Git Hooks

Add to `.git/hooks/pre-commit`:
```bash
#!/bin/bash
make check-l10n || {
  echo "Localization files are not synchronized!"
  echo "Run 'make sync-l10n' to fix."
  exit 1
}
```

### CI/CD

Add to your CI pipeline:
```yaml
- name: Check L10n Sync
  run: make check-l10n
```

## File Format

### Structure
```json
{
  "@@locale": "en",
  "keyName": "Translation value",
  "@keyName": {
    "description": "Key description"
  },
  "anotherKey": "Another value",
  "@anotherKey": {
    "description": "Another description",
    "placeholders": {
      "paramName": {
        "type": "String"
      }
    }
  }
}
```

### Rules
- Valid JSON format
- UTF-8 encoding
- 2-space indentation
- No trailing commas before closing brace
- Metadata keys (`@keyName`) immediately follow their translation key

## Statistics (市場規模順)

Current state (10 languages):
- **app_en.arb**: Base file (1. Largest market)
- **app_ja.arb**: (2. High ARPU)
- **app_zh.arb**: (3. Large user base)
- **app_ko.arb**: (4. Top paying users)
- **app_de.arb**: (5. EU largest iOS)
- **app_fr.arb**: (6. EU #2)
- **app_pt.arb**: (7. LATAM largest)
- **app_es.arb**: (8. Wide language base)
- **app_hi.arb**: (9. Growing market)
- **app_it.arb**: (10. EU mid-tier)

Target: All files should have the same number of lines as the base file.

## References

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
