require 'rails_helper'

RSpec.describe "Public::Notifications", type: :request do
  # ユーザー１はログインユーザー
  let!(:user_1) { create(:user) }
  # ユーザー２はログインユーザーではない
  let!(:user_2) { create(:user) }

  describe "通知ページ(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get notifications_path 
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user_1
      end
      it "リクエストが成功すること" do
        get notifications_path 
        expect(response).to have_http_status "200"
      end
    end
  end

  # フォロー（ユーザー１がユーザー２をフォローする）
  describe "ユーザー１がユーザー２をフォローした時(POST #create)" do
    context "ログインしている場合" do
      before do
        sign_in user_1
      end
      
      it "通知が作成されること" do
        post user_relationships_path(user_2.id), xhr: true
        # binding.pry
        expect(Notification.find_by(visitor_id: user_1.id, visited_id: user_2.id, action: "follow")).to be_truthy
      end
      # 下記のようにも書ける
      # it "通知が作成されること" do
      #   expect do
      #     post user_relationships_path(user_2.id), xhr: true
      #   end.to change(Notification, :count).by(1)
      # end
    end
  end

  # DM送信（ユーザー１がユーザー２にDMを送る）
  let!(:follow_1to2) { Relationship.create(following_id: user_1.id, follower_id: user_2.id) }
  let!(:follow_2to1) { Relationship.create(following_id: user_2.id, follower_id: user_1.id) }
  let!(:room) { Room.create }
  let!(:entry_1at1) { Entry.create(user_id: user_1.id, room_id: room.id) }
  let!(:entry_2at1) { Entry.create(user_id: user_2.id, room_id: room.id) }
  let (:req_params) { { direct_message: { room_id: room.id, message: "hoge" } } }
  
  describe "DMを送信(POST #create)した時" do
    context "ログインしている場合" do
      before do
        sign_in user_1
      end
      it "通知が作成されること" do
        # rooms/showでsession[:user_id] = @user.idをしているのでrooms/showを経ないとsessionに値が入らない
        get room_path user_2.id
        post direct_messages_path, params: req_params, xhr: true
        expect(Notification.find_by(visitor_id: user_1.id, visited_id: user_2.id, action: "dm", direct_message_id:1)).to be_truthy
      end
    end
  end
end
