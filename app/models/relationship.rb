class Relationship < ApplicationRecord
  belongs_to :following
  belongs_to :followed
end
