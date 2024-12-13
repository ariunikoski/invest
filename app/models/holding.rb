class Holding < ApplicationRecord
  belongs_to :held_by, polymorphic: true
  has_many :sales, dependent: :destroy
end
