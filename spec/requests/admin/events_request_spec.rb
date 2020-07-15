require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/admin/events/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/events/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/events/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/admin/events/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/events/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/events/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /progress_status_update" do
    it "returns http success" do
      get "/admin/events/progress_status_update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /fee_status_update" do
    it "returns http success" do
      get "/admin/events/fee_status_update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /confirm_plan_remind" do
    it "returns http success" do
      get "/admin/events/confirm_plan_remind"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /send_plan_remind" do
    it "returns http success" do
      get "/admin/events/send_plan_remind"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step1" do
    it "returns http success" do
      get "/admin/events/step1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step2" do
    it "returns http success" do
      get "/admin/events/step2"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /confirm" do
    it "returns http success" do
      get "/admin/events/confirm"
      expect(response).to have_http_status(:success)
    end
  end

end
