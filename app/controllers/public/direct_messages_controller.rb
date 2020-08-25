class Public::DirectMessagesController < ApplicationController
  def create
    # JSファイルに渡しているため「@」は必要
    @dm = current_user.direct_messages.new(dm_params)
    if @dm.save
      # 通知機能(session[:user_id]はDM相手のid)
      @dm.create_notification_dm(current_user, session[:user_id])
      # 非同期のためredirectなし
      # binding.pry
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def dm_params
    params.require(:direct_message).permit(:message, :room_id)
  end
end
