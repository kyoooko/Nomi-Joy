require 'rails_helper'

RSpec.describe "Public::Events", type: :request do
  let!(:user) { create(:user) }
  let!(:restaurant) { create(:restaurant, user_id: user.id) }
  let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user.id) }
  let!(:event_user) { create(:event_user, user_id: user.id, event_id: event.id) }

  describe "トップページを表示(GET #index)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get events_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get events_path
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "ノミカイ詳細ページを表示(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get event_path event.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get event_path event.id
        expect(response).to have_http_status "200"
      end
    end
  end
end
