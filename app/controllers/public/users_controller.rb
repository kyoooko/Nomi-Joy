class Public::UsersController < ApplicationController
  # current_user以外がedit,updateできないようにする（URL直打ちも不可）
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users=User.all
    # マッチングしたユーザー（＝「メンバー」となる。matchersはモデルに定義したインスタンスメソッド）
    @members = current_user.matchers
    # 申請中のユーザー
    @followings=current_user.followings - current_user.matchers
    # 承認依頼のきているユーザー
    @followers=current_user.followers - current_user.matchers
    # 検索機能
    @find_users = User.search(params[:word])
  end

  def show
    @members = current_user.matchers
  end

  def edit
    
  end

  def update
    if @user.update(user_params)
      flash[:user_update] = "マイページの情報が更新されました"
      redirect_to user_path(current_user.id)
    else
      flash[:user_update] = "正しい情報を入力してください"
      render :edit
    end
  end




  private
  def user_params
    params.require(:user).permit(:name, :belongs, :position, :email, :nomi_joy,:nearest_station, :can_drink, :favolite, :unfavolite, :introduction, :image)
  end

  def ensure_correct_user
    @user=User.find(params[:id])
    if current_user.id != @user.id
      redirect_back(fallback_location: root_path)
    end
  end

  def set_user
    @user=User.find(params[:id])
  end
end
