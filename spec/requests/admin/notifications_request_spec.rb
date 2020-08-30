require 'rails_helper'

RSpec.describe "Admin::Notifications", type: :request do
  # ユーザー１はログインユーザー
  let!(:user_1) { create(:user) }
  # ユーザー２はログインユーザーではない
  let!(:user_2) { create(:user) }

  let (:req_params) { { direct_message: { room_id: room.id, message: "hoge" } } }
  let!(:entry_2at1) { Entry.create(user_id: user_2.id, room_id: room.id) }
  let!(:entry_1at1) { Entry.create(user_id: user_1.id, room_id: room.id) }
  let!(:room) { Room.create }
  let!(:follow_2to1) { Relationship.create(following_id: user_2.id, follower_id: user_1.id) }
  let!(:follow_1to2) { Relationship.create(following_id: user_1.id, follower_id: user_2.id) }

  describe "通知ページ(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_notifications_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      it "リクエストが成功すること" do
        get admin_notifications_path
        expect(response).to have_http_status "200"
      end
    end
  end

  # DM送信（ユーザー１がユーザー２にDMを送る）

  describe "通知作成(POST #create)" do
    context "ユーザー１からユーザー２へDMを送信(POST #create)した時" do
      before do
        sign_in user_1
        # rooms/showでsession[:user_id] = @user.idをしているのでrooms/showを経ないとsessionに値が入らない
        get admin_room_path user_2.id
        post admin_direct_messages_path, params: req_params, xhr: true
      end

      it "ユーザー１からユーザー２への通知が作成されること" do
        # direct_message_idは1とかぎらない。今回のテストではそもそもDMひとつしか作っていないのでdirect_message_id指定しなくても問題ない
        expect(Notification.find_by(visitor_id: user_1.id, visited_id: user_2.id, action: "dm")).to be_truthy
      end
    end
  end

  # ノミカイ招待（ユーザー１がユーザー２を招待）

  # ノミカイリマインド（ユーザー１がユーザー２を招待）

  # 会費支払い確認リマインド（ユーザー１がユーザー２へリマインド）

  # 会費領収リマインド（ユーザー１がユーザー２へリマインド）
end
