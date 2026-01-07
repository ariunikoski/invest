include PillData
class Alert < ApplicationRecord
  belongs_to :share

  STATUSES = %w[NEW RENEW REVIEWED IGNORE IGNORE_UNTIL FINISHED].freeze
  TYPES    = ALERT_TO_PILL.keys.sort.freeze

  validates :alert_status, presence: true, inclusion: { in: STATUSES }
  validates :alert_type, presence: true, inclusion: { in: TYPES }
end
