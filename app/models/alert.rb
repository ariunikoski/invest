class Alert < ApplicationRecord
  belongs_to :share

  STATUSES = %w[NEW RENEW REVIEWED IGNORE IGNORE_UNTIL FINISHED].freeze
  TYPES    = [
    "DIV OVERDUE",
    "NO DIV LAST YEAR",
    "DIV UP A LOT",
    "DIV DOWN A LOT"
  ].freeze

  validates :alert_status, presence: true, inclusion: { in: STATUSES }
  validates :alert_type, presence: true, inclusion: { in: TYPES }
end
