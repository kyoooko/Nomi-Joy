require 'rails_helper'

RSpec.describe "Admin::Rooms", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/admin/rooms/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/admin/rooms/index"
      expect(response).to have_http_status(:success)
    end
  end
end
