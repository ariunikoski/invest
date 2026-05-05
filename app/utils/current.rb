class Current < ActiveSupport::CurrentAttributes
  attribute :holder

  # - Safest way to handle this is to always retrieve it from the database
  def self.get_oauth_credentials
    Holder.find_by(default: true)
  end
end
