require 'rails_helper'

RSpec.describe PlanInvoice, type: :model do
  subject { build(:plan_invoice) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:plan) }
  end

  it "is listed in the user's plan invoices" do
    invoice = create(:plan_invoice)

    expect(invoice.user.plan_invoices).to contain_exactly(invoice)
  end
end
