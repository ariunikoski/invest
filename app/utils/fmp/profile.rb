
require "net/http"
require "json"
require "uri"

module Fmp
  class Profile
    BASE_URL = "https://financialmodelingprep.com/stable"

    def initialize()
      @api_key = '4VJdLdjo4CD6DcDMzjc7VKPyTloTmV2A'
      @sector = nil
      @industry = nil
      @summary = nil
    end

    def load(symbol)
      company_profile(symbol)
    rescue => e
      Log.error("Fmp load failed with #{e.message}")
      puts("Fmp load failed with #{e.message}")
      {
        symbol: symbol,
        sector: @sector,
        industry: @industry,
        summary: @summary,
        error: e.message
      }
    end

    def company_profile(symbol)
      uri = URI("#{BASE_URL}/profile")
      uri.query = URI.encode_www_form(
        symbol: symbol,
        apikey: @api_key
      )

      res = Net::HTTP.get_response(uri)

      raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)

      data = JSON.parse(res.body)

      raise "No data returned for #{symbol}" if data.empty?

      profile = data.first

      @sector = profile["sector"]
      @industry = profile["industry"]
      @summary = profile["description"]
      {
        symbol: symbol,
        sector: @sector,
        industry: @industry,
        summary: @summary
      }
    end
  end
end
