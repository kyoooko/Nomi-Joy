FactoryBot.define do
  factory :relationship do
    association :following
    association :follower
    # following
    # follower
  end
end
