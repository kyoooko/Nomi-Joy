class Notification < ApplicationRecord
  belongs_to :visiter
  belongs_to :visited
end
