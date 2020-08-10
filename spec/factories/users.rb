FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    nomi_joy_id {'nomijoy1'}
    belongs {Faker::Lorem.characters(number: 10)}
    position {Faker::Lorem.characters(number: 5)}
    # image_id {File.open("./app/assets/images/haru.jpg", ?r)}
    image_id { 'f5dd194cd609427bf29481c5850c0aa3081cccfc3954b1485ce52787a372'}
    nearest_station {Faker::Lorem.characters(number: 5)}
    can_drink { true }
    favolite {Faker::Lorem.characters(number: 10)}
    unfavolite {Faker::Lorem.characters(number: 10)}
    introduction { Faker::Lorem.characters(number: 20) }
  end
end
