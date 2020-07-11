class Admin::EventsController < ApplicationController
  def index
    #  @user=User.find(params[:id])
    # 下記集金中メンバーに変更要
    @members = current_user.matchers
  end

  def show
    # @user=User.find(params[:id])
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def progress_status_update
  end

  def fee_status_update
  end

  def confirm_plan_remind
  end

  def send_plan_remind
  end

  def step1
  end

  def step2
  end

  def confirm
  end
end
