require 'rails_helper'

RSpec.describe "Api::PlanInvoices", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:plan) { create(:plan) }
  let(:base_path) { "/api/users/#{user.id}/plan_invoices" }

  describe "authentication" do
    it "returns 401 without a token" do
      get base_path

      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq("error" => "unauthorized")
    end

    it "returns 401 with an invalid token" do
      get base_path, headers: { "Authorization" => "Bearer not-a-token" }

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 when the token's user no longer exists" do
      stale_headers = auth_headers(user)
      user.destroy

      get base_path, headers: stale_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/users/:user_id/plan_invoices" do
    it "returns only that user's invoices" do
      own = create_list(:plan_invoice, 2, user: user)
      create(:plan_invoice)

      get base_path, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["data"].map { |i| i["id"] }).to match_array(own.map { |i| i.id.to_s })
    end

    it "includes the plan relationship" do
      create(:plan_invoice, user: user, plan: plan)

      get base_path, headers: headers

      expect(json["data"].first["relationships"]["plan"]["data"]).to eq("id" => plan.id.to_s, "type" => "plan")
    end

    it "paginates the results" do
      create_list(:plan_invoice, 3, user: user)

      get base_path, params: { page: 2, per_page: 2 }, headers: headers

      expect(json["data"].size).to eq(1)
      expect(response.headers["Total"]).to eq("3")
    end
  end

  describe "GET /api/users/:user_id/plan_invoices/:id" do
    it "returns the invoice" do
      invoice = create(:plan_invoice, user: user, invoice_date: Date.new(2026, 9, 1))

      get "#{base_path}/#{invoice.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["data"]).to include("id" => invoice.id.to_s, "type" => "plan_invoice")
      expect(json["data"]["attributes"]["invoice_date"]).to eq("2026-09-01")
    end

    it "returns 404 for another user's invoice" do
      other_invoice = create(:plan_invoice)

      get "#{base_path}/#{other_invoice.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/users/:user_id/plan_invoices" do
    it "creates an invoice for the user" do
      expect {
        post base_path, params: { plan_invoice: { invoice_date: "2026-09-01", plan_id: plan.id } }, headers: headers, as: :json
      }.to change(user.plan_invoices, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]["invoice_date"]).to eq("2026-09-01")
    end

    it "returns errors when the plan does not exist" do
      expect {
        post base_path, params: { plan_invoice: { invoice_date: "2026-09-01", plan_id: 0 } }, headers: headers, as: :json
      }.not_to change(PlanInvoice, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]["plan"]).to include("must exist")
    end
  end

  describe "PATCH /api/users/:user_id/plan_invoices/:id" do
    it "updates the invoice" do
      invoice = create(:plan_invoice, user: user)

      patch "#{base_path}/#{invoice.id}", params: { plan_invoice: { invoice_date: "2026-10-01" } }, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      expect(invoice.reload.invoice_date).to eq(Date.new(2026, 10, 1))
    end
  end
end
