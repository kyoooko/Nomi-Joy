FactoryBot.define do
  factory :notification do
    action { "follow" }
    checked { Faker::Boolean.boolean } 
    event
    direct_message
    visitor
    visited
    # association :visitor
    # association :visited
  end
end