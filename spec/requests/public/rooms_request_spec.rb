require 'rails_helper'

RSpec.describe "Public::Rooms", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/public/rooms/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/public/rooms/index"
      expect(response).to have_http_status(:success)
    end
  end

end
