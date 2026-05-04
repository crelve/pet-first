#!/usr/bin/env ruby

require 'json'
require 'mini_magick'
require 'fileutils'

# Custom script to frame CJK (Chinese, Japanese, Korean) screenshots
# Bypasses frameit's font path limitations

# 言語コードを引数から取得
locale = ARGV[0] || 'ja'

SCREENSHOTS_DIR = File.expand_path('../../screenshots', __dir__)
LOCALE_DIR = File.join(SCREENSHOTS_DIR, locale)
FRAMEFILE = File.join(LOCALE_DIR, 'Framefile.json')

# 言語ごとのフォント設定
FONTS = {
  'ja' => {
    title: '.Hiragino-Kaku-Gothic-Interface-W6',
    keyword: '.Hiragino-Kaku-Gothic-Interface-W4',
    name: 'Japanese'
  },
  'zh-Hans' => {
    title: 'PingFang-SC-Semibold',  # 简体中文
    keyword: 'PingFang-SC-Regular',
    name: 'Chinese Simplified'
  },
  'zh-Hant' => {
    title: 'PingFang-TC-Semibold',  # 繁體中文
    keyword: 'PingFang-TC-Regular',
    name: 'Chinese Traditional'
  },
  'ko' => {
    title: '.Apple-SD-Gothic-NeoI-Bold',  # 한국어
    keyword: '.Apple-SD-Gothic-NeoI-Regular',
    name: 'Korean'
  }
}

unless FONTS.key?(locale)
  puts "❌ Unsupported locale: #{locale}"
  puts "Supported locales: #{FONTS.keys.join(', ')}"
  exit 1
end

unless File.exist?(FRAMEFILE)
  puts "❌ Framefile not found: #{FRAMEFILE}"
  exit 1
end

# Read Framefile configuration
framefile = JSON.parse(File.read(FRAMEFILE))
config = framefile['default']
data = framefile['data']

# Get fonts for this locale
title_font = FONTS[locale][:title]
keyword_font = FONTS[locale][:keyword]
language_name = FONTS[locale][:name]

puts "🎨 Framing #{language_name} screenshots with ImageMagick..."
puts "📁 Directory: #{LOCALE_DIR}"
puts "🔤 Title font: #{title_font}"
puts "🔤 Keyword font: #{keyword_font}"
puts ""

data.each do |screenshot_config|
  filter = screenshot_config['filter']
  title_text = screenshot_config['title']['text']
  keyword_text = screenshot_config['keyword']['text']

  # フレーム付き画像のパス（frameitで既に生成済み）
  framed_path = File.join(LOCALE_DIR, "#{filter}_framed.png")

  unless File.exist?(framed_path)
    puts "⚠️  Framed screenshot not found: #{framed_path}"
    next
  end

  begin
    # frameitで生成されたフレーム付き画像を読み込む
    img = MiniMagick::Image.open(framed_path)

    # 画像のサイズを取得
    image_width = img.width
    image_height = img.height

    # 一時ファイルパス
    output_tmp = File.join(LOCALE_DIR, "tmp_output_#{filter}.png")

    # タイトルとキーワードのY座標を計算
    title_y = config['padding']
    keyword_y = config['padding'] + config['title']['font_size'] + 20

    # ImageMagickで直接テキストを追加（-gravity Centerで完全中央揃え）
    # Y座標はNorthからのオフセットとして指定
    title_y_from_center = title_y - (image_height / 2)
    keyword_y_from_center = keyword_y - (image_height / 2)

    system("magick '#{framed_path}' " \
           "-gravity Center " \
           "-font '#{title_font}' -pointsize #{config['title']['font_size']} -fill '#{config['title']['color']}' " \
           "-annotate +0+#{title_y_from_center} '#{title_text}' " \
           "-font '#{keyword_font}' -pointsize #{config['keyword']['font_size']} -fill '#{config['keyword']['color']}' " \
           "-annotate +0+#{keyword_y_from_center} '#{keyword_text}' " \
           "-background white -flatten -alpha off -define png:color-type=2 " \
           "'#{output_tmp}'")

    # 一時ファイルを元のファイルに移動
    FileUtils.mv(output_tmp, framed_path)

    puts "✅ #{filter}: #{title_text}"

  rescue => e
    puts "❌ Error adding text to #{filter}: #{e.message}"
    puts e.backtrace.first(3).join("\n")
  end
end

puts ""
puts "🎉 #{language_name} screenshots framed successfully!"
puts "📂 Check results: open #{LOCALE_DIR}"
