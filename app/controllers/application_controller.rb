class ApplicationController < ActionController::Base
  # 登録時の登録情報追加（deviseのデフォルトはメール、パス）
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ログインしてなかったらログイン画面に返す（URL直打ちも不可。deviseのメソッド。homesコントローラーのみスキップ記述。）
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :nomi_joy_id])
  end

  # ログイン後マイページに返す
  def after_sign_in_path_for(resource)
    events_path
  end
end
