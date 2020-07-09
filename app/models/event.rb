class Event < ApplicationRecord
  belongs_to :restaurant_id
  belongs_to :user_id
end
