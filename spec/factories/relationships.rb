FactoryBot.define do
  factory :relationship do
    association :following
    association :follower
  end
end