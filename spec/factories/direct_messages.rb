FactoryBot.define do
  factory :direct_message do
    message { Faker::Lorem.characters(number: 20) }
    user
    room
  end
end
