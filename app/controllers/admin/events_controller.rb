class Admin::EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update,:destroy]

  def index
    # 下記集金中メンバーに変更要
    @users = User.all
    # タブ１
    # 今日の飲み会
    # 【★幹事＝user_id使用】
    from = Time.current.beginning_of_day
    to = Time.current.end_of_day
    @today_event = Event.find_by(date: from..to, user_id: current_user.id) 
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@today_event.date.wday]

    # タブ２
    # 全ての飲み会
    # 【★幹事＝user_id使用】
    @status0_events = Event.where(progress_status: 0, user_id:current_user.id)
    @status1_events = Event.where(progress_status: 1, user_id:current_user.id)
    @status2_events = Event.where(progress_status: 2, user_id:current_user.id)

    # タブ３ 
    # 集金中の飲み会
    @unpaid_events = Event.where(fee_status: false, user_id:current_user.id)    
    # 集金中の飲み会メンバー
    # includesはN+1問題の解消
    # with_deletedは欠席者も含むための記述（gem paranoia）
    # 【★幹事＝user_id使用】
    @unpaying_event_users =  EventUser.joins(:event).where(events:{user_id: current_user.id}).with_deleted.includes([:user]).where(fee_status: false)

    # ここから【対応要】
    # @users = User.all

    # @event_users = []
    #   @users.map {|user|
    #    if user.event_users.any? 
    #    @event_users <<  user
    #   end
    # }
    # @event_users.each do |event_user|
    #   event_user
    # end
  end

  def show
    # 以下、includesはN+1問題の解消
    # 以下、with_deletedは欠席者も含むための記述（gem paranoia）
    # 当該飲み会に関して未払いのメンバー（欠席者含む）
    @unpaying_event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id, fee_status: false)
    #  当該飲み会の参加メンバー全員（欠席者含む）
    @event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@event.date.wday]
  end

  def edit
  end

  def update
  end

  def destroy
    # dependent: :destroyとしているので紐づいているevent_usersも同時に全て削除される
    @event.destroy
    redirect_to admin_events_path
  end

  def progress_status_update
    @event=Event.find(params[:event_id])
    @event.update(event_params)
    flash[:success] = "進捗ステータスを更新しました"
    redirect_back(fallback_location: root_path)
  end

  def confirm_plan_remind
  end

  def send_plan_remind
  end

  def step1
      @event=Event.new
  end

  def step2
    @members = current_user.matchers
    @event=Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @event.restaurant_id = params[:event][:restaurant_id].to_i
    render :step1 if @event.invalid?
  end

  def confirm
    @event=Event.new(event_params)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@event.date.wday]
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @event.restaurant_id = params[:event][:restaurant_id].to_i
    # collection_check_boxesの場合下記
    # session[:event_users] = params[:user][:id] 
    session[:event_users] = params[:event][:event_user_ids]
    # drop(1)は、sessionの配列の要素１つ目に""(nil)が渡されてしまい参加メンバーの一覧表示ができないため、１つ目を除いている
    @event_users = session[:event_users].drop(1)
    render :step1 and return if params[:back]
    render :step2 if @event.invalid?
  end

  def create
    # Backボタンで戻ってきた時renderなので下記追記が必要
    @members = current_user.matchers
    @event=Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @event.restaurant_id = params[:event][:restaurant_id].to_i
    # binding.pry
    render :step2 and return if params[:back]
    render :confirm and return if !@event.save 
    event_users = session[:event_users]
    # 【模索中】Backボタンで戻った時、選択されたままにしたいのでsessionを使わずf.hiddenを使って実装をしたい
    # event_users = params [:event][:event_user_ids]
    event_users.map { |event_user| EventUser.create(user_id: event_user, event_id: @event.id, fee: 3000)}
    # 自分（カンジ）のevent_userも作成
    EventUser.create(user_id: current_user.id, event_id: @event.id, fee: 3000)
     redirect_to admin_event_path(@event)
  end


  private
  def set_event
    @event=Event.find(params[:id])
  end

  def event_params
    # event_user_idsはconfirmページのBackボタン押した際にもcheck_boxesの選択idを保持するため作成した
    params.require(:event).permit(:name, :date, :start_time, :end_time, :memo, :progress_status, :fee_status,:event_user_ids)
  end
end
