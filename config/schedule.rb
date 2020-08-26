# =================================================
# 定時処理の内容更新を反映
# RAILS_ENV=production bundle exec whenever --update-crontab
# 無効化
# RAILS_ENV=production bundle exec whenever --clear-crontab
# 現在の設定内容確認
# crontab  -l
# ログはlog/cron.logを確認
# =================================================

# Use this file to easily define all of your cron jobs.
#
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# File.expand_path(File.dirname(__FILE__) + "/environment")

# 絶対パスから相対パス指定
env :PATH, ENV['PATH']
# ログファイルの出力先
set :output, 'log/cron.log'
# ジョブの実行環境の指定(実行環境はprodaction環境がデフォルト設定)
set :environment, :production
# set :environment, :development

# 日本時間の午前8:00にメール送信される（JSTは+9:00なので-9:00の時間を記述）
every 1.days, at: '11:00 pm' do
  # 未読通知が3件以上たまっているユーザーにメール通知
  runner "ScheduledProcessingMailer.check_notice_mail.deliver_now"
  # 翌日ノミカイがある参加者にメール通知
  runner "ScheduledProcessingMailer.before_1day_remind_mail.deliver_now"
end

# デバック
# every 1.minutes do
#   runner "ScheduledProcessingMailer.check_notice_mail.deliver_now"
# end

# 例
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
