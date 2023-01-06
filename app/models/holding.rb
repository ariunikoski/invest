class Holding < ApplicationRecord
  belongs_to :held_by, polymorphic: true
end
