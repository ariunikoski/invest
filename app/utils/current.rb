class Current < ActiveSupport::CurrentAttributes
  attribute :holder
  attribute :oauth

  def self.get_yahoo_oauth(session)
    oauth ||= Yahoo::Oauth.new(session)
  end
end
