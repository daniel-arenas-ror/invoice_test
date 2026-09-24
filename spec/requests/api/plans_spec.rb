require 'rails_helper'

RSpec.describe "Api::Plans", type: :request do
  describe "GET /api/plans" do
    it "returns the plans in JSON:API format" do
      create_list(:plan, 2)

      get "/api/plans"

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(2)
      expect(json["data"].first["type"]).to eq("plan")
    end

    it "paginates the results" do
      create_list(:plan, 3)

      get "/api/plans", params: { page: 2, per_page: 2 }

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(1)
      expect(response.headers["Total"]).to eq("3")
    end
  end

  describe "GET /api/plans/:id" do
    it "returns the plan" do
      plan = create(:plan, speed: 300, price: 85_000)

      get "/api/plans/#{plan.id}"

      expect(response).to have_http_status(:ok)
      expect(json["data"]).to include("id" => plan.id.to_s, "type" => "plan")
      expect(json["data"]["attributes"]).to eq("speed" => 300, "price" => 85_000)
    end

    it "returns 404 when the plan does not exist" do
      get "/api/plans/0"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/plans" do
    it "creates a plan" do
      expect {
        post "/api/plans", params: { plan: { speed: 300, price: 85_000 } }, as: :json
      }.to change(Plan, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]).to eq("speed" => 300, "price" => 85_000)
    end

    it "returns errors when the params are invalid" do
      expect {
        post "/api/plans", params: { plan: { speed: 0, price: nil } }, as: :json
      }.not_to change(Plan, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("speed", "price")
    end
  end

  describe "PATCH /api/plans/:id" do
    let(:plan) { create(:plan) }

    it "updates the plan" do
      patch "/api/plans/#{plan.id}", params: { plan: { price: 99_000 } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(plan.reload.price).to eq(99_000)
    end

    it "returns errors when the params are invalid" do
      patch "/api/plans/#{plan.id}", params: { plan: { price: -1 } }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]["price"]).to include("must be greater than 0")
    end
  end
end
