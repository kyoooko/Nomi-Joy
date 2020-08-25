# require 'rails_helper'

# RSpec.describe "Admin::Notifications", type: :request do
#   describe "GET /index" do
#     it "returns http success" do
#       get "/admin/notifications/index"
#       expect(response).to have_http_status(:success)
#     end
#   end

# ノミカイ（ユーザー１がカンジでユーザー２は会費未払い）
# let!(:restaurant) { create(:restaurant, user_id: user_1.id) }
# let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user_1.id) }
# let!(:event_user_1) { create(:event_user, user_id: user_1.id, event_id: event.id) }
# let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id, fee_status: false) }

# end
