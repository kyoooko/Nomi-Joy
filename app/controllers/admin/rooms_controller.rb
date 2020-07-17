class Admin::RoomsController < ApplicationController
  def index
    @members = current_user.matchers
  end

  def show
    # 相手A
    @user = User.find(params[:id])
    # 自分(current_user)の中間テーブル(entry)を全て取り出しpluckメソッドで:room_idを配列にしたものがroom。この時点では相手A以外の人との中間テーブル(entry)も含まれる
    rooms = current_user.entries.pluck(:room_id)
    # user_id:が相手Aでroom_idが roomsのもの（自分との部屋）を取り出す（これが自分と相手Aとの部屋）
    entry = Entry.find_by(user_id: @user.id, room_id: rooms)
    if entry.nil?
      # 自分と相手Aとの部屋がまだなければ新たに作成し保存。同時に中間テーブルを自分用と相手A用にそれぞれ作る
      @room = Room.create
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    # 自分と相手Aとの部屋が既にあれば@roomに既にあるroomを代入
    else
      @room = entry.room
    end
    # dmを新規作成
    @dm = DirectMessage.new(room_id: @room.id)
    # 自分と相手Aとの部屋のdmの全て
    @dms = @room.direct_messages
    # 通知機能
    session[:user_id] =  @user.id
  end
end
