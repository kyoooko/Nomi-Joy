class Relationship < ApplicationRecord
  # フォローする側のUserを「following」と定義
  belongs_to :following, class_name: "User", optional: true
  # フォローされる側のUserを「follower」と定義
  belongs_to :follower, class_name: "User", optional: true
end
