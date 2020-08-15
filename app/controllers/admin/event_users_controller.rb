class Admin::EventUsersController < ApplicationController
  before_action :set_event_user, only: [:fee_update, :fee_status_update]

  # 欠席の場合、論理削除
  def participate_status_update
    @event_user = EventUser.with_deleted.find_by(event_id: params[:event_id], user_id: params[:user_id])
    @event_user.update(deleted_at: params[:deleted_at])
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  # 参加メンバーことの会費変更（欠席者含む）
  def fee_update
    # 下記のようにnullの場合を書かないと、入力だnillでもデータベースは更新されない
    if params[:event_user][:fee].present?
      @event_user.update(event_user_params)
    else
      @event_user.update(fee: "")
    end
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  # 参加メンバーことの会費ステータス変更（欠席者含む）
  def fee_status_update
    @event_user.update(event_user_params)
    PaidMailer.paid_mail(@event_user).deliver_now
    # 非同期のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  private
  def set_event_user
    @event_user = EventUser.with_deleted.find_by(event_id: params[:event_user][:event_id], user_id: params[:event_user][:user_id])
  end

  def event_user_params
    params.require(:event_user).permit(:fee, :fee_status, :deleted_at)
  end
end
