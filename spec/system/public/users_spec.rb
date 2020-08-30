require 'rails_helper'

RSpec.describe "Public::Users", type: :system do
  let!(:user_A) { FactoryBot.create(:user, name: 'ユーザーA') }
  let!(:user_B) { FactoryBot.create(:user, name: 'ユーザーB') }
  let!(:user_C) { FactoryBot.create(:user, name: 'ユーザーC') }

  before do
    visit new_user_session_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'Login'
  end

  describe 'ユーザー一覧ページ' do
    before do
      FactoryBot.create(:relationship, following_id: user_A.id, follower_id: user_C.id)
      FactoryBot.create(:relationship, following_id: user_C.id, follower_id: user_A.id)
    end

    context 'ユーザーAがログインしている場合' do
      let(:login_user) { user_A }

      before do
        visit users_path
      end

      it 'ユーザーAとマッチングしたユーザーCが表示される' do
        expect(page).to have_content 'ユーザーC'
      end
    end

    context 'ユーザーBがログインしている場合' do
      let(:login_user) { user_B }

      before do
        visit users_path
      end

      it 'ユーザーBとマッチングしていないユーザーC表示されない' do
        expect(page).to have_no_content 'ユーザーC'
      end
    end
  end

  describe 'ユーザー詳細ページ' do
    let(:login_user) { user_A }
    let(:other_user) { user_B }

    context 'ログインしているユーザーが自分の詳細ページを見る場合' do
      before do
        visit user_path(login_user)
      end

      it 'マイページ仕様で表示される' do
        expect(page).to have_content 'マイページ'
      end
    end

    context 'ログインしているユーザーが他のノミカイメンバーの詳細ページを見る場合' do
      before do
        visit user_path(other_user)
      end

      it '' do
        expect(page).to have_no_content 'マイページ'
      end
    end
  end
end
