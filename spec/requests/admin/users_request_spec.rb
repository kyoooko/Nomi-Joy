require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:user) { create(:user) }
  # ログインしていないユーザー
  let(:other_user) { create(:user) }
  # フォローされていないユーザー
  let(:unfollowed_user) { create(:user) }

  describe "ユーザー詳細ページを表示(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "本人のページの場合" do
        it "リクエストが成功すること" do
          get admin_user_path user.id
          expect(response).to have_http_status "200"
        end
      end

      context "フォローされていないユーザーのページの場合" do
        it "トップ画面にリダイレクトされること" do
          get admin_user_path unfollowed_user.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
