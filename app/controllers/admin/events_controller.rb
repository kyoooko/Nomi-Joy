class Admin::EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update,:destroy]
  before_action :set_event_by_event_id, only: [:notice_to_unpaying_users, :progress_status_update, :add_event_user,:add_event_user_fee,:add_event_user_create, :change_restaurant, :change_restaurant_update]
  before_action :ensure_admin?, only: [:show, :edit, :update,:destroy]
  before_action :ensure_admin_event_id?, only: [:progress_status_update, :notice_to_unpaying_users]

  # 以下、includesはN+1問題の解消
    # 以下、with_deletedは欠席者も含むための記述（gem paranoia）

  def index
    # 下記集金中メンバーに変更要
    @users = User.all
    # タブ１
    # 今日のノミカイ
    # 【★幹事＝user_id使用】
    from = Time.current.beginning_of_day
    to = Time.current.end_of_day
    @today_event = Event.includes([:restaurant]).find_by(date: from..to, user_id: current_user.id) 
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@today_event.date.wday] if @today_event.present?

    # タブ２
    # 全てのノミカイ
    # 【★幹事＝user_id使用】
    @status0_events = Event.where(progress_status: 0, user_id:current_user.id)
    @status1_events = Event.where(progress_status: 1, user_id:current_user.id)
    @status2_events = Event.where(progress_status: 2, user_id:current_user.id)
    # 全てのノミカイ（カレンダー）
     @events = Event.where(user_id:current_user.id).includes([:restaurant])

    # タブ３ 
    # 集金中のノミカイ
    @events = Event.where(user_id:current_user.id)    
    # 集金中のノミカイ参加メンバー
    # 【★幹事＝user_id使用】
    # 「current_userが幹事のノミカイで、未支払いの飲み会があるUser」の配列
    @users = User.joins(:event_users).where(event_users: {fee_status: false}).joins(:events).where(events:{user_id: current_user.id}).distinct 
   end

  def show
    # 当該飲み会に関して未払いのメンバー（欠席者含む）
    @unpaying_event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id, fee_status: false)
    # 当該飲み会の参加メンバー全員（欠席者含む）
    @event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id)
    # 曜日
    @day_of_the_week= %w(日 月 火 水 木 金 土)[@event.date.wday]
  end

  def notice_to_unpaying_users
    @unpaying_event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id, fee_status: false)
    @unpaying_event_users.each do |unpaying_event_user|
    @event.create_notification_require_fee(current_user,unpaying_event_user.user_id)
    end
    redirect_back(fallback_location: root_path)
  end

  def edit
  end

  # ノミカイ基本情報の編集
  def update
    redirect_to admin_event_path(@event) if @event.update(event_params)
  end

  # お店の変更ページ
  # form内にsubmitボタンが複数ある。このアクション自体はGET（PATCHでも記述を変えれば問題はない）
  def change_restaurant
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
    if params[:change]
      # お店を選択していない場合は同じページに戻る
      if params[:restaurant]
        @restaurant = Restaurant.create(
          user_id: current_user.id,
          name: restaurant["name"],
          address: restaurant["address"],
          access: restaurant["access"]["line"]  + " " + restaurant["access"]["station"] +  restaurant["access"]["station_exit"] + " 徒歩" + restaurant["access"]["walk"] + "分",
          url: restaurant["url"], 
          shop_image: restaurant["image_url"]["shop_image1"], 
          tel: restaurant["tel"], 
          opentime:  restaurant["opentime"],
          holiday: restaurant["holiday"]      
          )
        @event.update(restaurant_id: @restaurant.id)
        flash[:success] = "お店を変更しました"
        redirect_to admin_event_path(@event)
      else
        flash.now[:danger] = "お店を選択してください"
        render :change_restaurant 
      end
    end
    redirect_to admin_event_path(@event) if params[:back]
  end

  def destroy
    # dependent: :destroyとしているので紐づいているevent_usersも同時に全て削除される
    @event.destroy
    redirect_to admin_events_path
  end

  def progress_status_update
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

  # form内にsubmitボタンが複数ある。このアクション自体はPOST。正しく選択されていれば次のアクション（step3)へリダイレクトされ（リダイレクトのためstep3はGET）、createされる
  def step2
    @event=Event.new(event_params)
    if @event.invalid? 
      flash.now[:danger]= "必要情報を入力してください"
      render :step1 
    end
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
        flash.now[:danger]= "お店を選択してください"
        render :step2
      end
    end
    render :step1 and return if params[:back]
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
    @event_user_ids = session[:event_user_ids] = params[:event_user][:ids].drop(1)
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
      holiday: session[:holiday]
      )
    @event.restaurant_id = @restaurant.id
    render :step4 and return if params[:back]
    render :confirm and return if !@event.save 
    # drop(1)は、sessionの配列の要素１つ目に""(nil)が渡されてしまい参加メンバーの一覧表示ができないため、１つ目を除いている
    event_user_ids = session[:event_user_ids]
    event_user_fees = session[:fees] 
    # 参加メンバーを選択しなかった場合でもエラーにならないようにするためのif文
    if event_user_ids.present?
      event_user_ids.zip(event_user_fees).each { |event_user_id, event_user_fee| EventUser.create(user_id: event_user_id, event_id: @event.id, fee: event_user_fee)}
    end
    # 自分（カンジ）のevent_userも作成
    EventUser.create(user_id: current_user.id, event_id: @event.id, fee: session[:admin_fee])
    redirect_to admin_event_path(@event)
  end

  # 参加メンバーの追加ページ（編集）
  def add_event_user
    members = current_user.matchers
    @unselected_members = members - User.joins(:event_users).where(event_users: {event_id:@event.id}) 

    # @unselected_members = members - User.joins(:event_users).with_deleted.to_sql.where(event_users: {event_id:@event.id}) 

    # @unselected_members = members - User.joins(:event_users).where('event_users.event_id = ? event_users.deleted_at != ?', mailing_id, nil) 



  end

  # 参加メンバーの追加後会費設定ページ（編集）
  def add_event_user_fee
    @event_user_ids = session[:event_user_ids] = params[:event_user][:ids].drop(1)
    redirect_to admin_event_path(@event) and return if params[:back]
    # メンバーを選択せずNextボタンを押した場合進めない
    if @event_user_ids.blank?
      flash[:danger]= "メンバーを選択してください"
      redirect_to admin_add_event_user_path(@event) 
    end
  end

  # 参加メンバーの追加（編集）
  def add_event_user_create
    @event_user_ids = session[:event_user_ids]
    # 下記、Backボタン押した場合renderするための記述
    members = current_user.matchers
    @unselected_members = members - User.joins(:event_users).where(event_users: {event_id:@event.id})
    render :add_event_user and return if params[:back]
    # 確定ボタン押した場合
    event_user_ids = session[:event_user_ids] 
    event_user_fees = session[:fees] = params[:fees]  
    event_user_ids.zip(event_user_fees).each { |event_user_id, event_user_fee| EventUser.create(user_id: event_user_id, event_id: @event.id, fee: event_user_fee)}
    flash[:success]= "参加メンバーを追加しました"
    redirect_to admin_event_path(@event)
  end

  
  private
  def set_event
    @event=Event.find(params[:id])
  end

  def set_event_by_event_id
    @event=Event.find(params[:event_id])
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
