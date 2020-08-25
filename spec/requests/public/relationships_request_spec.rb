require 'rails_helper'

RSpec.describe "Public::Relationships", type: :request do
  let(:following) { create(:user) }
  let(:follower) { create(:user) }

  describe "POST #create" do
    context "ログインしている場合" do
      before do
        sign_in following
      end

      it "非同期によるフォローのリクエストが成功すること" do
        post user_relationships_path(follower.id), xhr: true
        expect(response).to have_http_status "200"
      end
      it "非同期によるフォロー関係の作成に成功すること" do
        expect do
          post user_relationships_path(follower.id), xhr: true
        end.to change(Relationship, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:follow) { Relationship.create(following_id: following.id, follower_id: follower.id) }

    context "ログインしている場合" do
      before do
        sign_in following
      end

      it "非同期によるアンフォローのリクエストが成功すること" do
        delete user_relationships_path(follower.id), xhr: true
        expect(response.status).to eq 200
      end
      it "非同期によるフォロー関係が削除されること" do
        expect do
          delete user_relationships_path(follower.id), xhr: true
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
