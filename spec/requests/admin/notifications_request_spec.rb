require 'rails_helper'

RSpec.describe "Admin::Notifications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/notifications/index"
      expect(response).to have_http_status(:success)
    end
  end
end
