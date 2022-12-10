class Link < ApplicationRecord
  belongs_to :linked_to, polymorphic: true
end
