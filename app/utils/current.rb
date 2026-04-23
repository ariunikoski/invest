class Current < ActiveSupport::CurrentAttributes
  attribute :holder

  #
  # This looks like it is currently failing because it never seems to think this is not set -
  # I need to confirm this however and if so find  our why and how to get around it
  def self.get_oauth_credentials
    Log.info(">>> v3.0 get_oauth_credentials called")
    Holder.find_by(default: true)
#    creds = Rails.cache.read(:google_creds)
#    Log.info(">>> v2.4 get_oauth_credentials called - does it exist? #{creds.to_s}")
#    if !creds
#      creds = Google::OauthCredentials.new
#      creds.debug_date = Time.now
#      Log.info(">>> after assignment creds is: #{creds.to_s}")
#      Rails.cache.write(:google_creds, creds.to_s)
#      Log.info(">>> reread test: #{Rails.cache.read(:google_creds.to_s)}")
#    end
#    creds
  end
end
