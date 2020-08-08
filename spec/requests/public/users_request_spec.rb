require 'rails_helper'

RSpec.describe "Public::Users", type: :request do

  describe "ログインページ(GET /sessions/new)が" do
    it '正しく表示されること' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "ログイン(POST /sessions)に" do
    # 存在する(DBに登録されている)ユーザー
    let (:authunenticated_user) { create(:user) }
    # 存在しない(DBに登録されていない)ユーザー
    let (:unauthunenticated_user) { build(:user) }
    let (:req_params) { { session_form: { email: user.email, password: user.password } } }

    describe '存在するユーザでログインすると' do
      let (:user) { authunenticated_user }
      it '成功すること' do
        post user_session_path, params: req_params
        expect(response).to have_http_status(200)
      end
      # *****通らない*******************************************:
      it 'ログイン後トップページにリダイレクトされること' do
        post user_session_path, params: req_params
        expect(response).to redirect_to events_path
      end
      # *****************************************************:
    end

    describe '存在しないユーザでログインすると' do
      let (:user) { unauthunenticated_user }
      # *****通らない*******************************************:
      it '失敗すること' do
        post user_session_path, params: req_params
        expect(response).to have_http_status(302)
      end
      # *****************************************************:
      # ********通らない************************************:
      # (リダイレクトのコード書いてないからできない？)
      it 'ログインページにリダイレクトされること' do
        post user_session_path, params: req_params
        expect(response).to redirect_to new_user_session_path
      end
      # *****************************************************:
      # *****通らない*******************************************:
      it 'エラー（フラッシュ）メッセージが表示されること' do
        post user_session_path, params: req_params
        # expect(response.body).to include 'メールアドレスかパスワードが違います'
        expect(page).to have_selector '.alert_danger',text:'メールアドレスかパスワードが違います'
        # *****************************************************:
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
    # 存在しない(DBに登録されていない)ユーザー
    let (:new_user) { FactoryBot.build(:user) }
    let (:req_params) { { session_form: { email: user.email, password: user.password } } }

    describe '全て正しい情報を入力した場合' do
      let (:user) { new_user }
      it '登録に成功すること' do
        post user_registration_path, params: req_params
        expect(response).to have_http_status(200)
      end
       # *****通らない*******************************************:
      it 'ログイン後トップページにリダイレクトされること' do
        post user_session_path, params: req_params
        expect(response).to redirect_to events_path
      end
      # *****************************************************:
    end
  end




# ***************************************************:
  # let(:user_1) { FactoryBot.create(:user, name: 'ユーザー1', email: 'test1@test.co.jp') }
  # let(:user_2) { FactoryBot.create(:user, name: 'ユーザー2', email: 'test2@test.co.jp') }

  # before do
  #   visit new_user_session_path
  #   fill_in 'メールアドレス', with: login_user.email
  #   fill_in 'パスワード', with: login_user.password
  #   click_button 'Login'
  # end

  # describe 'ユーザー一覧ページ' do
  #   describe 'ユーザー1がログインしているとき' do
  #     let(:login_user) { user_1 }
  #     context "ページが正しく表示される" do
  #       before do
  #         get users_path
  #       end
  #       it 'リクエストは200 OKとなること' do
  #         expect(response.status).to eq 200
  #       end
  #     end
  #   end
  # end
# ***************************************************:
  # describe 'ユーザー詳細ページ' do
  #   context "ページが正しく表示される" do
  #     before do
  #       get user_path(user_1)
  #     end
  #     it 'リクエストは200 OKとなること' do
  #       expect(response.status).to eq 200
  #     end
  #   end
    # describe 'ユーザー2がログインしているとき' do
    #   let(:login_user) {user_2}
    #   context "ユーザー１のページは表示されない" do
    #     before do
    #       get users_path
    #     end
    #     it 'リクエストは302となること' do
    #       expect(response.status).to eq 302
    #     end
    #     it 'ログインページにリダイレクトされるか' do
    #       expect(response).to redirect_to new_user_session_path
    #     end
    #   end
    # end
  # end
# ***************************************************:
  # describe 'ユーザー編集ページ' do
  #   context "ページが正しく表示される" do
  #     before do
  #       get edit_user_path(user_1)
  #     end
  #     it 'リクエストは200 OKとなること' do
  #       expect(response.status).to eq 200
  #     end
  #   end
  # end
end
