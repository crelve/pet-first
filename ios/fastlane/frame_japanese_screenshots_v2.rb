#!/usr/bin/env ruby

require 'json'
require 'mini_magick'
require 'fileutils'

# Custom script to frame Japanese screenshots
# Step 1: Use frameit to add device frame and background (without text)
# Step 2: Add Japanese text on top of the framed image

SCREENSHOTS_DIR = File.expand_path('../../screenshots', __dir__)
JA_DIR = File.join(SCREENSHOTS_DIR, 'ja')
FRAMEFILE = File.join(JA_DIR, 'Framefile.json')
TEMP_FRAMEFILE = File.join(JA_DIR, 'Framefile_temp.json')

# Read original Framefile configuration
framefile = JSON.parse(File.read(FRAMEFILE))
config = framefile['default']
data = framefile['data']

# Font configuration
TITLE_FONT = '.Hiragino-Kaku-Gothic-Interface-W6'
KEYWORD_FONT = '.Hiragino-Kaku-Gothic-Interface-W4'

puts "🎨 Framing Japanese screenshots with device frames..."
puts "📁 Directory: #{JA_DIR}"
puts ""

# Step 1: Create temporary Framefile with empty text (so frameit adds frame & background only)
puts "📝 Step 1: Creating temporary Framefile (no text)..."
temp_framefile = framefile.dup
temp_framefile['data'] = data.map do |screenshot_config|
  {
    'filter' => screenshot_config['filter'],
    'title' => { 'text' => '' },
    'keyword' => { 'text' => '' }
  }
end
File.write(TEMP_FRAMEFILE, JSON.pretty_generate(temp_framefile))

# Step 2: Run frameit to add device frames and background
puts "🖼️  Step 2: Running frameit to add device frames and background..."
system("cd #{SCREENSHOTS_DIR} && frameit white:false path:#{JA_DIR}")

# Step 3: Add Japanese text to the framed images
puts "✍️  Step 3: Adding Japanese text to framed screenshots..."
data.each do |screenshot_config|
  filter = screenshot_config['filter']
  title_text = screenshot_config['title']['text']
  keyword_text = screenshot_config['keyword']['text']

  framed_path = File.join(JA_DIR, "#{filter}_framed.png")

  unless File.exist?(framed_path)
    puts "⚠️  Framed screenshot not found: #{framed_path}"
    next
  end

  begin
    # Load the framed screenshot (which already has device frame and background)
    img = MiniMagick::Image.open(framed_path)

    # Add Japanese text overlay
    img.combine_options do |c|
      # Title
      c.font TITLE_FONT
      c.pointsize config['title']['font_size']
      c.fill config['title']['color']
      c.gravity 'North'
      c.align 'center'  # 中央揃えを追加
      c.annotate "+0+#{config['padding']}", title_text

      # Keyword (description)
      c.font KEYWORD_FONT
      c.pointsize config['keyword']['font_size']
      c.fill config['keyword']['color']
      c.align 'center'  # 中央揃えを追加
      c.annotate "+0+#{config['padding'] + config['title']['font_size'] + 20}", keyword_text
    end

    # Overwrite the framed image
    img.write framed_path

    puts "✅ #{filter}: #{title_text}"

  rescue => e
    puts "❌ Error adding text to #{filter}: #{e.message}"
    puts e.backtrace.first(3).join("\n")
  end
end

# Step 4: Clean up temporary Framefile
FileUtils.rm(TEMP_FRAMEFILE) if File.exist?(TEMP_FRAMEFILE)

puts ""
puts "🎉 Japanese screenshots framed successfully with device frames!"
puts "📂 Check results: open #{JA_DIR}"
