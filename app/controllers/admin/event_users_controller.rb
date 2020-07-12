class Admin::EventUsersController < ApplicationController
  # 欠席の場合、論理削除
  def participate_status_update
    event_user = EventUser.with_deleted.find_by(event_id: params[:event_user][:event_id],user_id: params[:event_user][:user_id])
    event_user.update(event_user_params)
    flash[:success] = "参加ステータスを”欠席”に変更しました"
    redirect_back(fallback_location: root_path)
  end

  # 参加メンバーことの会費変更（欠席者含む）
  def fee_update
    event_user = EventUser.with_deleted.find_by(event_id: params[:event_user][:event_id],user_id: params[:event_user][:user_id])
    event_user.update(event_user_params)
    flash[:success] = "会費を更新しました"
    redirect_back(fallback_location: root_path)
  end

  # 参加メンバーことの会費ステータス変更（欠席者含む）
  def fee_status_update
    event_user = EventUser.with_deleted.find_by(event_id: params[:event_user][:event_id],user_id: params[:event_user][:user_id])
    event_user.update(event_user_params)
    flash[:success] = "支払いステータスを更新しました"
    redirect_back(fallback_location: root_path)
  end

  private
  def event_user_params
    params.require(:event_user).permit(:fee, :fee_status,:deleted_at)
  end
end
