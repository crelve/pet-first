#!/bin/bash

# スクリーンショット背景画像を生成（ImageMagick使用）
# iPhone 16 Pro Max: 1290x2796
# 設定ファイル: ../../creative/background_colors.json

set -e

OUTPUT_FILE="./background.png"
CONFIG_FILE="../../creative/background_colors.json"

# ImageMagickコマンドを自動検出（imagemagick-full > magick > convert）
# imagemagick-fullはFreetypeサポートを含む（日本語・アラビア語等のレンダリングに必須）
if [ -f "/opt/homebrew/opt/imagemagick-full/bin/magick" ]; then
  MAGICK_CMD="/opt/homebrew/opt/imagemagick-full/bin/magick"
elif command -v magick &> /dev/null; then
  MAGICK_CMD="magick"
elif command -v convert &> /dev/null; then
  MAGICK_CMD="convert"
else
  echo "❌ Error: ImageMagick not found. Please install with: brew install imagemagick-full"
  exit 1
fi

echo "Using ImageMagick command: $MAGICK_CMD"

# 設定ファイルが存在しない場合はデフォルト設定で生成
if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  Warning: $CONFIG_FILE not found. Using default luxurious style."
  STYLE="luxurious"
  COLOR1="#667eea"
  COLOR2="#764ba2"
  COLOR3="#f093fb"
  COLOR4="#f5576c"
  ANGLE=135
  NOISE=0.15
  OVERLAY=0.3
else
  echo "📖 Reading configuration from $CONFIG_FILE"

  # jqが利用可能かチェック
  if ! command -v jq &> /dev/null; then
    echo "⚠️  Warning: jq not found. Using default settings."
    STYLE="luxurious"
    COLOR1="#667eea"
    COLOR2="#764ba2"
    COLOR3="#f093fb"
    COLOR4="#f5576c"
    ANGLE=135
    NOISE=0.15
    OVERLAY=0.3
  else
    # JSONから設定を読み込み
    STYLE=$(jq -r '.style // "luxurious"' "$CONFIG_FILE")
    COLOR1=$(jq -r '.colors.gradient_start // "#667eea"' "$CONFIG_FILE")
    COLOR2=$(jq -r '.colors.gradient_mid // "#764ba2"' "$CONFIG_FILE")
    COLOR3=$(jq -r '.colors.gradient_mid // "#f093fb"' "$CONFIG_FILE")
    COLOR4=$(jq -r '.colors.gradient_end // "#f5576c"' "$CONFIG_FILE")
    PRIMARY=$(jq -r '.colors.primary // "#1976D2"' "$CONFIG_FILE")
    ANGLE=$(jq -r '.gradient_angle // 135' "$CONFIG_FILE")
    NOISE=$(jq -r '.noise_intensity // 0.15' "$CONFIG_FILE")
    OVERLAY=$(jq -r '.overlay_opacity // 0.3' "$CONFIG_FILE")

    echo "   Style: $STYLE"
    echo "   Colors: $COLOR1 → $COLOR2 → $COLOR3 → $COLOR4"
    echo "   Primary: $PRIMARY"
  fi
fi

# スタイルに応じて背景を生成
case "$STYLE" in
  simple)
    echo "🎨 Generating simple gradient background..."

    # シンプルな縦グラデーション（明るめ → ブランドカラー）
    # ブランドカラーから明るいバリエーションを計算
    LIGHT=$(echo "$PRIMARY" | sed 's/#//')
    R=$(printf "%d" 0x${LIGHT:0:2})
    G=$(printf "%d" 0x${LIGHT:2:2})
    B=$(printf "%d" 0x${LIGHT:4:2})

    # 明るいバリエーション（各成分+100、最大255）
    R_LIGHT=$(( R + 100 > 255 ? 255 : R + 100 ))
    G_LIGHT=$(( G + 100 > 255 ? 255 : G + 100 ))
    B_LIGHT=$(( B + 100 > 255 ? 255 : B + 100 ))
    LIGHT_COLOR=$(printf "#%02X%02X%02X" $R_LIGHT $G_LIGHT $B_LIGHT)

    $MAGICK_CMD -size 1290x2796 \
      gradient:"${LIGHT_COLOR}-${PRIMARY}" \
      "$OUTPUT_FILE"

    echo "✅ Simple gradient generated: $LIGHT_COLOR → $PRIMARY"
    ;;

  natural)
    echo "🌿 Generating natural gradient background..."

    # ナチュラルグラデーション（緑→青）
    $MAGICK_CMD -size 1290x2796 \
      gradient:"${COLOR1}-${COLOR4}" \
      "$OUTPUT_FILE"

    echo "✅ Natural gradient generated: $COLOR1 → $COLOR4"
    ;;

  professional)
    echo "💼 Generating professional gradient background..."

    # プロフェッショナルグラデーション（濃紺→ライトブルー）
    $MAGICK_CMD -size 1290x2796 \
      gradient:'#1e3c72-#2a5298' \
      "$OUTPUT_FILE"

    echo "✅ Professional gradient generated"
    ;;

  pop)
    echo "🎉 Generating pop gradient background..."

    # ポップグラデーション（鮮やかな2色）
    $MAGICK_CMD -size 1290x2796 \
      gradient:"${COLOR1}-${COLOR4}" \
      -rotate 45 \
      -gravity center \
      -extent 1290x2796 \
      "$OUTPUT_FILE"

    echo "✅ Pop gradient generated: $COLOR1 → $COLOR4"
    ;;

  soft)
    echo "☁️  Generating soft gradient background..."

    # 柔らかいグラデーション（パステル調）
    $MAGICK_CMD -size 1290x2796 \
      gradient:'#a8edea-#fed6e3' \
      "$OUTPUT_FILE"

    echo "✅ Soft gradient generated"
    ;;

  trend)
    echo "✨ Generating trendy gradient background..."

    # トレンドグラデーション（パステル2色）
    $MAGICK_CMD -size 1290x2796 \
      gradient:'#ffecd2-#fcb69f' \
      -rotate 90 \
      -gravity center \
      -extent 1290x2796 \
      "$OUTPUT_FILE"

    echo "✅ Trendy gradient generated"
    ;;

  luxurious|*)
    echo "💎 Generating luxurious gradient background..."

    # 豪華な多色グラデーション（デフォルト）
    # ステップ1: ベースグラデーション
    $MAGICK_CMD -size 1290x2796 \
      gradient:"${COLOR1}-${COLOR2}" \
      -rotate $ANGLE \
      -gravity center \
      -extent 1290x2796 \
      temp_gradient1.png

    # ステップ2: オーバーレイグラデーション
    $MAGICK_CMD -size 1290x2796 \
      gradient:"${COLOR3}-${COLOR4}" \
      -rotate 45 \
      -gravity center \
      -extent 1290x2796 \
      temp_gradient2.png

    # ステップ3: 2つのグラデーションをブレンド
    $MAGICK_CMD temp_gradient1.png temp_gradient2.png \
      -compose blend -define compose:args=50,50 -composite \
      temp_blended.png

    # ステップ4: 微細なノイズを追加（テクスチャ感）
    $MAGICK_CMD temp_blended.png \
      -attenuate $NOISE +noise Gaussian \
      -blur 0x0.5 \
      temp_noise.png

    # ステップ5: 光沢効果を追加（上部を明るく）
    $MAGICK_CMD -size 1290x2796 \
      gradient:"rgba(255,255,255,${OVERLAY})-rgba(255,255,255,0)" \
      temp_overlay.png

    # ステップ6: すべてを合成
    $MAGICK_CMD temp_noise.png temp_overlay.png \
      -composite \
      "$OUTPUT_FILE"

    # 一時ファイルを削除
    rm -f temp_gradient1.png temp_gradient2.png temp_blended.png temp_noise.png temp_overlay.png

    echo "✅ Luxurious gradient generated: $COLOR1 → $COLOR2 → $COLOR3 → $COLOR4"
    echo "   • Gradient angle: ${ANGLE}°"
    echo "   • Noise intensity: $NOISE"
    echo "   • Overlay opacity: $OVERLAY"
    ;;
esac

echo "📍 Output: $OUTPUT_FILE"
echo ""
echo "💡 Next steps:"
echo "   1. Review the generated background: open $OUTPUT_FILE"
echo "   2. To regenerate with different settings, edit $CONFIG_FILE"
echo "   3. To use AI-generated background, replace with: creative/background_prompt.txt"
