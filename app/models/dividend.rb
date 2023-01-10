class Dividend < ApplicationRecord
  belongs_to :share
  default_scope { order(x_date: :desc) }
end
