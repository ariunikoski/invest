class User < ApplicationRecord
  has_secure_password   # Adds password handling and authentication
  has_many :tokens, dependent: :destroy
  belongs_to :restricted_to_holder,
             class_name: 'Holder',
             optional: true
end
