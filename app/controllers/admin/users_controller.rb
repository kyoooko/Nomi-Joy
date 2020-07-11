class Admin::UsersController < ApplicationController
  def show
    @user=User.find(params[:id])
  end

  def destroy
  end
end
