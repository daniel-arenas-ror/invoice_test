FactoryBot.define do
  factory :plan do
    speed { Faker::Number.between(from: 10, to: 1000) }
    price { Faker::Number.between(from: 20_000, to: 200_000) }
  end
end
