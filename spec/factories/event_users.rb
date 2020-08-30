FactoryBot.define do
  factory :event_user do
    # fee { Faker::Number.number(digits: 4) }
    fee { 3000 }
    fee_status { false }
    deleted_at { '' }
    user
    event
  end
end
