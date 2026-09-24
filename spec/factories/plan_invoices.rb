FactoryBot.define do
  factory :plan_invoice do
    invoice_date { Date.current }
    user
    plan
  end
end
