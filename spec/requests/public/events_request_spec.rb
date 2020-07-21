require 'rails_helper'

RSpec.describe "Public::Events", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/public/events/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/events/show"
      expect(response).to have_http_status(:success)
    end
  end
end
