require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NomiJoy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # 日本時間に設定
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local
    # カレンダー
    config.beginning_of_week = :sunday
    # 通知機能の「○分前」を日本語表示にするため
    config.i18n.default_locale = :ja
    # config/locales以下のディレクトリ内にある全てのymlファイルを読み込む（エラーメッセージの日本語化で使用）
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
  end
end

