require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/admin/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/users/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
