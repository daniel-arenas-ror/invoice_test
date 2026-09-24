require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }

  it "requires a unique email" do
    create(:user, email: "duplicate@email.com")
    dupplicate = build(:user, email: "duplicate@email.com")

    expect(dupplicate).not_to be_valid
    expect(dupplicate.errors[:email]).to include("has already been taken")
  end
end
