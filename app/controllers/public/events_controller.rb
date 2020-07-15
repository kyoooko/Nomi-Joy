class Public::EventsController < ApplicationController
  before_action :ensure_current_user?, only: [:show]
  def index
    # 今日の飲み会
    # ココから
    from = Time.current.beginning_of_day
    to = Time.current.end_of_day
    @today_event = Event.joins(:event_users).where(event_users: {user_id: current_user.id}).find_by(date: from..to)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@today_event.date.wday] if @today_event.present?
    # 今日のノミカイのカンジ
    # 【★幹事＝user_id使用】
    @today_admin = User.find(@today_event.user_id) if @today_event.present?
    # 未払いのevent_userのうち自分にあたるもの
    @unpaying_event_users = EventUser.includes([:event]).where(user_id: current_user.id, fee_status: false)
    # 全てのノミカイ（カレンダー）
     # includesはN+1問題の解消
    @events = Event.joins(:event_users).where(event_users: {user_id: current_user.id}).includes([:restaurant])
  end

  def show
    @event = Event.find(params[:id])
    @event_user = EventUser.find_by(event_id: params[:id], user_id: current_user.id)
    # 【★幹事＝user_id使用】
    @admin = User.find(@event.user_id)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@event.date.wday]
  end

  private
  # 自分の参加するノミカイ以外はアクセス(URL検索含む）できないようにする
  def ensure_current_user?
    event=Event.find(params[:id])
    events = Event.joins(:event_users).where(event_users: {user_id: current_user.id})
    redirect_back(fallback_location: root_path) unless events.any? { |e| e == event}
 end
end
