class Public::DirectMessagesController < ApplicationController
  def create
    @dm = current_user.direct_messages.new(dm_params)
    @dm.save
  end

  private
  def dm_params
    params.require(:direct_message).permit(:message, :room_id)
  end
end
