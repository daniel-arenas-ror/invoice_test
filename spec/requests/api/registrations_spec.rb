require 'rails_helper'

RSpec.describe "Api::Registrations", type: :request do
  describe "POST /api/registrations" do
    let(:params) { { name: "Dan", email: "Dan@Example.com", password: "password123" } }

    it "creates the user and returns a valid token" do
      expect {
        post "/api/registrations", params: params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)

      user = User.last
      expect(user.email).to eq("dan@example.com")
      expect(json["user"]["id"]).to eq(user.id)

      payload = JwtService.decode(json["token"], audience: "admin").first
      expect(payload["sub"]).to eq(user.id.to_s)
    end

    it "does not expose the encrypted password" do
      post "/api/registrations", params: params, as: :json

      expect(json["user"]).not_to have_key("encrypted_password")
    end

    it "returns errors when the params are invalid" do
      expect {
        post "/api/registrations", params: params.merge(password: "123"), as: :json
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("Password is too short (minimum is 6 characters)")
    end

    it "returns errors when the email is taken" do
      create(:user, email: "dan@example.com")

      post "/api/registrations", params: params, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("Email has already been taken")
    end
  end
end
