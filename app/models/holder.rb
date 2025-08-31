class Holder < ApplicationRecord
  has_many :shares, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :colour, presence: true
  validates :default, inclusion: { in: [true, false] }

  # Ensure only one holder can be default
  validate :only_one_default, if: :default?

  private

  def only_one_default
    if Holder.where(default: true).where.not(id: id).exists?
      errors.add(:default, "can only be true for one holder")
    end
  end
end

