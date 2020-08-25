FactoryBot.define do
  factory :restaurant do
    name { Faker::Lorem.characters(number: 10) }
    address { Faker::Lorem.characters(number: 20) }
    access { Faker::Lorem.characters(number: 20) }
    url { Faker::Lorem.characters(number: 20) }
    shop_image { '' }
    tel { Faker::Lorem.characters(number: 12) }
    opentime { Faker::Lorem.characters(number: 20) }
    holiday { Faker::Lorem.characters(number: 20) }
    user
  end
end
