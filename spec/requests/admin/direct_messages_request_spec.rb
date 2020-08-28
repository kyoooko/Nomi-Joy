require 'rails_helper'

RSpec.describe "Admin::DirectMessages", type: :request do
  # ユーザー１はログインユーザー。
  # ユーザー２は非ログインユーザー。ユーザー１はユーザー２とマッチング(相互フォロー)している。
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:follow_1to2) { Relationship.create(following_id: user_1.id, follower_id: user_2.id) }
  let!(:follow_2to1) { Relationship.create(following_id: user_2.id, follower_id: user_1.id) }
  let!(:room) { Room.create }
  let!(:entry_1at1) { Entry.create(user_id: user_1.id, room_id: room.id) }
  let!(:entry_2at1) { Entry.create(user_id: user_2.id, room_id: room.id) }
  let(:req_params) { { direct_message: { user_id: user_1.id, room_id: room.id, message: "hoge" } } }

  describe "DMを送信(POST #create)" do
    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      it "非同期にてリクエストが成功すること" do
        post admin_direct_messages_path, params: req_params, xhr: true
        expect(response).to have_http_status "200"
        # 下記のように書くことも可能
        # post direct_messages_path(req_params), xhr: true
      end
      it "非同期にてメッセージが正常に保存されていること" do
        post admin_direct_messages_path, params: req_params, xhr: true
        expect(response.body).to include 'hoge'
      end
    end
  end
end
