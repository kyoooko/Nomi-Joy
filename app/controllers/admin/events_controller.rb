class Admin::EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_event_by_event_id, only: [:notice_to_unpaying_users, :progress_status_update, :add_event_user, :add_event_user_fee, :add_event_user_create, :change_restaurant, :change_restaurant_update, :send_remind]
  before_action :ensure_admin?, only: [:show, :edit, :update, :destroy]
  before_action :ensure_admin_event_id?, only: [:progress_status_update, :add_event_user, :add_event_user_fee, :add_event_user_create, :notice_to_unpaying_users, :change_restaurant]
  before_action :set_day_of_the_week, only: [:show, :edit, :change_restaurant, :add_event_user_fee, :add_event_user]

  # 以下、includesはN+1問題の解消
  # 以下、with_deletedは欠席者も含むための記述（gem paranoia）

  def index
    # redirectされるタブをparamsで条件分岐
    case params[:room].to_i
    when 2
      @room = 2
    when 3
      @room = 3
    else
      @room = 1
    end
    # ================タブ１===============
    # 今日のノミカイ
    # 【★幹事＝user_id使用】
    from = Time.current.beginning_of_day
    to = Time.current.end_of_day
    @today_event = Event.find_by(date: from..to, user_id: current_user.id)
    # 曜日
    day_of_the_week(@today_event) if @today_event.present?
    # ToDoリスト
    @todo = Todo.new
    @todos = Todo.where(user_id: current_user.id)
    # ================タブ２===============
    # 全てのノミカイ
    # 【★幹事＝user_id使用】
    @status0_events = Event.where(progress_status: 0, user_id: current_user.id)
    @status1_events = Event.where(progress_status: 1, user_id: current_user.id)
    @status2_events = Event.where(progress_status: 2, user_id: current_user.id)
    # 全てのノミカイ（カレンダー）
    @events = Event.where(user_id: current_user.id)

    # ================タブ３===============
    # 集金中のノミカイ
    @events = Event.where(user_id: current_user.id)
    # 集金中のノミカイ参加メンバー
    # 【★幹事＝user_id使用】
    # 「current_userが幹事のノミカイで、未支払いの飲み会があるUser」の配列
    @users = User.joins(:event_users).where(event_users: { fee_status: false }).joins(:events).where(events: { user_id: current_user.id }).distinct
   end

  def show
    # redirectされるタブをparamsで条件分岐
    case params[:room].to_i
    when 2
      @room = 2
    when 3
      @room = 3
    when 4
      @room = 4
    else
      @room = 1
    end
    # ================タブ２===============
    # 当該飲み会の参加メンバー全員（欠席者含む）
    @event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id)
    # ================タブ３===============
    # 当該飲み会に関して未払いのメンバー（欠席者含む）
    @unpaying_event_users = EventUser.with_deleted.includes([:user]).where(event_id: @event.id, fee_status: false)
  end

  # show(タブ１）：ノミカイ基本情報の編集ページ
  def edit
  end

  # show(タブ１）：ノミカイ基本情報の更新
  def update
    if @event.update(event_params)
      flash[:success] = "ノミカイ概要を更新しました"
      redirect_to admin_event_path(@event)
    else
      flash[:danger] = "ノミカイ名を時間は入力必須です"
      redirect_to edit_admin_event_path(@event)
    end
  end

  # show(タブ１）：ノミカイ基本情報の削除
  def destroy
    @event.destroy
    # dependent: :destroyをモデルに記載したため、紐づくnotificationsは@event.destroyで削除されるがevent_userは論理削除が働いてしまうため、物理削除が必要。
    event_users = EventUser.with_deleted.where(event_id: @event.id)
    event_users.each do |event_user|
      event_user.really_destroy!
    end
    redirect_to admin_events_path
  end

  # show(タブ１）：ノミカイ進捗ステータスの更新
  def progress_status_update
    @event.update(event_params)
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  # show(タブ１）：リマインドメール・通知
  def send_remind
    # 出席者全員に通知を送る
    @event_users = EventUser.where(event_id: @event.id)
    @event_users.each do |event_user|
      @event.create_notification_remind_event(current_user, event_user.user_id)
    end
    RemindMailer.remind_mail(@event).deliver_now
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  # show(タブ２）：参加メンバーの追加編集ページ
  def add_event_user
    members = current_user.matchers
    @unselected_members = members - User.joins(:event_users).where(event_users: { event_id: @event.id })
  end

  # show(タブ２）：参加メンバーの追加後会費設定編集ページ
  def add_event_user_fee
    @event_user_ids = session[:event_user_ids] = params[:event_user][:ids].drop(1)
    redirect_to(admin_event_path(@event, room: 2)) && return if params[:back]
    # メンバーを選択せずNextボタンを押した場合進めない
    if @event_user_ids.blank?
      flash[:danger] = "メンバーを選択してください"
      redirect_to admin_add_event_user_path(@event)
    end
  end

  # show(タブ２）：参加メンバーの追加更新
  def add_event_user_create
    @event_user_ids = session[:event_user_ids]
    # 下記、Backボタン押した場合renderするための記述
    members = current_user.matchers
    @unselected_members = members - User.joins(:event_users).where(event_users: { event_id: @event.id })
    render(:add_event_user) && return if params[:back]
    # 確定ボタン押した場合
    event_user_ids = session[:event_user_ids]
    event_user_fees = session[:fees] = params[:fees]
    add_event_users = event_user_ids.zip(event_user_fees).map do |event_user_id, event_user_fee|
      # 下記記述がないと会費を入力しなかった場合EventUserが保存されない
      event_user_fee = 0 if event_user_fee.empty?
      EventUser.create(user_id: event_user_id, event_id: @event.id, fee: event_user_fee)
    end

    # ノミカイ招待メール
    if params[:mail]
      InvitationMailer.invitation_mail_for_add_participant(@event, add_event_users).deliver_now
    end
    # 通知機能
    add_event_users.each do |add_event_user|
      @event.create_notification_new_event(current_user, add_event_user.user_id)
    end
    flash[:success] = "参加メンバーを追加しました"
    redirect_to admin_event_path(@event, room: 2)
  end

  # show(タブ３）：未払いの参加メンバー全員に通知を送る
  def notice_to_unpaying_users
    @unpaying_event_users = EventUser.with_deleted.where(event_id: @event.id, fee_status: false)
    @unpaying_event_users.each do |unpaying_event_user|
      @event.create_notification_require_fee(current_user, unpaying_event_user.user_id)
      # メール通知
      UnpaidMailer.unpaid_mail(unpaying_event_user).deliver_now
    end
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  # show(タブ４）：お店の変更ページ
  # form内にsubmitボタンが複数ある。このアクション自体はGET（PATCHでも記述を変えれば問題はない）
  def change_restaurant
    # ぐるなびAPI
    api_key = Rails.application.credentials.grunavi[:api_key]
    url = 'https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid='
    url << api_key
    if params[:freeword]
      word = params[:freeword]
      url << "&name=" << word
    end
    url = URI.encode(url)
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    @rests = result["rest"]
    restaurant = eval("#{params[:restaurant]}")
    if params[:change]
      # お店を選択していない場合は同じページに戻る
      if params[:restaurant]
        @restaurant = Restaurant.create(
          user_id: current_user.id,
          name: restaurant["name"],
          address: restaurant["address"],
          access: restaurant["access"]["line"] + " " + restaurant["access"]["station"] + restaurant["access"]["station_exit"] + " 徒歩" + restaurant["access"]["walk"] + "分",
          url: restaurant["url"],
          shop_image: restaurant["image_url"]["shop_image1"],
          tel: restaurant["tel"],
          opentime: restaurant["opentime"],
          holiday: restaurant["holiday"]
        )
        @event.update(restaurant_id: @restaurant.id)
        flash[:success] = "お店を変更しました"
        redirect_to admin_event_path(@event, room: 4)
      else
        flash.now[:danger] = "お店を選択してください"
        render :change_restaurant
      end
    end
    redirect_to admin_event_path(@event, room: 4) if params[:back]
  end

  # 新規作成(1)：基本情報入力ページ表示（GET)
  def step1
    @event = Event.new
  end

  # 新規作成(2)：step1更新＋お店検索ページ表示＋正しく選択されていればstep3へリダイレクト（POST：viewあり)
  # form内にsubmitボタンが複数ある。リダイレクトのためstep3はGET、createされる
  def step2
    @event = Event.new(event_params)
    if @event.invalid?
      flash.now[:danger] = "必要情報を入力してください"
      render :step1
    end
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    # ぐるなびAPI
    api_key = Rails.application.credentials.grunavi[:api_key]
    url = 'https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid='
    url << api_key
    if params[:freeword]
      word = params[:freeword]
      url << "&name=" << word
    end
    url = URI.encode(url)
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    @rests = result["rest"]
    restaurant = eval("#{params[:restaurant]}")
    if params[:next]
      # お店を選択していない場合は同じページに戻る
      if params[:restaurant]
        session[:name] = restaurant["name"]
        session[:address] = restaurant["address"]
        session[:access] = restaurant["access"]["line"] + " " + restaurant["access"]["station"] + restaurant["access"]["station_exit"] + " 徒歩" + restaurant["access"]["walk"] + "分"
        session[:url] = restaurant["url"]
        session[:tel] = restaurant["tel"]
        session[:shop_image] = restaurant["image_url"]["shop_image1"]
        session[:opentime] = restaurant["opentime"]
        session[:holiday] = restaurant["holiday"]
        # step3をgetにしたためf.hiddenで渡せないので redirect_toのオプションでparamsを送る
        redirect_to admin_step3_path(event: event_params)
      else
        flash.now[:danger] = "お店を選択してください"
        render :step2
      end
    end
    render(:step1) && return if params[:back]
  end

  # 新規作成(3)：メンバー選択ページの表示（GET)
  def step3
    @members = current_user.matchers
    @event = Event.new(event_params)
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    render :step2 if @event.invalid?
  end

  # 新規作成(4)：step3のparamsの値をsessionに代入＋会費設定ページの表示（POST：viewあり)
  def step4
    @event = Event.new(event_params)
    # # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    @event_user_ids = session[:event_user_ids] = params[:event_user][:ids].drop(1)
    render(:step2) && return if params[:back]
    if @event_user_ids.blank?
      @members = current_user.matchers
      flash.now[:danger] = "参加者を１人以上選択してください"
      render(:step3)
    end
  end

  # 新規作成(5)：step4のparamsの値をsessionに代入＋step4のparamsの値をsessionに代入＋確認ページの表示（POST：viewあり)
  def confirm
    @event = Event.new(event_params)
    # Backボタンで戻ってきた時renderでstep3に戻るので下記追記が必要
    @members = current_user.matchers
    # カンジ
    # 【★幹事＝user_id使用】
    @event.user_id = current_user.id
    # 曜日
    day_of_the_week(@event)
    @restautant_name = session[:name]
    # 選択されたメンバーのIDの配列
    @event_user_ids = session[:event_user_ids]
    @admin_fee = session[:admin_fee] = params[:admin_fee]
    @event_user_fees = session[:fees] = params[:fees]
    render(:step3) && return if params[:back]
  end

  # 新規作成(6)：sessionからrestaurant,event,event_userを新規作成（POST：viewなし)
  def create
    @event = Event.new(event_params)
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
    render(:step4) && return if params[:back]
    render(:confirm) && return if !@event.save
    # drop(1)は、sessionの配列の要素１つ目に""(nil)が渡されてしまい参加メンバーの一覧表示ができないため、１つ目を除いている
    event_user_ids = session[:event_user_ids]
    event_user_fees = session[:fees]
    event_user_ids.zip(event_user_fees).each do |event_user_id, event_user_fee|
      # 下記記述がないと会費を入力しなかった場合EventUserが保存されない
      event_user_fee = 0 if event_user_fee.empty?
      EventUser.create(user_id: event_user_id, event_id: @event.id, fee: event_user_fee)
    end
    # 自分（カンジ）のevent_userも作成。else以降がないと会費を入力しなかった場合EventUserが保存されない
    if session[:admin_fee].present?
      EventUser.create(user_id: current_user.id, event_id: @event.id, fee: session[:admin_fee])
    else
      EventUser.create(user_id: current_user.id, event_id: @event.id, fee: 0)
    end
    if params[:mail]
      # ノミカイ招待メール
      InvitationMailer.invitation_mail(@event).deliver_now
    end
    # 通知機能
    event_users = EventUser.where(event_id: @event.id)
    event_users.each do |event_user|
      @event.create_notification_new_event(current_user, event_user.user_id)
    end
    redirect_to admin_event_path(@event)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_event_by_event_id
    @event = Event.find(params[:event_id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :begin_time, :finish_time, :memo, :progress_status)
  end

  # 曜日
  def day_of_the_week(event)
    @day_of_the_week = %w(日 月 火 水 木 金 土)[event.date.wday]
  end

  # 曜日
  def set_day_of_the_week
    @day_of_the_week = %w(日 月 火 水 木 金 土)[@event.date.wday]
  end

  # 自分がカンジでないノミカイはアクセス(URL検索含む）できないようにする
  def ensure_admin?
    @event = Event.find(params[:id])
    redirect_back(fallback_location: root_path) unless @event.user_id == current_user.id
  end

  def ensure_admin_event_id?
    @event = Event.find(params[:event_id])
    redirect_back(fallback_location: root_path) unless @event.user_id == current_user.id
  end
end
