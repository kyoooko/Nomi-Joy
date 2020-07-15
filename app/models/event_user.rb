class EventUser < ApplicationRecord
  belongs_to :user
  belongs_to :event

  #paranoia
  acts_as_paranoid 
end
