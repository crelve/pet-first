#!/usr/bin/env ruby

# 39言語のFramefile.jsonを生成するスクリプト

require 'json'
require 'fileutils'

# 言語コードと対応するテキストのマッピング
LOCALES = {
  'en-US' => {
    '01-home' => { title: 'Welcome Home', keyword: 'Your personalized dashboard' },
    '02-explore' => { title: 'Discover More', keyword: 'Explore tailored content' },
    '03-favorites' => { title: 'Save Favorites', keyword: 'Quick access to favorites' },
    '04-profile' => { title: 'Your Profile', keyword: 'Manage your account' },
    '05-settings' => { title: 'Customize', keyword: 'Personalize your experience' }
  },
  'ja' => {
    '01-home' => { title: 'ホーム', keyword: 'あなた専用のダッシュボード' },
    '02-explore' => { title: '探索', keyword: 'おすすめコンテンツを発見' },
    '03-favorites' => { title: 'お気に入り', keyword: 'お気に入りに素早くアクセス' },
    '04-profile' => { title: 'プロフィール', keyword: 'アカウントを管理' },
    '05-settings' => { title: 'カスタマイズ', keyword: '体験をパーソナライズ' }
  },
  'zh-Hans' => {
    '01-home' => { title: '欢迎回家', keyword: '您的个性化仪表板' },
    '02-explore' => { title: '发现更多', keyword: '探索量身定制的内容' },
    '03-favorites' => { title: '保存收藏', keyword: '快速访问收藏内容' },
    '04-profile' => { title: '您的资料', keyword: '管理您的账户' },
    '05-settings' => { title: '自定义', keyword: '个性化您的体验' }
  },
  'ko' => {
    '01-home' => { title: '홈으로 오신 것을 환영합니다', keyword: '맞춤형 대시보드' },
    '02-explore' => { title: '더 발견하기', keyword: '맞춤 콘텐츠 탐색' },
    '03-favorites' => { title: '즐겨찾기 저장', keyword: '즐겨찾기에 빠르게 액세스' },
    '04-profile' => { title: '프로필', keyword: '계정 관리' },
    '05-settings' => { title: '사용자 지정', keyword: '경험 개인화' }
  }
  # 他の言語は英語版をコピー（後で翻訳）
}

# デフォルトの設定
DEFAULT_CONFIG = {
  'default' => {
    'background' => './background.png',
    'padding' => 50,
    'title' => {
      'color' => '#FFFFFF',
      'font_size' => 72
    },
    'keyword' => {
      'color' => '#E3F2FD',
      'font_size' => 48
    }
  }
}

# 各言語のFramefile.jsonを生成
LOCALES.each do |locale, texts|
  framefile = DEFAULT_CONFIG.dup
  
  framefile['data'] = texts.map do |filter, content|
    {
      'filter' => filter,
      'title' => { 'text' => content[:title] },
      'keyword' => { 'text' => content[:keyword] }
    }
  end
  
  # ファイルに書き出し
  filename = "Framefile-#{locale}.json"
  File.write(filename, JSON.pretty_generate(framefile))
  puts "✅ Generated: #{filename}"
end

puts "\n📝 Generated Framefiles for #{LOCALES.size} languages"
puts "💡 To use: frameit --config Framefile-ja.json"
