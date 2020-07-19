class EventUser < ApplicationRecord
  #paranoia
  acts_as_paranoid 
  
  belongs_to :user
  belongs_to :event
end
