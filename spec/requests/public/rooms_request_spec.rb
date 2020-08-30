require 'rails_helper'

RSpec.describe "Public::Rooms", type: :request do
  # ユーザー１はログインユーザー。
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:user_3) { create(:user) }
  let!(:entry_2at1) { Entry.create(user_id: user_2.id, room_id: room.id) }
  let!(:entry_1at1) { Entry.create(user_id: user_1.id, room_id: room.id) }
  let!(:room) { Room.create }
  let!(:follow_2to1) { Relationship.create(following_id: user_2.id, follower_id: user_1.id) }
  let!(:follow_1to2) { Relationship.create(following_id: user_1.id, follower_id: user_2.id) }

  describe "DMできるメンバー一覧ページ(GET #index)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get rooms_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      it "リクエストが成功すること" do
        get rooms_path
        expect(response).to have_http_status "200"
      end
    end
  end

  # ユーザー２は非ログインユーザー。ユーザー１はユーザー２とマッチング(相互フォロー)している。
  # ユーザー３は非ログインユーザー。ユーザー１はユーザー３とはマッチングしていない
  describe "DMページ(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get room_path user_2.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      context "マッチングしているユーザーとのDMページの場合" do
        it "リクエストが成功すること" do
          get room_path user_2.id
          expect(response).to have_http_status "200"
        end
      end

      context "マッチングしていないユーザーとのDMページの場合" do
        it "リクエストが失敗すること" do
          get room_path user_3.id
          expect(response).to have_http_status "302"
        end
        it "ユーザー一覧ページへリダイレクトすること" do
          get room_path user_3.id
          expect(response).to redirect_to users_path
        end
      end
    end
  end
end
