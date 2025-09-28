class User < ApplicationRecord
  has_secure_password   # Adds password handling and authentication
  has_many :tokens, dependent: :destroy
end
