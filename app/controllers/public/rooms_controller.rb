class Public::RoomsController < ApplicationController
  def index
    @members = current_user.matchers
    # 後で対応要
    # @room=Room.find(praams[:id])
  end

  def show
    # 相手A
    @user = User.find(params[:id])
    # 自分(current_user)の中間テーブル(entry)を全て取り出しpluckメソッドで:room_idを配列にしたものがroom。この時点では相手A以外の人との中間テーブル(entry)も含まれる
    rooms = current_user.entries.pluck(:room_id)
    # user_id:が相手Aでroom_idが roomsのもの（自分との部屋）を取り出す（これが自分と相手Aとの部屋）
    # 【対応要】調べる
    entry = Entry.find_by(user_id: @user.id, room_id: rooms)

    if entry.nil?
      # 自分と相手Aとの部屋がまだなければ新たに作成し保存。同時に中間テーブルを自分用と相手A用にそれぞれ作る
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    # 自分と相手Aとの部屋が既にあれば@roomに既にあるroom.idを代入
    else
      @room = user_rooms.room
    end
    # 【対応要】これいる？
    # この部屋でchatを新規作成
    @chat = Chat.new(room_id: @room.id)
    # 自分と相手Aとの部屋のchatの全て
    @chats = @room.chats.all
  end

  def create
    # 自分が新規投稿したchatを保存
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
