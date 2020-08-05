class Admin::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # 参照先のS3オブジェクトURLを作成
    @image_url = "https://dmm-cloud-lesson10-image-files-resize.s3-ap-northeast-1.amazonaws.com/store/" + @user.image_id + "-thumbnail."
  end
end
