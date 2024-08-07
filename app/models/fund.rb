class Fund < ApplicationRecord
  has_many :links, as: :linked_to, dependent: :destroy
  has_many :holdings, as: :held_by, dependent: :destroy
end
