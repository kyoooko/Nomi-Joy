class Admin::EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update,:destroy]

  def index
    # 下記集金中メンバーに変更要
    @users = User.all
    # @today_event=
  end

  def show
    # 当該飲み会に関して未払いのメンバー（欠席者含む）
    @unpaid_members = EventUser.with_deleted.where(event_id: @event.id, fee_status: false)
    #  当該飲み会の参加メンバー全員（欠席者含む）
    @event_users = EventUser.with_deleted.where(event_id: @event.id)
  end

  def edit
  end

  def create
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
    # @event=Event.find(params[:id])
  end

  def step2
  end

  def confirm
  end

  private
  def set_event
    @event=Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :start_time, :end_time, :memo, :progress_status, :fee_status)
  end
  # def event_user_params
  #   params.require(:event_user).permit(:fee, :fee_status)
  # end
end
