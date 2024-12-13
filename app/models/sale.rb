class Sale < ApplicationRecord
  belongs_to :share
  belongs_to :holding

  validates :sale_date, :amount, :sale_price, presence: true
end
