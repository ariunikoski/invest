class Token < ApplicationRecord
  belongs_to :user
  before_create :generate_value

  private

  def generate_value
    self.value ||= SecureRandom.hex(32)
  end
end
