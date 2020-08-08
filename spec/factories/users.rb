FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    nomi_joy_id {'nomijoy1'}
    belongs {Faker::Lorem.characters(number: 10)}
    position {Faker::Lorem.characters(number: 5)}
    image_id {''}
    nearest_station {Faker::Lorem.characters(number: 5)}
    can_drink {'true'}
    favolite {Faker::Lorem.characters(number: 10)}
    unfavolite {Faker::Lorem.characters(number: 10)}
    introduction { Faker::Lorem.characters(number: 20) }
  end
end
