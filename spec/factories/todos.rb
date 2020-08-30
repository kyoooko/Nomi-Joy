FactoryBot.define do
  factory :todo do
    task { Faker::Lorem.characters(number: 10) }
    user
  end
end
