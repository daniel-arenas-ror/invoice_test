require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe "GET /api/users" do
    it "returns all users in JSON:API format" do
      create_list(:user, 2)

      get "/api/users"

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(2)
      expect(json["data"].first["type"]).to eq("user")
    end
  end

  describe "GET /api/users/:id" do
    it "returns the user" do
      user = create(:user)

      get "/api/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(json["data"]).to include("id" => user.id.to_s, "type" => "user")
      expect(json["data"]["attributes"]).to eq("name" => user.name, "email" => user.email)
    end

    it "returns 404 when the user does not exist" do
      get "/api/users/0"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/users" do
    let(:valid_params) { { user: { name: "Dan", email: "dan@example.com", password: "password123" } } }

    it "creates a user" do
      expect {
        post "/api/users", params: valid_params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]).to eq("name" => "Dan", "email" => "dan@example.com")
    end

    it "returns errors when the params are invalid" do
      expect {
        post "/api/users", params: { user: { name: "", email: "dan@example.com", password: "password123" } }, as: :json
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]["name"]).to include("can't be blank")
    end

    it "returns 400 when the user params are empty" do
      post "/api/users", params: { user: {} }, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PATCH /api/users/:id" do
    let(:user) { create(:user) }

    it "updates the user" do
      patch "/api/users/#{user.id}", params: { user: { name: "New Name" } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq("New Name")
      expect(json["data"]["attributes"]["name"]).to eq("New Name")
    end

    it "returns errors when the params are invalid" do
      patch "/api/users/#{user.id}", params: { user: { email: "not-an-email" } }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]["email"]).to include("is invalid")
      expect(user.reload.email).not_to eq("not-an-email")
    end
  end
end
