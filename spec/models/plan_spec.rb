require 'rails_helper'

RSpec.describe Plan, type: :model do
  subject { build(:plan) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it "persists speed and price" do
    plan = create(:plan, speed: 300, price: 85_000)

    expect(plan.reload).to have_attributes(speed: 300, price: 85_000)
  end

  describe "validations" do
    it { should validate_presence_of :speed }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:speed).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:price).only_integer.is_greater_than(0) }
  end

  describe "associations" do
    it { should have_many(:plan_invoices).dependent(:restrict_with_error) }

    it "cannot be destroyed while it has invoices" do
      plan = create(:plan_invoice).plan

      expect(plan.destroy).to be(false)
      expect(plan.errors[:base]).to include("Cannot delete record because dependent plan invoices exist")
      expect(Plan.exists?(plan.id)).to be(true)
    end
  end
end
