require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_length_of(:password).is_at_least(6) }

    it "requires a unique email" do
      create(:user, email: "duplicate@email.com")
      duplicate = build(:user, email: "duplicate@email.com")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "treats emails as case insensitive" do
      create(:user, email: "duplicate@email.com")
      duplicate = build(:user, email: "DUPLICATE@email.com")

      expect(duplicate).not_to be_valid
    end

    it "rejects an invalid email format" do
      subject.email = "not-an-email"

      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("is invalid")
    end
  end

  describe "associations" do
    it { should have_many(:plan_invoices) }
  end
end
