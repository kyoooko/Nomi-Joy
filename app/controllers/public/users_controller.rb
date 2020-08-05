class Public::UsersController < ApplicationController
  # current_user以外がedit,updateできないようにする（URL直打ちも不可）
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_guest, only: :update

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
    # 対応中
    # 参照先のS3オブジェクトURLを作成
    # リサイズ
    @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
  end

  def edit
    @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
  end

  def update
    if @user.update(user_params)
      flash[:success] = "マイページの情報が更新されました"
      redirect_to user_path(current_user.id)
    else
      flash[:danger] = "正しい情報を入力してください"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :belongs, :position, :email, :nomi_joy, :nearest_station, :can_drink, :favolite, :unfavolite, :introduction, :image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if current_user.id != @user.id
      redirect_back(fallback_location: root_path)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_guest
    if current_user.email == 'test1@test.co.jp'
      flash[:danger] = "ゲストユーザーのため編集できません"
      redirect_to edit_user_path(current_user)
    end
  end
end
