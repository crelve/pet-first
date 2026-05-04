#!/usr/bin/env ruby

require 'json'
require 'fileutils'

# ARBファイルから翻訳を読み込み、Framefile.jsonを生成するスクリプト

# プロジェクトルート（fastlaneディレクトリから2階層上）
PROJECT_ROOT = File.expand_path('../..', __dir__)
L10N_DIR = File.join(PROJECT_ROOT, 'lib', 'l10n')
SCREENSHOTS_DIR = File.join(PROJECT_ROOT, 'screenshots')

# App Store Connectロケールとl10nロケールのマッピング
LOCALE_MAPPING = {
  'en-US' => 'en',
  'ja' => 'ja',
  'zh-Hans' => 'zh',
  'zh-Hant' => 'zh_Hant',
  'ko' => 'ko',
  'de-DE' => 'de',
  'fr-FR' => 'fr',
  'pt-BR' => 'pt',
  'es-ES' => 'es',
  'hi' => 'hi',
  'it' => 'it',
  'ar-SA' => 'ar',
  'ca' => 'ca',
  'hr' => 'hr',
  'cs' => 'cs',
  'da' => 'da',
  'nl-NL' => 'nl',
  'en-AU' => 'en',  # 英語のフォールバック
  'en-CA' => 'en',  # 英語のフォールバック
  'en-GB' => 'en',  # 英語のフォールバック
  'fi' => 'fi',
  'fr-CA' => 'fr',  # フランス語のフォールバック
  'el' => 'el',
  'he' => 'he',
  'hu' => 'hu',
  'id' => 'id',
  'ms' => 'ms',
  'no' => 'no',
  'pl' => 'pl',
  'pt-PT' => 'pt',  # ポルトガル語のフォールバック
  'ro' => 'ro',
  'ru' => 'ru',
  'sk' => 'sk',
  'es-MX' => 'es',  # スペイン語のフォールバック
  'sv' => 'sv',
  'th' => 'th',
  'tr' => 'tr',
  'uk' => 'uk',
  'vi' => 'vi'
}

# スクリーンショット用のキーマッピング
SCREENSHOT_KEYS = {
  '01-home' => {
    title: 'screenshotHomeTitle',
    keyword: 'screenshotHomeDescription'
  },
  '02-explore' => {
    title: 'screenshotExploreTitle',
    keyword: 'screenshotExploreDescription'
  },
  '03-favorites' => {
    title: 'screenshotFavoritesTitle',
    keyword: 'screenshotFavoritesDescription'
  },
  '04-profile' => {
    title: 'screenshotProfileTitle',
    keyword: 'screenshotProfileDescription'
  },
  '05-settings' => {
    title: 'screenshotSettingsTitle',
    keyword: 'screenshotSettingsDescription'
  }
}

# デフォルトのFramefile設定（全言語共通）
# フォント指定を削除してframeitのデフォルトフォントを使用（日本語も自動対応）
DEFAULT_CONFIG = {
  'default' => {
    'background' => './background.png',
    'padding' => 50,
    'title' => {
      'color' => '#1a1a1a',
      'font_size' => 64
    },
    'keyword' => {
      'color' => '#4a4a4a',
      'font_size' => 44
    }
  }
}

# 日本語用のFramefile設定（やや小さめのフォントサイズ）
# フォント指定なし（frameitの制限により、frame_japanese_screenshots.rbスクリプトを使用）
JAPANESE_CONFIG = {
  'default' => {
    'background' => './background.png',
    'padding' => 50,
    'title' => {
      'color' => '#1a1a1a',
      'font_size' => 64
    },
    'keyword' => {
      'color' => '#4a4a4a',
      'font_size' => 44
    }
  }
}

# アラビア語用のFramefile設定
# 注意: ImageMagickのFreetypeサポート不足により、アラビア語テキストは文字化けする可能性があります
ARABIC_CONFIG = DEFAULT_CONFIG.dup

# ヘブライ語用のFramefile設定
# 注意: ImageMagickのFreetypeサポート不足により、ヘブライ語テキストは文字化けする可能性があります
HEBREW_CONFIG = DEFAULT_CONFIG.dup

# ARBファイルから翻訳を読み込む
def load_translations(arb_locale)
  arb_file = File.join(L10N_DIR, "app_#{arb_locale}.arb")
  
  unless File.exist?(arb_file)
    puts "⚠️  ARB file not found: #{arb_file}, using English fallback"
    arb_file = File.join(L10N_DIR, "app_en.arb")
  end
  
  JSON.parse(File.read(arb_file))
end

# Framefile.jsonを生成
def generate_framefile(app_store_locale, arb_locale, translations)
  # 言語に応じた設定を選択
  framefile = case app_store_locale
              when 'ja'
                JAPANESE_CONFIG
              when 'ar-SA'
                ARABIC_CONFIG
              when 'he'
                HEBREW_CONFIG
              else
                DEFAULT_CONFIG
              end.dup

  framefile['data'] = SCREENSHOT_KEYS.map do |filter, keys|
    title_text = translations[keys[:title]] || "Title Missing"
    keyword_text = translations[keys[:keyword]] || "Description Missing"

    {
      'filter' => filter,
      'title' => { 'text' => title_text },
      'keyword' => { 'text' => keyword_text }
    }
  end

  # 言語ごとのディレクトリにFramefileを保存
  locale_dir = File.join(SCREENSHOTS_DIR, app_store_locale)
  FileUtils.mkdir_p(locale_dir)

  filename = File.join(locale_dir, 'Framefile.json')
  File.write(filename, JSON.pretty_generate(framefile))

  config_name = case app_store_locale
                when 'ja' then 'Japanese config'
                when 'ar-SA' then 'Arabic config'
                when 'he' then 'Hebrew config'
                else 'Default config'
                end
  puts "✅ Generated: #{app_store_locale}/Framefile.json (#{config_name})"
end

# メイン処理
puts "🚀 Generating Framefiles from ARB translations..."
puts "📁 L10N directory: #{L10N_DIR}"
puts "📁 Screenshots directory: #{SCREENSHOTS_DIR}"
puts ""

success_count = 0
error_count = 0

LOCALE_MAPPING.each do |app_store_locale, arb_locale|
  begin
    translations = load_translations(arb_locale)
    
    # スクリーンショット用のキーが存在するか確認
    missing_keys = SCREENSHOT_KEYS.values.flat_map(&:values).reject { |key| translations.key?(key) }
    
    if missing_keys.any?
      puts "⚠️  #{app_store_locale}: Missing keys: #{missing_keys.join(', ')}"
    end
    
    generate_framefile(app_store_locale, arb_locale, translations)
    success_count += 1
  rescue => e
    puts "❌ Error processing #{app_store_locale}: #{e.message}"
    error_count += 1
  end
end

puts ""
puts "📊 Summary:"
puts "   ✅ Success: #{success_count} locales"
puts "   ❌ Errors: #{error_count} locales"
puts ""
puts "💡 Next steps:"
puts "   1. Review generated Framefiles in: #{SCREENSHOTS_DIR}/"
puts "   2. Run: bundle exec fastlane apply_frames"
