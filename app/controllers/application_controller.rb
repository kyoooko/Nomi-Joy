class ApplicationController < ActionController::Base
    # 登録時の登録情報追加（deviseのデフォルトはメール、パス）
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :nomi_joy_id])
    end
    # ログイン後マイページに返す
    def after_sign_in_path_for(resource)
      events_path
    end
end
