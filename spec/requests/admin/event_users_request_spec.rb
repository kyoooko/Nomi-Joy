require 'rails_helper'

RSpec.describe "Admin::EventUsers", type: :request do
  # ログインしているユーザー／カンジ
  let!(:user) { create(:user) }
  # ログインしていないユーザー
  let!(:user_2) { create(:user) }
  let!(:restaurant) { create(:restaurant, user_id: user.id) }
  let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user.id) }
  let!(:event_user) { create(:event_user, user_id: user.id, event_id: event.id) }
  # ユーザー２は支払済
  # let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id, fee_status: true) }
  let(:event_user_params) { { fee: 10000, event_id: event.id, user_id: user.id } }
  let(:empty_event_user_params) { { fee: "", event_id: event.id, user_id: user.id } }
  let(:paid_event_user_params) { { fee_status: true, event_id: event.id, user_id: user.id } }
  let(:absent_event_user_params) { { deleted_at: Time.now, event_id: event.id, user_id: user.id } }

  # fee_update
  describe "会費変更(PATCH #fee_update)" do
    context "未ログインの場合" do
      it "Unauthorizedエラーが出ること" do
        patch admin_event_users_fee_path(event_user.id), params: { event_user: event_user_params }, xhr: true
        expect(response.status).to eq 401
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        context "金額を入力した場合" do
          it "リクエストが成功すること" do
            patch admin_event_users_fee_path(event_user.id), params: { event_user: event_user_params }, xhr: true
            # 非同期なので302でなく200
            expect(response).to have_http_status "200"
          end

          it "金額が変更されていること" do
            patch admin_event_users_fee_path(event_user.id), params: { event_user: event_user_params }, xhr: true
            expect(event_user.reload.fee).to eq 10000
          end
        end

        context "金額を入力しなかった場合" do
          it "リクエストが成功すること" do
            patch admin_event_users_fee_path(event_user.id), params: { event_user: empty_event_user_params }, xhr: true
            # 非同期なので302でなく200
            expect(response).to have_http_status "200"
          end

          it "金額が0円で変更されていること" do
            patch admin_event_users_fee_path(event_user.id), params: { event_user: empty_event_user_params }, xhr: true
            expect(event_user.reload.fee).to eq 0
          end
        end

        # context "支払済ユーザーの場合" do
        #   it "金額が更新されないこと" do
        #     patch admin_event_users_fee_path(event_user_2.id), params: { event_user: event_user_params }, xhr: true
        #     binding.pry
        #     expect(event_user.reload.fee).to eq 3000
        #   end
        # end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          patch admin_event_users_fee_path(event_user.id), params: { event_user: empty_event_user_params }, xhr: true
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "会費ステータス変更(PATCH #fee_status_update)" do
    context "未ログインの場合" do
      it "Unauthorizedエラーが出ること" do
        patch admin_event_users_fee_status_path(event_user.id), params: { event_user: paid_event_user_params }, xhr: true
        expect(response.status).to eq 401
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          patch admin_event_users_fee_status_path(event_user.id), params: { event_user: paid_event_user_params }, xhr: true
          # 非同期なので302でなく200
          expect(response).to have_http_status "200"
        end

        it "変更されること" do
          patch admin_event_users_fee_status_path(event_user.id), params: { event_user: paid_event_user_params }, xhr: true
          expect(event_user.reload.fee_status).to eq true
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          patch admin_event_users_fee_status_path(event_user.id), params: { event_user: paid_event_user_params }, xhr: true
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "参加ステータス変更(PATCH #participate_status_update)" do
    context "未ログインの場合" do
      it "Unauthorizedエラーが出ること" do
        patch admin_event_users_participate_status_path(event_user.id), params: absent_event_user_params, xhr: true
        expect(response.status).to eq 401
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          patch admin_event_users_participate_status_path(event_user.id), params: absent_event_user_params, xhr: true
          # 非同期なので302でなく200
          expect(response).to have_http_status "200"
        end

        it "変更されること（論理削除されたこと）" do
          patch admin_event_users_participate_status_path(event_user.id), params: absent_event_user_params, xhr: true
          # 論理削除されるのでwith_deletedつけないとカウントされない
          expect(EventUser.where(event_id: event.id).count == 0).to be_truthy
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          patch admin_event_users_participate_status_path(event_user.id), params: absent_event_user_params, xhr: true
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
