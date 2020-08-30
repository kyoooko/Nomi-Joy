require 'rails_helper'

RSpec.describe "Public::Users", type: :request do
  let(:user) { create(:user) }
  # ログインしていないユーザー
  let(:other_user) { create(:user) }
  # フォローされていないユーザー
  let(:unfollowed_user) { create(:user) }

  describe "ユーザー一覧ページを表示(GET #index)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get users_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      it "リクエストが成功すること" do
        sign_in user
        get users_path
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "ユーザー詳細ページを表示(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "本人のページの場合" do
        it "リクエストが成功すること" do
          get user_path user.id
          expect(response).to have_http_status "200"
        end
      end

      context "フォローされていないユーザーのページの場合" do
        it "トップ画面にリダイレクトされること" do
          get user_path unfollowed_user.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ユーザー編集ページを表示(GET #edit)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get edit_user_path user.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "本人の場合" do
        it "リクエストが成功すること" do
          sign_in user
          get edit_user_path user.id
          expect(response).to have_http_status "200"
        end
      end

      context "他のユーザーの場合" do
        it "ログイン前トップページへリダイレクトすること" do
          sign_in other_user
          get edit_user_path user.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ユーザーの編集を更新(PUT #update)" do
    let(:user_params) { { name: "編集後ユーザー名" } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        put user_path user.id, user: user_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        put user_path user.id, user: user_params
        expect(response.status).to eq 302
      end
      it "更新が成功すること" do
        put user_path user.id, user: user_params
        expect(user.reload.name).to eq "編集後ユーザー名"
      end
      it "ユーザー編集ページへリダイレクトすること" do
        put user_path user.id, user: user_params
        expect(response).to redirect_to user_path user.id
      end
    end

    context "他のユーザーの場合" do
      it "ログイン前トップページへリダイレクトすること" do
        sign_in other_user
        patch user_path user.id, user: user_params
        expect(response).to redirect_to root_path
      end
    end
  end

  # ========================================================

  describe "ログインページ(GET /sign_in)が" do
    it '正しく表示されること' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "ログイン(POST /sign_in)に" do
    # 存在する(DBに登録されている)ユーザー
    let (:authenticated_user) { create(:user) }
    # 存在しない(DBに登録されていない)ユーザー
    let (:unauthenticated_user) { build(:user) }
    let (:req_params) { { user: { email: user.email, password: user.password } } }

    context '存在するユーザでログインすると' do
      let (:user) { authenticated_user }

      it '成功すること' do
        post user_session_path, params: req_params
        expect(response).to have_http_status(302)
      end
      it 'ログイン後トップページにリダイレクトされること' do
        post user_session_path, params: req_params
        expect(response).to redirect_to events_path
      end
    end

    context '存在しないユーザでログインすると' do
      let (:user) { unauthenticated_user }

      it '失敗すること' do
        post user_session_path, params: req_params
        expect(response).to have_http_status(200)
      end
      it 'エラー（フラッシュ）メッセージが表示されること' do
        post user_session_path, params: req_params
        expect(response.body).to include 'メールアドレスかパスワードが違います。'
      end
    end
  end

  describe "新規登録ページ(GET /sign_up)が" do
    it "正しく表示されること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "新規登録(POST /sign_up)で" do
    let (:req_params) { { user: { name: '新規ユーザー', email: 'test@test.co.jp', nomi_joy_id: 'nomijoy', password: 'password', password_confirmation: 'password' } } }

    context '全て正しい情報を入力した場合' do
      it '登録に成功すること' do
        post user_registration_path, params: req_params
        expect(response).to have_http_status(302)
      end
      it 'トップページにリダイレクトされること' do
        post user_registration_path, params: req_params
        expect(response).to redirect_to events_path
      end
    end
  end
end
