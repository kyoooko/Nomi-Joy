class Public::UsersController < ApplicationController
  # current_user以外がedit,updateできないようにする（URL直打ちも不可）
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_guest, only: :update
  before_action :set_image_url, only: [:show, :edit]
  before_action :couldnt_show_unfollowd_user, only: [:show]

  def index
    # ================タブ１===============
    # マッチングしたユーザー（＝「メンバー」となる。matchersはモデルに定義したインスタンスメソッド）
    @members = current_user.matchers
    # ================タブ2===============
    # 検索機能
    @find_users = User.search(params[:word])
    # [備考]コントローラーで下記を定義することは不可
    # @find_users.each { |find_user| @find_user = find_user }
    # 申請中のユーザー
    @followings = current_user.followings - current_user.matchers
    # 承認依頼のきているユーザー
    @followers = current_user.followers - current_user.matchers
  end

  def show
    @members = current_user.matchers
  end

  def edit
  end

  def update
    if @user.update(user_params)
      sleep(3) # S3への画像反映のタイムラグを考慮して3秒待機
      flash[:success] = "マイページの情報が更新されました"
      redirect_to user_path(current_user.id)
    else
      if @user.image.present?
        @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
      end
      flash[:danger] = "正しい情報を入力してください"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :belongs, :position, :email, :nomi_joy_id, :nearest_station, :can_drink, :favolite, :unfavolite, :introduction, :image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if current_user.id != @user.id
      redirect_back(fallback_location: root_path)
    end
  end

  # フォローされていないユーザーの詳細ページは閲覧できない（URL検索含む）
  def couldnt_show_unfollowd_user
    unfollowd_users = User.all - current_user.followers
    user = User.find(params[:id])
    unless user == current_user
      redirect_back(fallback_location: root_path) if unfollowd_users.any? { |unfollowd_user| unfollowd_user == user }
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # 参照先のS3オブジェクト（リサイズ済み）URLを作成
  def set_image_url
    @user = User.find(params[:id])
    if @user.image.present?
      @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
    end
  end

  def check_guest
    if current_user.email == 'test1@test.co.jp'
      flash[:danger] = "テストユーザーのため編集できません"
      redirect_to user_path(current_user)
    end
  end
end
