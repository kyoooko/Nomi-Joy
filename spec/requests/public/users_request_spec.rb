require 'rails_helper'

RSpec.describe "Public::Users", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/public/users/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/public/users/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
