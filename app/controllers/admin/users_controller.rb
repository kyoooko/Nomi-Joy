class Admin::UsersController < ApplicationController
  before_action :couldnt_show_unfollowd_user, only: [:show]

  def show
    @user = User.find(params[:id])
    # 参照先のS3オブジェクトURLを作成
    @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
  end

  private

  def couldnt_show_unfollowd_user
    unfollowd_users = User.all - current_user.followers
    user = User.find(params[:id])
    unless user == current_user
      redirect_back(fallback_location: root_path) if unfollowd_users.any? { |unfollowd_user| unfollowd_user == user }
    end
  end
end
