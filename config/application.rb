require_relative "boot"

require "rails/all"
require "active_support"
require 'active_support/number_helper'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InvestServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    ######
    #  export EDITOR="vi"
    #  jq <~/Downloads/client_secret_308870415185-p70e99cg6o8qb4c0ct4gvgb89c6o72ia.apps.googleusercontent.com.json  >x.x
    #  rails credentials:edit --environment development
    #  
    #  In production I had to add to the .bashrc the line:
    #  export RAILS_MASTER_KEY=<contents of config/credentials/production.key>
    #  and also add into /etc/systemd/system/myrails.service the line
    #  Environment=RAILS_MASTER_KEY=<contents of config/credentials/production.key>
    #  [production.key is not in git]
    #  [the myrails.service is what runs when rails starts at runtime]
    #  
    #  Note - I had to add a "test user" - my gmail - it was a bit hard to find - see APIs and Services and then OAuth Consent Screen
    #  Note that to test using the broswer make sure you use the ngrok url and not the localhost
    #      https://onomatopoetically-noncataclysmic-glenda.ngrok-free.dev/auth/google_oauth2
    # NOTE - when testing the dashboard app you need to be used the ngrok and not localhost
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :google_oauth2,
        Rails.application.credentials.dig(:google, :client_id),
        Rails.application.credentials.dig(:google, :client_secret),
        {
          redirect_uri: Rails.application.credentials.dig(:google, :redirect_uris),
          scope: [
            'email',
            'profile',
            'https://www.googleapis.com/auth/calendar',
          ].join(' '),
          access_type: 'offline',
          prompt: 'consent',
          include_granted_scopes: true
        }
      end

      OmniAuth.config.allowed_request_methods = [:get, :post]
    #
    ######
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    puts 'config.root = ' + config.root.to_s
    config.autoload_paths += %W(#{config.root}/lib)
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8

    # AUTHENTICATION
    config.require_authentication = ENV["REQUIRE_AUTH"].present?
  end
end
