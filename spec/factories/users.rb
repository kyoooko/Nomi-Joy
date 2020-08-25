FactoryBot.define do
  factory :user, aliases: [:following, :follower, :visited, :visitor] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    nomi_joy_id { 'nomijoy1' }
    belongs { Faker::Lorem.characters(number: 10) }
    position { Faker::Lorem.characters(number: 5) }
    image_id { 'f5dd194cd609427bf29481c5850c0aa3081cccfc3954b1485ce52787a372' }
    nearest_station { Faker::Lorem.characters(number: 5) }
    can_drink { true }
    favolite { Faker::Lorem.characters(number: 10) }
    unfavolite { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }

    # アソシエーションを一括生成
    # after(:create) do |user|
    #   create(:restaurant, use: user)
    #   create(:event, user: user, restaurant: restaurant)
    #   create(:event_user, user: user, event: event)
    # end
  end
end
