class Public::RelationshipsController < ApplicationController
  def create
    follow = current_user.active_relationships.build(follower_id: params[:user_id])
    # 通知機能（userはフォローされた人）
    user = User.find(params[:user_id])
    if follow.save
      flash[:success] = 'ユーザーへメンバー承認依頼を送りました'
      # 通知機能
      user.create_notification_followed_by(current_user)
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    if follow.destroy
      flash[:success] = 'ユーザーへのメンバー承認依頼を取り消しました'
      redirect_back(fallback_location: root_path)
    end
  end
end
