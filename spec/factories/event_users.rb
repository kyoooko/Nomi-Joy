FactoryBot.define do
  factory :event_user do
    fee { Faker::Number.number(digits: 4) }
    fee_status { Faker::Boolean.boolean }
    deleted_at { '' }
    user
    event
  end
end
