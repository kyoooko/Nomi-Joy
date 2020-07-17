class Public::RelationshipsController < ApplicationController
  def create
    follow = current_user.active_relationships.build(follower_id: params[:user_id])
    # 通知機能（userはフォローされた人）
    user = User.find(params[:user_id])
    if follow.save
      flash[:success] = 'ユーザーをフォローしました'
      # 通知機能
      user.create_notification_followed_by(current_user)
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = 'ユーザーのフォローに失敗しました'
      redirect_to root_path
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    if follow.destroy
      flash[:success] = 'ユーザーのフォローを解除しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
      redirect_to root_path
    end
  end
end
