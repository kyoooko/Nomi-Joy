FactoryBot.define do
  factory :notification do
    action { "" }
    checked { Faker::Boolean.boolean }
    event
    direct_message_id {}
    # visitor
    # visited
    association :visitor
    association :visited
  end
end
