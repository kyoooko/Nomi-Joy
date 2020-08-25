class Todo < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :task
    validates :user_id
  end
end
