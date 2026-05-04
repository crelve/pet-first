#!/usr/bin/env ruby

require 'json'
require 'mini_magick'
require 'fileutils'

# Custom script to frame Japanese screenshots using ImageMagick directly
# Bypasses frameit's font path limitations

SCREENSHOTS_DIR = File.expand_path('../../screenshots', __dir__)
JA_DIR = File.join(SCREENSHOTS_DIR, 'ja')
FRAMEFILE = File.join(JA_DIR, 'Framefile.json')

# Read Framefile configuration
framefile = JSON.parse(File.read(FRAMEFILE))
config = framefile['default']
data = framefile['data']

# Font configuration
TITLE_FONT = '.Hiragino-Kaku-Gothic-Interface-W6'
KEYWORD_FONT = '.Hiragino-Kaku-Gothic-Interface-W4'

puts "🎨 Framing Japanese screenshots with ImageMagick..."
puts "📁 Directory: #{JA_DIR}"
puts ""

data.each do |screenshot_config|
  filter = screenshot_config['filter']
  title_text = screenshot_config['title']['text']
  keyword_text = screenshot_config['keyword']['text']

  # フレーム付き画像のパス（frameitで既に生成済み）
  framed_path = File.join(JA_DIR, "#{filter}_framed.png")

  unless File.exist?(framed_path)
    puts "⚠️  Framed screenshot not found: #{framed_path}"
    next
  end

  begin
    # frameitで生成されたフレーム付き画像を読み込む
    img = MiniMagick::Image.open(framed_path)

    # 日本語テキストを追加
    img.combine_options do |c|
      # Title
      c.font TITLE_FONT
      c.pointsize config['title']['font_size']
      c.fill config['title']['color']
      c.gravity 'North'
      c.annotate "+0+#{config['padding']}", title_text

      # Keyword (description)
      c.font KEYWORD_FONT
      c.pointsize config['keyword']['font_size']
      c.fill config['keyword']['color']
      c.annotate "+0+#{config['padding'] + config['title']['font_size'] + 20}", keyword_text
    end

    # 上書き保存
    img.write framed_path

    puts "✅ #{filter}: #{title_text}"

  rescue => e
    puts "❌ Error adding text to #{filter}: #{e.message}"
    puts e.backtrace.first(3).join("\n")
  end
end

puts ""
puts "🎉 Japanese screenshots framed successfully!"
puts "📂 Check results: open #{JA_DIR}"
