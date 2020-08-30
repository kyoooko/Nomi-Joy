FactoryBot.define do
  factory :event do
    name { Faker::Lorem.characters(number: 10) }
    date { '2020-08-28 00:00:00' }
    begin_time { '2020-08-28 18:00:00' }
    finish_time { '2020-08-28 21:00:00' }
    memo { Faker::Lorem.characters(number: 20) }
    # progress_status { Faker::Number.between(from: 0, to: 3) }
    progress_status { 0 }
    restaurant
    user
  end
end
