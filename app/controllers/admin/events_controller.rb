class Admin::EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update,:destroy]
  before_action :ensure_admin?, only: [:show, :edit, :update,:destroy]
  before_action :ensure_admin_event_id?, only: [:progress_status_update, :notice_to_unpaying_users]

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
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@today_event.date.wday] if @today_event.present?

    # タブ２
    # 全ての飲み会
    # 【★幹事＝user_id使用】
    @status0_events = Event.where(progress_status: 0, user_id:current_user.id)
    @status1_events = Event.where(progress_status: 1, user_id:current_user.id)
    @status2_events = Event.where(progress_status: 2, user_id:current_user.id)
    # 全てのノミカイ（カレンダー）
     # includesはN+1問題の解消
     @events = Event.where(user_id:current_user.id).includes([:restaurant])

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

  def notice_to_unpaying_users
    @event=Event.find(params[:event_id])
    @unpaying_event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id, fee_status: false)
    @unpaying_event_users.each do |unpaying_event_user|
    @event.create_notification_require_fee(current_user,unpaying_event_user.user_id)
    end
    redirect_back(fallback_location: root_path)
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
    @event=Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    # ぐるなびAPI
    api_key= Rails.application.credentials.grunavi[:api_key]
    url='https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid='
    url << api_key  
    if params[:freeword]
    word=params[:freeword]
    url << "&name=" << word 
    end
    url=URI.encode(url) 
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    @rests=result["rest"]
    restaurant = eval("#{params[:restaurant]}")
    if params[:next]
      # お店を選択していない場合は同じページに戻る
      if params[:restaurant]
        session[:name] = restaurant["name"]
        session[:address] = restaurant["address"]
        session[:access] = restaurant["access"]["line"]  + " " + restaurant["access"]["station"] +  restaurant["access"]["station_exit"] + " 徒歩" + restaurant["access"]["walk"] + "分"
        session[:url] = restaurant["url"]
        session[:tel] = restaurant["tel"]
        session[:shop_image] = restaurant["image_url"]["shop_image1"]
        session[:opentime] = restaurant["opentime"]
        session[:holiday] = restaurant["holiday"]
        # step3をgetにしたためf.hiddenで渡せないので redirect_toのオプションでparamsを送る
        redirect_to admin_step3_path(event: event_params) 
      else
        flash[:danger] = "お店を選択してください"
        render :step2
      end
    end
    render :step1 and return if params[:back]
    render :step1 if @event.invalid? 
  end
  def step3
    @members = current_user.matchers
    @event=Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    render :step2 if @event.invalid? 
  end

  # step4のみ検討要
  def step4
    @event=Event.new(event_params)
    # # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @event_user_ids = session[:event_user_ids] = params[:event][:event_user_ids].drop(1)
    render :step2 and return if params[:back]
  end

  def confirm
    @event=Event.new(event_params)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@event.date.wday]
    # Backボタンで戻ってきた時renderでstep3に戻るので下記追記が必要
    @members = current_user.matchers
    # カンジ
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @restautant_name = session[:name]
    # collection_check_boxesの場合下記
    # session[:event_users] = params[:user][:id] 
    # 選択されたメンバーのIDの配列
    @event_user_ids = session[:event_user_ids]
    @admin_fee = session[:admin_fee]= params[:admin_fee]
    @event_user_fees = session[:fees] = params[:fees]  
    render :step3 and return if params[:back]
  end

  def create
    @event=Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    # Backボタンで戻ってきた時renderなので下記追記が必要
    @event_user_ids = session[:event_user_ids] 
    # お店の作成
    @restaurant = Restaurant.create(
      user_id: current_user.id,
      name: session[:name],
      address: session[:address],
      access: session[:access],
      url: session[:url], 
      shop_image: session[:shop_image], 
      tel: session[:tel], 
      opentime: session[:opentime],
      holiday: session[:holiday])
    @event.restaurant_id = @restaurant.id
    render :step4 and return if params[:back]
    render :confirm and return if !@event.save 
    # drop(1)は、sessionの配列の要素１つ目に""(nil)が渡されてしまい参加メンバーの一覧表示ができないため、１つ目を除いている
    event_user_ids = session[:event_user_ids]
    event_fees = session[:fees] 
    # 参加メンバーを選択しなかった場合でもエラーにならないようにするためのif文
    if event_user_ids.present?
      event_user_ids.zip(event_fees).each { |event_user_id, event_fee| EventUser.create(user_id: event_user_id, event_id: @event.id, fee: event_fee)}
    end
    # 自分（カンジ）のevent_userも作成
    EventUser.create(user_id: current_user.id, event_id: @event.id, fee: session[:admin_fee].to_i)
    redirect_to admin_event_path(@event)
  end

  

  private
  def set_event
    @event=Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :begin_time, :end_time, :memo, :progress_status)
  end

  # 自分がカンジでないノミカイはアクセス(URL検索含む）できないようにする
  def ensure_admin?
     @event=Event.find(params[:id])
     redirect_back(fallback_location: root_path) unless @event.user_id == current_user.id
  end
  def ensure_admin_event_id?
    @event=Event.find(params[:event_id])
    redirect_back(fallback_location: root_path) unless @event.user_id == current_user.id
  end
end
