source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
# 開発・本番・テスト環境をmysql2に変更
# gem 'sqlite3'
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# post後の画面リロードのエラーを解消するため無効化
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # N+1問題
  gem "bullet"
  # デプロイ自動化
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-rbenv'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # chromedriver-helperは非推奨でテストが走らないためwebdrivers
  # gem 'chromedriver-helper'
  gem 'webdrivers'
  # テスト
  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'faker'
  # CircleCI使用時に必要
  gem "rspec_junit_formatter"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Bootstrap及びjQuery
gem 'bootstrap', '~> 4.5.0'
gem 'jquery-rails'
# ログイン機能
gem 'devise'
# 画像投稿
gem "refile", require: "refile/rails", github: 'manfe/refile'
gem "refile-mini_magick"
# AmazonS3に画像をアップ
gem 'refile-s3'
# ページネーション
gem 'kaminari', '~> 1.2.1'
# デバッグ
gem 'pry-byebug'
# 静的解析ツール
gem 'rubocop-airbnb'
# 論理削除
gem 'paranoia'
# カレンダー
gem 'simple_calendar', '~> 2.0'
# 環境変数（GoogleMapで使用）
gem 'dotenv-rails'
# 多言語化
gem 'rails-i18n', '~> 5.1'
# メタタグ
gem 'meta-tags'
# バッチ（定時）処理
gem 'whenever', require: false
